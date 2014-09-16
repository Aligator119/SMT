#import "DataLoader.h"
#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"
#import "UserInfo.h"
#import "AppDelegate.h"
#import "FBConnectClass.h"
#import "ConstantsClass.h"
#import "NSString+HTML.h"
#import "SearchingBuddy.h"
#import "BuddySearchViewController.h"
#import "Activity.h"
#import "ActivityDetails.h"
#import "AFNetworking.h"
#import "ReportsActivity.h"

#define RequestPost @"POST"
#define RequestGet @"GET"
#define RequestDelete @"DELETE"
#define RequestPut @"PUT"
#define RequesPatch @"PATCH"

#define App_id @"b63800ad"
#define App_key @"34eddb50efc407d00f3498dc1874526c"

#define APP_ID_KEY @"app_id=b63800ad&app_key=34eddb50efc407d00f3498dc1874526c"
#define URL_USER_LOGIN @"user=%@&password=%@&%@"
#define URL_USER_CREATE @"firstname=%@&lastname=%@&username=%@&password=%@&birthYear=%@&sex=%@&%@"
#define URLSportsMaster @"http://devapi.sportsmantracker.com/v2/"

#define SubstringLogin @"login"
#define SubstringRegister @"user"
#define SubstringLocations @"locations/"
#define SubstringLocation @"location/"
#define SubstringBuddies @"buddy"
#define SubstringSpecies @"species"
#define SubstringSubSpecies @"subspecies"
#define SubstringCurrentLocation @"current_location"
#define SubstringPhoto @"photo"
#define SubstringLogdetail @"logdetail"
#define SubstringQuestions @"questions"
#define SubstringKilling @"killing"

@implementation DataLoader
{
    BOOL bbb;
}

@synthesize typeOfServiceRequest;

- (id)init
{
    self = [super init];
    
    if (self)
    {
        strUrl = @"http://devapi.sportsmantracker.com/v2/";
        appDel = (AppDelegate*) [UIApplication sharedApplication].delegate;
        [self setInitialData];
    }
    return self;
}

+ (DataLoader *)instance
{
    static DataLoader *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DataLoader alloc] init];
    });
    return instance;
}

- (void)setInitialData
{
    keyUsername = @"Username";
    keyUserID = @"User ID";
    keyName = @"Name";
    self.isCorrectRezult = NO;
}

#pragma mark - Helpes methods
- (NSString *) convertString:(NSString*)str
{
    NSString * result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
            NULL,(CFStringRef)str, NULL,(CFStringRef)@"!*'();:@+$,/?%#[]",kCFStringEncodingUTF8));
    
    return result;
}

#pragma  mark - Work with Server REQUEST

- (void)createUserWithFirstName:(NSString*) firstName
                     secondName:(NSString*) secondName
                       userName:(NSString*) userName
                       password:(NSString*) userPassword
                      birthYear:(int) birthYear
                            sex:(NSString*) userMale
{
//    NSString * _firstName = [self convertString:firstName];
//    NSString * _secondName = [self convertString:secondName];
//    NSString * _userName = [self convertString:userName];
//    NSString * _userPassword = [self convertString:userPassword];
    NSString * _birthYear = [NSString stringWithFormat:@"%i",birthYear];
//    NSString * _userMale = userMale;
    
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@",strUrl,SubstringRegister];
   // NSString * strUrlRequestData = [NSString stringWithFormat:URL_USER_CREATE,_firstName,_secondName,_userName,_userPassword,_birthYear,_userMale,APP_ID_KEY];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithObjects:@[firstName, secondName, userName, userPassword, _birthYear, userMale, @"b63800ad", @"34eddb50efc407d00f3498dc1874526c", @"createdWith"] forKeys:@[@"firstname", @"lastname", @"username", @"password", @"birthYear", @"sex", @"app_id", @"app_key", @"smt"]];
    
    enterPassword = userPassword;
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary *info = [self startRequest:strUrlRequestAdress andData:jsonData typeRequest:RequestPost setHeaders:NO andTypeRequest:ApplicationServiceRequestCreateUser];
    
    if (self.isCorrectRezult){
    [appDel.user setUserInfoName:[info objectForKey:keyUsername] appID:[[info objectForKey:keyUserID] intValue]];
    [appDel.user setUserInfoPassword:enterPassword];
    [appDel.user setUserName:[info objectForKey:keyName]];
    appDel.user.avatarAdress = [info objectForKey:@"Avatar"];
    
    NSDictionary *retrievedDictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:FB_USER_SIGN];
    if(retrievedDictionary == nil)
        [appDel.user saveUser];
    }
}


- (void)changeUserPassworld:(NSString *)passworld
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@user/me",strUrl];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithObjects:@[passworld, @"b63800ad",@"34eddb50efc407d00f3498dc1874526c"] forKeys:@[@"password", @"app_id", @"app_key"]];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSLog(@"%@", error);
    
    [self startRequest:strUrlRequestAdress andData:jsonData typeRequest:RequesPatch setHeaders:YES andTypeRequest:ApplicationServiceRequestCreateUser];
}


-(void) sendInvitationEmailWithEmail: (NSString*) _email andName: (NSString*) _name
{
    NSString * email = [self convertString:_email];
    NSString * name = [self convertString:_name];
    
    NSString * strUrlRequestAddress = [NSString stringWithFormat:@"http://devapi.sportsmantracker.com/v2/sendBuddyTrackingInvite/?email=%@&app=fp&name=%@&%@", email, name, APP_ID_KEY ];
    NSString * strUrlRequestData = @"";
    
     [self startRequest:strUrlRequestAddress andData:[strUrlRequestData dataUsingEncoding:NSUTF8StringEncoding] typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestSendInvitation];
}

-(void) createLocationWithName : (NSString*) name Latitude: (double) latitude Longitude: (double) longitude locationType:(NSInteger) _type
{
    
    NSString * LocationName = [self convertString:name];
    NSString * lat = [self convertString:[NSString stringWithFormat:@"%f", latitude]];
    NSString * longit = [self convertString:[NSString stringWithFormat:@"%f", longitude]];
    
   // NSString *userId = [NSString stringWithFormat:@"%d", appDel.user.userID];
    NSString *typeID = [NSString stringWithFormat: @"%d", 2];
    
    NSString * strUrlRequestAddress = @"http://devapi.sportsmantracker.com/v2/location";
  //NSString * strUrlRequestData = [NSString stringWithFormat: @"user_id=%@&type_id=2&name=%@&latitude=%@&longitude=%@&%@", userId, LocationName, lat, longit,APP_ID_KEY];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithObjects:@[typeID, LocationName, lat, longit, App_id, App_key] forKeys:@[@"type_id", @"name", @"latitude", @"longitude", @"app_id", @"app_key"]];
    
    NSError * error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    Location * location = [Location new];
    [location setValuesFromDict:[self startRequest:strUrlRequestAddress andData:jsonData typeRequest:RequestPost setHeaders:YES andTypeRequest:ApplicationServiceRequestCreateLocation]];
    [appDel.listLocations addObject:location];
}

- (void)avtorizeUser:(NSString*) userName password:(NSString*) userPassword
{
    //NSString * _userName = [self convertString:userName];
    //NSString * _userPassword = [self convertString:userPassword];
    
    enterPassword = userPassword;
    typeOfServiceRequest = ApplicationServiceRequestAvtorizeUser;
    
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@",strUrl,SubstringLogin];
   // NSString * strUrlRequestData = [NSString stringWithFormat:URL_USER_LOGIN,_userName,_userPassword,APP_ID_KEY];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithObjects:@[userName,userPassword,@"b63800ad",@"34eddb50efc407d00f3498dc1874526c"] forKeys:@[@"username", @"password", @"app_id", @"app_key"]];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
   /// NSString * jsonRequest = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
   // NSString * bodyRequest = [NSString stringWithFormat:@"data=%@", jsonRequest];
    
    NSLog(@"%@", error);
    
    NSDictionary *info = [self startRequest:strUrlRequestAdress andData:jsonData typeRequest:RequestPost setHeaders:NO andTypeRequest:ApplicationServiceRequestAvtorizeUser];
    
    if (self.isCorrectRezult){
    
    [appDel.user setUserInfoName:[info objectForKey:keyUsername] appID:[[info objectForKey:keyUserID] intValue]];
    [appDel.user setUserInfoPassword:enterPassword];
    [appDel.user setUserName:[info objectForKey:keyName]];
    appDel.user.avatarAdress = [info objectForKey:@"Avatar"];
    }
}
- (void)getLocationsAssociatedWithUser
{
    typeOfServiceRequest = ApplicationServiceRequestLocationsAssociatedWithUser;
    //NSString * strLocations = [NSString stringWithFormat:@"%i?%@",appDel.user.userID,APP_ID_KEY];
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@location?app_id=%@&app_key=%@",strUrl, App_id, App_key];

    NSLog(@"Get Locations");
    // * * * *
    NSMutableArray * listLocations = [NSMutableArray new];
    NSMutableArray * listFishLocations = [NSMutableArray new];
    NSMutableArray * listHuntLocations = [NSMutableArray new];
    NSMutableArray * listSharedHuntLocations = [NSMutableArray new];
    NSMutableArray * listSharedFishLocations = [NSMutableArray new];
    @try {
        //listLocationName = [[NSMutableArray alloc] initWithArray:info.allKeys];
        for (NSDictionary * dicInfo in [self startRequest:strUrlRequestAdress andData:nil typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestLocationsAssociatedWithUser]) {
            Location * location = [Location new];
            [location setValuesFromDict:dicInfo];
            if(![location isLocationDelete]){
                if (location.locUserId == appDel.user.userID){
                        [listLocations addObject:location];
                    if (location.typeLocation == typeFishing){
                        [listFishLocations addObject:location];
                    }
                    else if (location.typeLocation == typeHunting){
                        [listHuntLocations addObject:location];
                    }
                }
                else{
                    if (location.typeLocation == typeFishing){
                        [listSharedFishLocations addObject:location];
                    }
                    else if (location.typeLocation == typeHunting){
                        [listSharedHuntLocations addObject:location];
                    }
                }
            }
        }
        self.isCorrectRezult = YES;
    }
    @catch (NSException *exception) {
        self.isCorrectRezult = NO;
        NSLog(@"ERROR !");
    }
    //if(self.isCorrectRezult)
    appDel.listLocations = [[NSMutableArray alloc] initWithArray:listLocations];
    appDel.listFishLocations = [[NSMutableArray alloc] initWithArray:listFishLocations];
    appDel.listHuntLocations = [[NSMutableArray alloc] initWithArray:listHuntLocations];
    appDel.listSharedFishLocations = [[NSMutableArray alloc] initWithArray:listSharedFishLocations];
    appDel.listSharedHuntLocations = [[NSMutableArray alloc] initWithArray:listSharedHuntLocations];
    //else appDel.listLocations = nil;
    //NSLog(@"%@",info);

}

- (void)deleteLocationWithID:(int) _locID
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@%@",strUrl,SubstringLocation,[NSString stringWithFormat:@"%i",_locID]];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjects:@[App_id, App_key] forKeys:@[@"app_id", @"app_key"]];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    [self startRequest:strUrlRequestAdress andData:jsonData typeRequest:RequestDelete setHeaders:YES andTypeRequest:ApplicationServiceRequestDeleteLocation];
}

- (Location *)updateChooseLocation:(int)_locID
                     newName:(NSString*)_newName
                     newLati:(NSString*)_lati
                     newLong:(NSString*)_long
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@%i",strUrl,SubstringLocation,_locID];
    //NSString * strUrlRequestData = [NSString stringWithFormat:@"name=%@&latitude=%@&longitude=%@&%@",[self convertString:_newName],_lati,_long,APP_ID_KEY];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithObjects:@[_newName, _lati, _long, App_id, App_key] forKeys:@[@"name", @"latitude", @"longitude", @"app_id", @"app_key"]];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];

    Location * location = [Location new];
    [location setValuesFromDict:[self startRequest:strUrlRequestAdress andData:jsonData typeRequest:RequesPatch setHeaders:YES andTypeRequest:ApplicationServiceRequestUpdateLocation]];
    
    appDel.listFishLocations = [NSMutableArray new];
    appDel.listHuntLocations = [NSMutableArray new];
    
    if (location.locUserId == appDel.user.userID){
        // own location
        for (int i = 0; i < appDel.listLocations.count; i++ ){
            Location *loc = (Location*) [appDel.listLocations objectAtIndex:i];
            if (loc.locID == location.locID){
                // updated Location
                [appDel.listLocations replaceObjectAtIndex:i withObject:location];
                if (location.typeLocation == typeFishing){
                    [appDel.listFishLocations addObject:location];
                } else if (location.typeLocation == typeHunting){
                    [appDel.listHuntLocations addObject:location];
                }
            } else{
                // old Location
                if (location.typeLocation == typeFishing){
                    [appDel.listFishLocations addObject:loc];
                } else if (location.typeLocation == typeHunting){
                    [appDel.listHuntLocations addObject:loc];
                }
            }
        }
    }
    return location;
}

#pragma mark - Work with Buddies request

- (NSArray *)getUsersWithProfiletype:(int)profiletype_id
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@user?&profiletype_id=%d",strUrl, profiletype_id];

    NSMutableArray * array = [[NSMutableArray alloc]init];
    for (NSDictionary * dic in [self startRequest:strUrlRequestAdress andData:nil typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestAddBuddy])
    {
        [array addObject:dic];
    }
    return array;
}

- (NSArray *)getUsersWithProfiletype:(int)profiletype_id andName:(NSString *)name
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@user?&profiletype_id=%d&name=%@",strUrl, profiletype_id,name];
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    @try {
        for (NSDictionary * dic in [self startRequest:strUrlRequestAdress andData:nil typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestAddBuddy])
        {
            [array addObject:dic];
        }
    }
    @catch (NSException *exception) {
        self.isCorrectRezult = NO;
        NSLog(@"ERROR !");
    }
    return array;
}

//- (void) updateUserTrackingVisibility: (BOOL) _tracking_visibility
//{
//    int tracking_visibility = _tracking_visibility ? 1 : 0;
//    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@privacy/%i",strUrl, appDel.user.userID];
//    NSString * strUrlRequestData = [NSString stringWithFormat:@"tracking_visibility=%i&%@",tracking_visibility,APP_ID_KEY];
//    [self startRequest:strUrlRequestAdress andData:strUrlRequestData typeRequest:RequestPut setHeaders:YES andTypeRequest:ApplicationServiceRequestChangeTrackingVisibility];
//}
//
//- (void) getUserTrackingVisibility
//{
//    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@privacy/%i?%@",strUrl, appDel.user.userID,APP_ID_KEY];
//
//    for (NSDictionary * dic in [self startRequest:strUrlRequestAdress andData:nil typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestGetUserTrackingVisibility])
//    {
//        appDel.userTrackingVisibility = [[dic objectForKey:@"tracking_visibility"] boolValue];
//    }
//}

- (void) buddyGetListUsersBuddies
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@?app_id=%@&app_key=%@",strUrl,SubstringBuddies ,@"b63800ad",@"34eddb50efc407d00f3498dc1874526c"];
    
    NSMutableArray * buddiesList = [NSMutableArray new];
    @try {
        for(NSDictionary * dic in [self startRequest:strUrlRequestAdress andData:nil typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestGetListOfBuddies]){
            Buddy * buddy = [Buddy new];
            [buddy setData:dic];
            [buddiesList addObject:buddy];
        }
        appDel.listUserBuddies = nil;
        appDel.listUserBuddies = [[NSMutableArray alloc] initWithArray:buddiesList];
    }
    @catch (NSException *exception) {
        NSLog(@"Error with getting buddies");
    }
}

- (void)buddyAddWithName:(NSString *)buddyName
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@",strUrl,SubstringBuddies];
    NSLog(@"URL : %@",strUrlRequestAdress);

    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithObjects:@[buddyName, @(1), @"b63800ad",@"34eddb50efc407d00f3498dc1874526c"] forKeys:@[@"email", @"is_visible", @"app_id", @"app_key"]];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSLog(@"%@", error);
    
    [self startRequest:strUrlRequestAdress andData:jsonData typeRequest:RequestPost setHeaders:YES andTypeRequest:ApplicationServiceRequestAddBuddy];
}

- (Buddy *)buddyGetUserBuddyWithId:(int)_idBuddy
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@/%@?app_id=%@&app_key=%@",strUrl,SubstringBuddies,[NSString stringWithFormat:@"%i",_idBuddy], @"b63800ad",@"34eddb50efc407d00f3498dc1874526c"];
    
    Buddy * buddy = [Buddy new];
    [buddy setData:[self startRequest:strUrlRequestAdress andData:nil typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestGetInfoAboutBuddy]];
    
    return buddy;
}
//----------------------------------
- (void)buddyDeleteUserFromBuddies:(int)_idBuddy
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@/%i",strUrl,SubstringBuddies,_idBuddy];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithObjects:@[@"b63800ad",@"34eddb50efc407d00f3498dc1874526c"] forKeys:@[@"app_id", @"app_key"]];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSLog(@"%@", error);
    
    
    [self startRequest:strUrlRequestAdress andData:jsonData typeRequest:RequestDelete setHeaders:YES andTypeRequest:ApplicationServiceRequestDeleteFromBuddies];
}

- (void)buddyChangeUserBuddy:(int)_idBuddy status:(int)_statusBuddy andVisible:(int)_visible
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@/%i",strUrl,SubstringBuddies,_idBuddy];
    //NSString * strUrlRequestData = [NSString stringWithFormat:@"status=%i&is_visible=%i&%@",_statusBuddy,_visible,APP_ID_KEY];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithObjects:@[@(_statusBuddy), @(_visible), @"b63800ad",@"34eddb50efc407d00f3498dc1874526c"] forKeys:@[@"status", @"is_visible", @"app_id", @"app_key"]];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSLog(@"%@", error);
    
    [self startRequest:strUrlRequestAdress andData:jsonData typeRequest:RequesPatch setHeaders:YES andTypeRequest:ApplicationServiceRequestChangeTypeOfBuddyRequest];
}



- (NSArray *)buddySearchByLastName:(NSString *)_name
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@?name=%@&app_id=%@&app_key=%@",strUrl,@"user", _name, @"b63800ad",@"34eddb50efc407d00f3498dc1874526c"];
    
    NSMutableArray * buddiesList = [NSMutableArray new];
    @try {
        for(NSDictionary * dic in  [self startRequest:strUrlRequestAdress andData:nil typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestSearchBuddy]){
            SearchingBuddy * buddy = [SearchingBuddy new];
            [buddy setData:dic];
            if((appDel.user.userID == [buddy.userID intValue]) || ([self isUserInMyBuddies:buddy.userID]))
            {
                
            } else
                [buddiesList addObject:buddy];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Error while getting search result");
    }
    
    return buddiesList;
}

#pragma mark Log Activity

- (NSMutableArray*) getAllActivities{
    NSString * strUrlRequestAddress = [NSString stringWithFormat:@"%@log?app_id=%@&app_key=%@&last=-1", strUrl, App_id, App_key];
    NSMutableArray * reportData = [NSMutableArray new];
    @try {
        for (NSDictionary *act in [self startRequest:strUrlRequestAddress andData:nil typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestGetListActivities]){
            ReportsActivity * rep = [[ReportsActivity alloc] initWithData:act];
            [reportData addObject:rep];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Geet activities error");
    }

    return reportData;
}

- (NSMutableArray*) getActivitiesWithBuddyID:(int)buddy_id
{
    NSString * strUrlRequestAddress = [NSString stringWithFormat:@"%@log?app_id=%@&app_key=%@&buddy_id=%d&last=-1", strUrl, App_id, App_key,buddy_id];
    NSMutableArray * reportData = [NSMutableArray new];
    NSDictionary * buf = [self startRequest:strUrlRequestAddress andData:nil typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestGetListActivities];
    if (![buf isKindOfClass:[NSString class]]) {
    for (NSDictionary *act in buf) {
        NSMutableDictionary * rep = [[NSMutableDictionary alloc] init];
        [rep setValue:[act objectForKey:@"species"] forKey:@"species"];
        [rep setValue:[act objectForKey:@"logtimestamp"] forKey:@"date"];
        [rep setValue:[act objectForKey:@"location"] forKey:@"location"];
        [rep setValue:[act objectForKey:@"sightings"] forKey:@"sightings"];
        [reportData addObject:rep];
    }
    }
    return reportData;
}

- (NSMutableArray*) getActivityListFrom: (NSInteger) first to: (NSInteger) last{
    NSString * strUrlRequestAddress = [NSString stringWithFormat:@"%@log?app_id=%@&app_key=%@&first=%i&last=%i", strUrl, App_id, App_key, first, last];
    NSMutableArray * speciesIdArray = [NSMutableArray new];
    for (NSDictionary *act in [self startRequest:strUrlRequestAddress andData:nil typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestGetListActivities]){
        NSMutableDictionary *actDict = [NSMutableDictionary new];
        NSString *date = [act objectForKey:@"date"];
        NSDictionary * dict = @{@"species": [act objectForKey:@"species"],
                                @"logtimestamp" : [act objectForKey:@"logtimestamp"],
                                @"location"     : [act objectForKey:@"location"]};
        //[actDict setObject:[act objectForKey:@"logtimestamp"] forKey:@"logtimestamp"];
        [actDict setObject:date forKey:@"date"];
        [actDict setObject:dict forKey:@"data"];
        [speciesIdArray addObject:actDict];
    }
    
    return speciesIdArray;
}

- (NSDictionary *) getActivityWithId: (NSInteger) _id{
    NSString * strUrlRequestAddress = [NSString stringWithFormat:@"%@log/%i?app_id=%@&app_key=%@", strUrl, _id, App_id, App_key];
   
    NSDictionary * newDict = [self startRequest:strUrlRequestAddress andData:nil typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestGetActivityWithId];
    
    NSArray * harvestrowsArray = [newDict objectForKey:@"harvestrows"];
    NSArray * sightingsArray   = [newDict objectForKey:@"sightings"];
    NSDictionary * dict = [[NSDictionary  alloc]initWithObjectsAndKeys:harvestrowsArray, @"harvestrows", sightingsArray, @"sightings", nil];
    
    return dict;
}

- (NSString *) createActivityWithActivityObject: (Activity*) _activity andActivityDetails: (NSArray*) _activityDetails andSpeciesId: (NSInteger) _speciesId{
    NSString * strUrlRequestAddress = [NSString stringWithFormat:@"%@log", strUrl];
    //NSString *speciesId = [NSString stringWithFormat:@"%d",_speciesId];
    
    NSMutableDictionary *activityDict = [NSMutableDictionary dictionaryWithObjects:@[_activity.startTime, _activity.date, _activity.endTime, [NSString stringWithFormat:@"%i", _activity.location_id]] forKeys:@[@"startTime", @"date", @"endTime", @"location_id"]];
    
    NSMutableArray *detailsArray = [NSMutableArray new];
    for (ActivityDetails * detail in _activityDetails){
        NSString *subspecies_id = [NSString stringWithFormat:@"%d", detail.subspecies_id];
        NSString *activitylevel = [NSString stringWithFormat:@"%d", detail.activitylevel];
        NSString *harvested = [NSString stringWithFormat:@"%d", detail.harvested];
        NSString *seen = [NSString stringWithFormat:@"%d", detail.seen];
        NSMutableDictionary *dictDetail = [NSMutableDictionary dictionaryWithObjects:@[subspecies_id, activitylevel, harvested, seen] forKeys:@[@"subspecies_id", @"activitylevel", @"harvested", @"seen"]];
        [detailsArray addObject:dictDetail];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjects:@[@(_speciesId), activityDict, detailsArray, App_id, App_key] forKeys:@[@"species_id", @"activity", @"harvestrows", @"app_id", @"app_key" ]];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSDictionary * inf = [self startRequest:strUrlRequestAddress andData:jsonData typeRequest:RequestPost setHeaders:YES andTypeRequest:ApplicationServiceRequestCreateActivity];
    return [inf objectForKey:@"id"];
}

- (void) upadateActivityWithId: (NSString*) _activityId speciesId: (NSString*) _speciesId startTime: (NSString*) _startTime endTime: (NSString*) _endTime locationId: (NSString*) _locationId date: (NSString*) _date{
    NSString * strUrlRequestAddress = [NSString stringWithFormat:@"%@log/%@", strUrl, _activityId];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjects:@[_speciesId, _startTime, _endTime, _locationId, _date] forKeys:@[@"species_id", @"startTime", @"endTime", @"location_id", @"date"]];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    [self startRequest:strUrlRequestAddress andData:jsonData typeRequest:RequesPatch setHeaders:YES andTypeRequest:ApplicationServiceRequestUpdateActivity];
}

- (void) deleteActivityWithId: (NSInteger) _activityId{
    NSString *strUrlRequestAddress = [NSString stringWithFormat:@"%@log/%d",strUrl, _activityId];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjects:@[App_id, App_key] forKeys:@[@"app_id", @"app_key"]];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    [self startRequest:strUrlRequestAddress andData:jsonData typeRequest:RequestDelete setHeaders:YES andTypeRequest:ApplicationServiceRequestDeleteActivity];
}


#pragma mark - Work with user Location 

- (void)updateUserLocationLat:(NSString*)_latitude andLong:(NSString*)_longitude
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@/%i",strUrl,SubstringCurrentLocation,appDel.user.userID];
    NSString * strUrlRequestData1 = [NSString stringWithFormat:@"latitude=%@&longitude=%@&%@",_latitude,_longitude,APP_ID_KEY];
    
    [self startRequest:strUrlRequestAdress andData:[strUrlRequestData1 dataUsingEncoding:NSUTF8StringEncoding] typeRequest:RequestPut setHeaders:YES andTypeRequest:ApplicationServiceRequestUpdateUserCurrentLocation];
}

#pragma mark Shared locations

- (void) getAllSharedLocation{
    NSString *strUrlRequestAddress = [NSString stringWithFormat:@"%@sharedlocation?app_id=%@&app_key=%@", strUrl, App_id, App_key];
    [self startRequest:strUrlRequestAddress andData:nil typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestGetAllSharedLocations];
}

- (void) getSharedLocationsWithBuddyId: (NSInteger) buddy_id{
    NSString *strUrlRequestAddress = [NSString stringWithFormat:@"%@sharedlocation?user_id=%@&app_id=%@&app_key=%@", strUrl, @(buddy_id), App_id, App_key];
    [self startRequest:strUrlRequestAddress andData:nil typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestGetSharedLocationsFromBuddy];
}

- (void) shareLocation: (NSInteger) location_id toBuddy: (NSInteger) buddy_id{
    NSString *strUrlRequestAddress = [NSString stringWithFormat:@"%@sharedlocation", strUrl];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjects:@[@(location_id), @(buddy_id), App_id, App_key] forKeys:@[@"id", @"user_id", @"app_id", @"app_key"]];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    [self startRequest:strUrlRequestAddress andData:jsonData typeRequest:RequestPost setHeaders:YES andTypeRequest:ApplicationServiceRequestShareLocationWithBuddy];
}

- (void) unshareLocation: (NSInteger) location_id fromBuddy: (NSInteger) buddy_id{
    NSString *strUrlRequestAddress = [NSString stringWithFormat:@"%@sharedlocation", strUrl];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjects:@[@(location_id), @(buddy_id), App_id, App_key] forKeys:@[@"id", @"user_id", @"app_id", @"app_key"]];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    [self startRequest:strUrlRequestAddress andData:jsonData typeRequest:RequestDelete setHeaders:YES andTypeRequest:ApplicationServiceRequestUnshareLocation];
}

- (void) getPublicLocationWithID:(NSString *)locID name:(NSString *)name page:(int)page limit:(int)limit state_fips:(int)state county_fips:(int)country
{
    if (!locID) {
        locID = @"";
    }
    if (!name) {
        name = @"";
    }
    if (!page) {
        page = 0;
    }
    if (!limit) {
        limit = 10;
    }
    if (!state) {
        state = 0;
    }
    if (!country) {
        country = 0;
    }
    NSString *strUrlRequestAddress = [NSString stringWithFormat:@"%@publiclocation?&id=%@&name=%@&page=%d&limit=%d&state_fips=%d&county_fips=%d&app_id=%@&app_key=%@", strUrl, locID, name, page, limit, state, country, App_id, App_key];
    NSMutableArray * array = [[NSMutableArray alloc]initWithArray:appDel.publicLocations];
    for (NSDictionary * dict in [self startRequest:strUrlRequestAddress andData:nil typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestGetAllSharedLocations]) {
        Location * location = [Location new];
        [location setValuesFromDict:dict];
        [array addObject:location];
    }
    
        appDel.publicLocations = array;
}

- (NSArray *) getPublicLocationWithName:(NSString *)name
{
    NSString *strUrlRequestAddress = [NSString stringWithFormat:@"%@publiclocation?&name=%@&app_id=%@&app_key=%@", strUrl,  name, App_id, App_key];
    NSMutableArray * array = [[NSMutableArray alloc]initWithArray:appDel.publicLocations];
    for (NSDictionary * dict in [self startRequest:strUrlRequestAddress andData:nil typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestGetAllSharedLocations]) {
        Location * location = [Location new];
        [location setValuesFromDict:dict];
        [array addObject:location];
    }
    return array;
}

#pragma mark - Photo

- (NSArray *) getPhotoWithLimit:(NSString *)limit
{
    NSString * strUrlRequestAddress = [limit isEqualToString:@"0"] ? [NSString stringWithFormat:@"%@%@?app_id=%@&app_key=%@&last=-1", strUrl, SubstringPhoto, App_id, App_key] : [NSString stringWithFormat:@"%@%@?app_id=%@&app_key=%@&last=%@", strUrl, SubstringPhoto, App_id, App_key, limit];
    NSMutableArray * photoList = [NSMutableArray new];
    NSDictionary * buf = [[self startRequest:strUrlRequestAddress andData:nil typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestPhoto] objectForKey:@"photos"];
    for (NSDictionary *act in buf){
        Photo * ithem = [[Photo alloc]init];
        ithem.photoID = [act objectForKey:@"id"];
        ithem.fullPhoto = [act objectForKey:@"fullPhoto"];
        ithem.raw = [act objectForKey:@"raw"];
        ithem.thumbnail = [act objectForKey:@"url"];
        ithem.uploadDate = [act objectForKey:@"upload_date"];
        ithem.userName = [act objectForKey:@"username"];
        ithem.description = [[act objectForKey:@"raw"] objectForKey:@"description"];
        ithem.caption = [[act objectForKey:@"raw"] objectForKey:@"caption"];
        
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
        ithem.time = [dateFormatter dateFromString:[act objectForKey:@"upload_date"]];
        [photoList addObject:ithem];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"get photo finished" object:nil];
    return photoList;
}

- (Photo *) getPhotoWithId:(int)photo_id
{
    NSString * strUrlRequestAddress = [NSString stringWithFormat:@"%@%@/%d?app_id=%@&app_key=%@", strUrl, SubstringPhoto, photo_id, App_id, App_key];
    NSDictionary *act = [self startRequest:strUrlRequestAddress andData:nil typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestPhoto];
    Photo * ithem = [[Photo alloc]init];
    ithem.photoID = [act objectForKey:@"id"];
    ithem.fullPhoto = [act objectForKey:@"fullPhoto"];
    ithem.raw = [act objectForKey:@"raw"];
    ithem.thumbnail = [act objectForKey:@"url"];
    ithem.uploadDate = [act objectForKey:@"upload_date"];
    ithem.userName = [act objectForKey:@"username"];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    ithem.time = [dateFormatter dateFromString:[act objectForKey:@"upload_date"]];
    return ithem;
}

- (NSArray *)getPhotoWithBuddyId:(int)buddy_id
{
    NSString * strUrlRequestAddress = [NSString stringWithFormat:@"%@%@?app_id=%@&app_key=%@&buddy_id=%d&last=-1", strUrl, SubstringPhoto, App_id, App_key,buddy_id];
    NSMutableArray * photoList = [NSMutableArray new];
    
    @try {
        NSDictionary * buf = [[self startRequest:strUrlRequestAddress andData:nil typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestPhoto] objectForKey:@"photos"];
        for (NSDictionary *act in buf){
            Photo * ithem = [[Photo alloc]init];
            ithem.photoID = [act objectForKey:@"id"];
            ithem.fullPhoto = [act objectForKey:@"fullPhoto"];
            ithem.raw = [act objectForKey:@"raw"];
            ithem.thumbnail = [act objectForKey:@"url"];
            ithem.uploadDate = [act objectForKey:@"upload_date"];
            ithem.userName = [act objectForKey:@"username"];
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
            ithem.time = [dateFormatter dateFromString:[act objectForKey:@"upload_date"]];
            [photoList addObject:ithem];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Photo info uploading error");
    }

    
    return photoList;

}

- (NSString *) uploadPhoto:(UIImage *)photo
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@?app_id=%@&app_key=%@",strUrl,SubstringPhoto, App_id, App_key];
    NSLog(@"URL : %@",strUrlRequestAdress);
    UIImage * image;
    if (photo.size.height > 600) {
        float coef_h = photo.size.height / 600;
        float coef_w = photo.size.width / 800;
        float coef = coef_h > coef_w ? coef_h : coef_w;
        image = [UIImage imageWithCGImage:photo.CGImage scale:coef orientation:photo.imageOrientation];
        NSLog(@"Compression image %f X %f -> %f X %f", photo.size.width, photo.size.height, image.size.width, image.size.height);
    } else {
        image = photo;
    }
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.9f);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
//----------------------------------------------------------------------------------
    [request setURL:[NSURL URLWithString:strUrlRequestAdress]];
    [request setHTTPMethod:@"POST"];
    [request setValue:appDel.user.userPassword forHTTPHeaderField:@"X-password"];
    [request setValue:appDel.user.userEmail forHTTPHeaderField:@"X-username"];
    
    //Add the header info
	NSString *stringBoundary = @"0xKhTmLbOuNdArY";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    
    
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"photo\"; filename=\"photo.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    NSError * reqError = nil;
    NSURLResponse * response = nil;
    receivedData = (NSMutableData* )[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&reqError];
    NSLog(@"receivedData %@",[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding]);
    NSError * jsonError = [[NSError alloc]init];
    CJSONDeserializer *deserializer = [CJSONDeserializer deserializer];
    NSDictionary * info = [deserializer deserialize:receivedData error:&jsonError];
    return [info objectForKey:@"id"];
}


- (NSString *)setUserAvatar:(UIImage *)avatar
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@/avatar?app_id=%@&app_key=%@",strUrl,SubstringPhoto, App_id, App_key];
    NSLog(@"URL : %@",strUrlRequestAdress);
    
    NSData *imageData = UIImageJPEGRepresentation(avatar, 0.9f);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    //----------------------------------------------------------------------------------
    [request setURL:[NSURL URLWithString:strUrlRequestAdress]];
    [request setHTTPMethod:@"POST"];
    [request setValue:appDel.user.userPassword forHTTPHeaderField:@"X-password"];
    [request setValue:appDel.user.userEmail forHTTPHeaderField:@"X-username"];
    
    //Add the header info
	NSString *stringBoundary = @"0xKhTmLbOuNdArY";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    
    
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"photo\"; filename=\"avatar.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    NSError * reqError = nil;
    NSURLResponse * response = nil;
    receivedData = (NSMutableData* )[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&reqError];
    NSLog(@"receivedData %@",[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding]);
    NSError * jsonError = [[NSError alloc]init];
    CJSONDeserializer *deserializer = [CJSONDeserializer deserializer];
    NSDictionary * info = [deserializer deserialize:receivedData error:&jsonError];
    return [info objectForKey:@"file"];

}

- ( void) updatePhotoWithId:(int)photo_id andActivity:(int)activity_id andSighting:(int)sighting_id andType:(int)type_id andDescription:(NSString *)description andCaption:(NSString *)caption
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@/%i",strUrl,SubstringPhoto,photo_id];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithObjects:@[@(activity_id), @(sighting_id), @(type_id), description, caption, @"b63800ad",@"34eddb50efc407d00f3498dc1874526c"] forKeys:@[@"activity_id", @"sighting_id", @"type_id", @"description", @"caption", @"app_id", @"app_key"]];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSLog(@"%@", error);
    
    [self startRequest:strUrlRequestAdress andData:jsonData typeRequest:RequesPatch setHeaders:YES andTypeRequest:ApplicationServiceRequestPhoto];
}

- (void)setDescriptionWithPhotoID:(int)photoID andDescription:(NSString *)des
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@/%i",strUrl,SubstringPhoto,photoID];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithObjects:@[des,@"b63800ad",@"34eddb50efc407d00f3498dc1874526c"] forKeys:@[@"description", @"app_id", @"app_key"]];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSLog(@"%@", error);
    
   NSLog(@"%@",[self startRequest:strUrlRequestAdress andData:jsonData typeRequest:RequesPatch setHeaders:YES andTypeRequest:ApplicationServiceRequestPhoto]);
}

- (void) deletePhotoWithId:(int)photo_id
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@/%i",strUrl,SubstringPhoto,photo_id];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithObjects:@[@"b63800ad",@"34eddb50efc407d00f3498dc1874526c"] forKeys:@[@"app_id", @"app_key"]];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSLog(@"%@", error);
    
    
    [self startRequest:strUrlRequestAdress andData:jsonData typeRequest:RequestDelete setHeaders:YES andTypeRequest:ApplicationServiceRequestPhoto];
}

#pragma mark TIPS
- (NSArray *)getTips
{
    NSString *strUrlRequestAddress = [NSString stringWithFormat:@"%@tip?&app_id=%@&app_key=%@po",strUrl, @"b63800ad",@"34eddb50efc407d00f3498dc1874526c"];
    NSDictionary *info = [NSDictionary new];
    info = [self startRequest:strUrlRequestAddress andData:nil typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestTips];
    NSMutableArray * array = [NSMutableArray new];
    for(NSDictionary * dic in info){
        TIPS * tip = [TIPS new];
        [tip initTipsWithData:dic];
        [array addObject:tip];
    }
    return array;
}

- (NSArray *)getTipsWithTipsId:(int)tipsID
{
    NSString *strUrlRequestAddress = [NSString stringWithFormat:@"%@tip/%d?&app_id=%@&app_key=%@&last=-1",strUrl, tipsID, @"b63800ad",@"34eddb50efc407d00f3498dc1874526c"];
    NSDictionary *info = [NSDictionary new];
    info = [self startRequest:strUrlRequestAddress andData:nil typeRequest:RequestGet setHeaders:NO andTypeRequest:ApplicationServiceRequestTips];
    NSMutableArray * array = [NSMutableArray new];
    for(NSDictionary * dic in info){
        
        [array addObject:dic];
    }
    return array;
}

- (TIPS *)createNewTipsWithSpecieID:(int)specieID tip:(NSString *)tipText subSpecieID:(int)subSpecieID andUserID:(int)userID
{
    NSString * strUrlRequestAddress = [NSString stringWithFormat:@"%@tip", strUrl];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjects:@[@(specieID), tipText, @(subSpecieID), @(userID),  App_id, App_key] forKeys:@[@"species_id", @"tip", @"subspecies_id", @"user_id", @"app_id", @"app_key" ]];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSDictionary * inf = [self startRequest:strUrlRequestAddress andData:jsonData typeRequest:RequestPost setHeaders:YES andTypeRequest:ApplicationServiceRequestTips];
    TIPS * tip = [[TIPS alloc]init];
    [tip initTipsWithData:inf];
    return tip;
}

- (void)updateTipsWithTipsID:(int)tipID specieID:(int)specieID tip:(NSString *)tipText subSpecieID:(int)subSpecieID andUserID:(int)userID
{
    NSString * strUrlRequestAddress = [NSString stringWithFormat:@"%@tip/%d", strUrl, tipID];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjects:@[@(specieID), tipText, @(subSpecieID), @(userID), @"b63800ad",@"34eddb50efc407d00f3498dc1874526c"] forKeys:@[@"species_id", @"tip", @"subspecies_id", @"user_id", @"app_id", @"app_key"]];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    [self startRequest:strUrlRequestAddress andData:jsonData typeRequest:RequesPatch setHeaders:YES andTypeRequest:ApplicationServiceRequestTips];
}

- (void)deleteTipsWithID:(int)tipsID
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@tip/%i",strUrl,tipsID];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithObjects:@[@"b63800ad",@"34eddb50efc407d00f3498dc1874526c"] forKeys:@[@"app_id", @"app_key"]];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSLog(@"%@", error);
    
    [self startRequest:strUrlRequestAdress andData:jsonData typeRequest:RequestDelete setHeaders:YES andTypeRequest:ApplicationServiceRequestTips];
}


#pragma mark Shared Location
-(NSArray *) getBuddySharedLocationWithID:(NSString *)loc_id
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@sharedlocation/buddies?location_id=%@&app_id=%@&app_key=%@&last=-1",strUrl, loc_id, App_id, App_key];
    
    
    NSMutableArray * listSharedLocations = [NSMutableArray new];
    id returnData = [self startRequest:strUrlRequestAdress andData:nil typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestLocationsAssociatedWithUser];
    if ([returnData isKindOfClass:[NSArray class]]) {
        for (NSDictionary * dicInfo in returnData) {
            Buddy * buf = [Buddy new];
            buf.userID =        [dicInfo objectForKey:@"User ID"];
            buf.userName =      [dicInfo objectForKey:@"Email"];
            buf.name = [dicInfo objectForKey:@"Name"];
            [listSharedLocations addObject:buf];
        }
    }
    return listSharedLocations;
}

- (NSDictionary *) sharedLocation:(int)location_id andWithBuddy:(int)buddy_id
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@sharedlocation",strUrl];
    //NSLog(@"URL : %@",strUrlRequestAdress);
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%d",location_id], [NSString stringWithFormat:@"%d",buddy_id], @"b63800ad",@"34eddb50efc407d00f3498dc1874526c"] forKeys:@[@"id", @"user_id", @"app_id", @"app_key"]];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSLog(@"%@", error);
    
    return  ([self startRequest:strUrlRequestAdress andData:jsonData typeRequest:RequestPost setHeaders:YES andTypeRequest:ApplicationServiceRequestLocationsAssociatedWithUser]);
}


- (NSDictionary *) unsharedLocation:(int)location_id andWithBuddy:(int)buddy_id
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@sharedlocation/%i",strUrl,location_id];
    NSString * str = [NSString stringWithFormat:@"%d", buddy_id];
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithObjects:@[str, @"b63800ad",@"34eddb50efc407d00f3498dc1874526c"] forKeys:@[@"user_id", @"app_id", @"app_key"]];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSLog(@"%@", error);
    
    return  ([self startRequest:strUrlRequestAdress andData:jsonData typeRequest:RequestDelete setHeaders:YES andTypeRequest:ApplicationServiceRequestLocationsAssociatedWithUser]);
}


#pragma mark - Seasons
- (NSArray *) getSeasonWithRegion:(int)region_id
{
    NSString *strUrlRequestAddress = [NSString stringWithFormat:@"%@species?&state=%d&app_id=%@&app_key=%@&last=5",strUrl, region_id, @"b63800ad",@"34eddb50efc407d00f3498dc1874526c"];
    NSDictionary *info = [NSDictionary new];
    NSMutableArray * array = [NSMutableArray new];
    @try {
        info = [self startRequest:strUrlRequestAddress andData:nil typeRequest:RequestGet setHeaders:NO andTypeRequest:ApplicationServiceRequestTips];
        
        for(NSDictionary * dic in info){
            Season * season = [Season new];
            [season initSeasonWithData:dic];
            [array addObject:season];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Error enter empty json");
    }
    return array;
}

- (NSArray *) getSpeciesWithSeason:(Season *)season
{
    NSMutableArray * array = [NSMutableArray new];
    for (NSString * obj in season.subspecies) {
        int i = [obj intValue];
        NSString *strUrlRequestAddress = [NSString stringWithFormat:@"%@subspecies/%d?&app_id=%@&app_key=%@&last=-1",strUrl, i, @"b63800ad",@"34eddb50efc407d00f3498dc1874526c"];
        NSDictionary *info = [NSDictionary new];
        info = [self startRequest:strUrlRequestAddress andData:nil typeRequest:RequestGet setHeaders:NO andTypeRequest:ApplicationServiceRequestTips];
   
        Species * spec = [Species new];
        [spec initSpeciesWithData:info];
        [array addObject:spec];
    }
    return array;
}


#pragma mark - Comment
- (NSArray *)getCommentsWithPhotoID:(int)photo_id
{
    NSString *strUrlRequestAddress = [NSString stringWithFormat:@"%@photocomment?&photo_id=%d&app_id=%@&app_key=%@&last=-1",strUrl, photo_id, @"b63800ad",@"34eddb50efc407d00f3498dc1874526c"];
    NSDictionary *info = [NSDictionary new];
    info = [self startRequest:strUrlRequestAddress andData:nil typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestComment];
    NSMutableArray * array = [NSMutableArray new];
    @try {
        for(NSDictionary * dic in info){
            [array addObject:dic];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"comments domt existing");
    }
    
        return array;
}

- (void) createComment:(NSString *)text withPhoto:(int)photo_id
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@photocomment",strUrl];
    //NSLog(@"URL : %@",strUrlRequestAdress);
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithObjects:@[@(photo_id), text, @(1), @"b63800ad",@"34eddb50efc407d00f3498dc1874526c"] forKeys:@[@"photo_id", @"comment", @"status", @"app_id", @"app_key"]];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSLog(@"%@", error);
    
    [self startRequest:strUrlRequestAdress andData:jsonData typeRequest:RequestPost setHeaders:YES andTypeRequest:ApplicationServiceRequestComment];
}

- (void) deleteCommentWithID:(int)comment_id
{
   NSString *strUrlRequestAddress = [NSString stringWithFormat:@"%@photocomment/%d",strUrl, comment_id];
    
    [self startRequest:strUrlRequestAddress andData:nil typeRequest:RequestDelete setHeaders:YES andTypeRequest:ApplicationServiceRequestComment];
}




#pragma mark - Log Detail

- (void) getLogDetail
{
    NSString * strUrlRequestAddress = [NSString stringWithFormat:@"%@%@?app_id=%@&app_key=%@", strUrl, SubstringLogdetail, App_id, App_key];
    NSMutableArray * logDetail = [NSMutableArray new];
    for (NSDictionary *act in [self startRequest:strUrlRequestAddress andData:nil typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestLogDetail]){
        [logDetail addObject:[act objectForKey:@"url"]];
    }

}

- (void) updateLogDetailWithId:(NSString *)logId andSighting:(NSDictionary *)sighting
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@/%@",strUrl,SubstringLogdetail,logId];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithObjects:@[sighting, @"b63800ad",@"34eddb50efc407d00f3498dc1874526c"] forKeys:@[@"sighting", @"app_id", @"app_key"]];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSLog(@"%@", error);
    
    [self startRequest:strUrlRequestAdress andData:jsonData typeRequest:RequesPatch setHeaders:YES andTypeRequest:ApplicationServiceRequestLogDetail];
}

- (void) deleteLogDetailWithId:(int)logId
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@/%i",strUrl,SubstringLogdetail,logId];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithObjects:@[@"b63800ad",@"34eddb50efc407d00f3498dc1874526c"] forKeys:@[@"app_id", @"app_key"]];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSLog(@"%@", error);
    
    [self startRequest:strUrlRequestAdress andData:jsonData typeRequest:RequestDelete setHeaders:YES andTypeRequest:ApplicationServiceRequestLogDetail];
}



#pragma mark - REQUEST

- (NSDictionary *)startRequest:(NSString*) _url andData:(NSData*) _data typeRequest:(NSString*) _type setHeaders:(BOOL)_setHeaders andTypeRequest:(int)typeReust{
    /*if(![HPAppDelegate isActiveConnectedToInternet]){
        [HPAppDelegate OpenAlertwithTitle:@"Error" andContent:@"Problen in connection"];
        return;
    }*/
    
    NSDictionary* info = [NSDictionary new];
    self.isCorrectRezult = NO;
   // NSData * data = [_data dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:_url]];
    [request setHTTPMethod:_type];
    if(([_type isEqualToString: RequestPost] || [_type isEqualToString: RequestDelete] || [_type isEqualToString: RequestPut] || [_type isEqualToString:RequesPatch]) && (_data != nil))
        [request setHTTPBody: _data];
    //[request setValue:/*@"application/x-www-form-urlencoded"*/@"application/json" forHTTPHeaderField:@"Content-Type"];
    if (bbb){
        
        NSString *boundary = @"--------------1Oirud485KJdi84843911123";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        
        [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"--%@",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                           [body appendData:[@"Content-Disposition: form-data; name=\"photo\"; filename=\"Image.png\"" dataUsingEncoding:NSUTF8StringEncoding]];
                                              [body appendData:[@"Content-Type: application/octet-stream" dataUsingEncoding:NSUTF8StringEncoding]];
                                                                 [body appendData:[NSData dataWithData:_data]];
                                                                 [body appendData:[[NSString stringWithFormat:@"--%@--",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:body];
        bbb = NO;
    }else{
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    [request setValue:@"must-revalidate" forHTTPHeaderField:@"Cashe-Control"];
    [request setTimeoutInterval:30.0f];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    
    if ([_type isEqualToString:RequesPatch]){
        [request setValue:@"PATCH" forHTTPHeaderField:@"X-HTTP-Method-Override"];
    }
    
    if(_setHeaders){
        [request setValue:appDel.user.userEmail forHTTPHeaderField:@"X-Username"];
        [request setValue:appDel.user.userPassword forHTTPHeaderField:@"X-Password"];
    }
    
    typeRequest = _type;
    NSError * reqError = nil;
    NSURLResponse * response = nil;
    receivedData = (NSMutableData* )[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&reqError];

    if(reqError == nil){
        if([_type isEqualToString: RequestDelete]){
            NSLog(@"receivedData %@",[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding]);
            self.isCorrectRezult = YES;
        }
        else {
            NSError * jsonError = nil;
            //NSLog(@"receivedData %@",[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding]);
            CJSONDeserializer *deserializer = [CJSONDeserializer deserializer];
            info = [deserializer deserialize:receivedData error:&jsonError];
            if(jsonError != nil) {
                NSLog(@"Error JSON :%@", jsonError.description);
                NSLog(@"receivedData %@",[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding]);
                
                NSString * htmlString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
                 NSString * as = [[[htmlString stringByStrippingTags] stringByRemovingNewLinesAndWhitespace] stringByDecodingHTMLEntities];
                NSLog(@"AS : %@",as);
                NSString * bdExeption;
                if([as isEqualToString:@"Error Couldn't create user Attribute: username This email already exists."]) bdExeption = @"Couldn't create user.\nThis email already exists.";
                else if([as isEqualToString:@"Missing first_name and/or last_name"])
                    bdExeption = @"Missing users with these\nfirst name and last name";
                else if ([as isEqualToString:@"No users were found"])
                    bdExeption = @"No users were found";
                else bdExeption = @"Problem in connection.\nPlease, try again";
                
                dispatch_async(dispatch_get_main_queue(), ^(){
                    
                    [AppDelegate OpenAlertwithTitle:@"Error" andContent:bdExeption];
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                });
            }
            else {
            // NSLog(@"INFO : %@",info);
                self.isCorrectRezult = YES;
            }
        }
        } else {
        NSString * received = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        NSLog(@"receivedData %@",received);
        NSString * bodyExeption;
        if([received isEqualToString:@"Error: Username or Password is invalid"]) bodyExeption = @"Username or Password is invalid";
        else bodyExeption = @"Problem in connection.\nPlease, try again";
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            if(!appDel.isApplicationInBackground){
                if(typeReust != ApplicationServiceRequestGetListOfBuddies)
                    [AppDelegate OpenAlertwithTitle:@"Error" andContent:bodyExeption];
            }
        });
        
        NSLog(@"receivedData %@",received);
        
    }
        return info;
}

- (void)getWeatherPredictionForCurrentLocation:(int)_idLocation
{
    NSString * strUrlRequestAddress = [NSString stringWithFormat:@"%@forecast/%i",URLSportsMaster,_idLocation];

    WheatherPredict *weatherPredictionForLocation = [[WheatherPredict alloc]init];
    [weatherPredictionForLocation setDataForWheather:[self startRequest:strUrlRequestAddress andData:nil typeRequest:RequestGet setHeaders:NO andTypeRequest:ApplicationServiceRequestGetWeatherForecast]];
    appDel.wheatherPredictList = weatherPredictionForLocation;
}



#pragma mark Species
//-------------------------------------------------------------------------------------------------------------------
- (NSArray *)getAllSpecies
{
    NSString *strUrlRequestAddress = [NSString stringWithFormat:@"%@%@?app_id=%@&app_key=%@&last=-1",strUrl,SubstringSpecies, @"b63800ad",@"34eddb50efc407d00f3498dc1874526c"];
    NSDictionary *info = [NSDictionary new];
    info = [self startRequest:strUrlRequestAddress andData:nil typeRequest:RequestGet setHeaders:NO andTypeRequest:ApplicationServiceRequestSpecies];
    appDel.speciesList = [NSMutableArray new];
    for(NSDictionary * dic in info){
        Species *spec = [Species new];
        [spec initSpeciesWithData:dic];
        [appDel.speciesList addObject:spec];
    }
    return appDel.speciesList;
}

- (Species *)getSpecieWithId:(int) specieID
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@/%i?app_id=%@&app_key=%@",strUrl,SubstringSpecies ,specieID, @"b63800ad",@"34eddb50efc407d00f3498dc1874526c"];
    
    Species * species = [Species new];
    [species initSpeciesWithData:[self startRequest:strUrlRequestAdress andData:nil typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestSpecies]];
    return species;
}

- (NSArray *)getSubSpecies:(int) subSpeciesID
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@/%i/%@?app_id=%@&app_key=%@",strUrl,SubstringSpecies ,subSpeciesID, SubstringSubSpecies, @"b63800ad",@"34eddb50efc407d00f3498dc1874526c"];
    
    NSMutableArray * speciesList = [NSMutableArray new];
    for(NSDictionary * dic in [self startRequest:strUrlRequestAdress andData:nil typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestSpecies]){
        Species * species = [Species new];
        [species initSpeciesWithData:dic];
        [speciesList addObject:species];
    }
    return speciesList;
}

- (Species *)getSubSpecieWithId:(int) subSpecieID
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@/%i?app_id=%@&app_key=%@",strUrl,SubstringSubSpecies ,subSpecieID, @"b63800ad",@"34eddb50efc407d00f3498dc1874526c"];
    
    Species * species = [Species new];
    [species initSpeciesWithData:[self startRequest:strUrlRequestAdress andData:nil typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestSpecies]];
    return species;
}

- (NSArray *) getQuestionsWithSubSpecieId:(int)subSpecieId
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@/%i/%@?app_id=%@&app_key=%@",strUrl,SubstringSpecies ,subSpecieId, SubstringQuestions, @"b63800ad",@"34eddb50efc407d00f3498dc1874526c"];
    
    NSMutableArray * questions = [NSMutableArray new];
    for (id obj in [self startRequest:strUrlRequestAdress andData:nil typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestSpecies]) {
        [questions addObject:obj];
    }
    return questions;
}


- (NSArray *)getSubSpecieKillingQuestionsWithId:(int) subSpecieID
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@/%i/%@?app_id=%@&app_key=%@",strUrl,SubstringSubSpecies ,subSpecieID, SubstringKilling, @"b63800ad",@"34eddb50efc407d00f3498dc1874526c"];
    
    NSMutableArray * array = [NSMutableArray new];
    for (id obj in [self startRequest:strUrlRequestAdress andData:nil typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestSpecies]) {
        [array addObject:obj];
    }
    return array;
}
//--------------------------------------------------------------------------------------------------------------------

#pragma  mark Is my baddy
- (BOOL)isUserInMyBuddies:(NSString*)_userID{
    BOOL isBuddy = NO;
    
    for (int i = 0; i < appDel.listUserBuddies.count; i++) {
        Buddy * _buddy = (Buddy* )[appDel.listUserBuddies objectAtIndex:i];
        NSString * str = [NSString stringWithFormat:@"%@", _buddy.userID];
        if([str isEqualToString:_userID]) return YES;
    }
    
    return isBuddy;
}

@end
