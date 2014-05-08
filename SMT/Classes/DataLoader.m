//
//  DataLoader.m
//  testCaAnimation
//
//  Created by Vasya on 01.01.14.
//  Copyright (c) 2014 Vasya. All rights reserved.
//

#import "DataLoader.h"
#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"
#import "UserInfo.h"
#import "AppDelegate.h"
#import "Location.h"
#import "FBConnectClass.h"
#import "ConstantsClass.h"
#import "NSString+HTML.h"
#import "Buddy.h"
#import "SearchingBuddy.h"
#import "BuddySearchViewController.h"
#import "Species.h"

#define RequestPost @"POST"
#define RequestGet @"GET"
#define RequestDelete @"DELETE"
#define RequestPut @"PUT"

#define APP_ID_KEY @"app_id=b63800ad&app_key=34eddb50efc407d00f3498dc1874526c"
#define URL_USER_LOGIN @"user=%@&password=%@&%@"
#define URL_USER_CREATE @"firstname=%@&lastname=%@&username=%@&password=%@&birthYear=%@&sex=%@&%@"
#define URLSportsMaster @"http://api.sportsmantracker.com/v1/"

#define SubstringLogin @"login"
#define SubstringRegister @"user"
#define SubstringLocations @"locations/"
#define SubstringLocation @"location/"
#define SubstringBuddies @"buddies"
#define SubstringCurrentLocation @"current_location"

@implementation DataLoader

@synthesize typeOfServiceRequest;

- (id)init
{
    self = [super init];
    
    if (self)
    {
        strUrl = @"http://api.sportsmantracker.com/v1/";
        appDel = [UIApplication sharedApplication].delegate;
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
    keyUserFirstName = @"First Name";
    keyUserSecondName = @"Last Name";
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
    NSString * _firstName = [self convertString:firstName];
    NSString * _secondName = [self convertString:secondName];
    NSString * _userName = [self convertString:userName];
    NSString * _userPassword = [self convertString:userPassword];
    NSString * _birthYear = [NSString stringWithFormat:@"%i",birthYear];
    NSString * _userMale = userMale;
    
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@",strUrl,SubstringRegister];
    NSString * strUrlRequestData = [NSString stringWithFormat:URL_USER_CREATE,_firstName,_secondName,_userName,_userPassword,_birthYear,_userMale,APP_ID_KEY];
    
    enterPassword = userPassword;
    
    NSDictionary *info = [self startRequest:strUrlRequestAdress andData:strUrlRequestData typeRequest:RequestPost setHeaders:NO andTypeRequest:ApplicationServiceRequestCreateUser];
    
    [appDel.user setUserInfoName:[info objectForKey:keyUsername] appID:[[info objectForKey:keyUserID] intValue]];
    [appDel.user setUserInfoPassword:enterPassword];
    [appDel.user setUserFirstName:[info objectForKey:keyUserFirstName] andSecondName:[info objectForKey:keyUserSecondName]];
    appDel.user.avatarAdress = [info objectForKey:@"Avatar"];
    
    NSDictionary *retrievedDictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:FB_USER_SIGN];
    if(retrievedDictionary == nil)
        [appDel.user saveUser];
}

-(void) sendInvitationEmailWithEmail: (NSString*) _email andName: (NSString*) _name
{
    NSString * email = [self convertString:_email];
    NSString * name = [self convertString:_name];
    
    NSString * strUrlRequestAddress = [NSString stringWithFormat:@"http://api.sportsmantracker.com/v1/sendBuddyTrackingInvite/?email=%@&app=fp&name=%@&%@", email, name, APP_ID_KEY ];
    NSString * strUrlRequestData = @"";
    
     [self startRequest:strUrlRequestAddress andData:strUrlRequestData typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestSendInvitation];
}

-(void) createLocationWithName : (NSString*) name Latitude: (double) latitude Longitude: (double) longitude
{
    
    NSString * LocationName = [self convertString:name];
    NSString * lat = [self convertString:[NSString stringWithFormat:@"%f", latitude]];
    NSString * longit = [self convertString:[NSString stringWithFormat:@"%f", longitude]];
    
    NSString *userId = [NSString stringWithFormat:@"%d", appDel.user.userID];
    
    NSString * strUrlRequestAddress = @"http://api.sportsmantracker.com/v1/location";
    NSString * strUrlRequestData = [NSString stringWithFormat: @"user_id=%@&type_id=2&name=%@&latitude=%@&longitude=%@&%@", userId, LocationName, lat, longit,APP_ID_KEY];
    
    Location * location = [Location new];
    [location setValuesFromDict:[self startRequest:strUrlRequestAddress andData:strUrlRequestData typeRequest:RequestPost setHeaders:YES andTypeRequest:ApplicationServiceRequestCreateLocation]];
    [appDel.listLocations addObject:location];
}

- (void)avtorizeUser:(NSString*) userName password:(NSString*) userPassword
{
    NSString * _userName = [self convertString:userName];
    NSString * _userPassword = [self convertString:userPassword];
    
    enterPassword = userPassword;
    typeOfServiceRequest = ApplicationServiceRequestAvtorizeUser;
    
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@",strUrl,SubstringLogin];
    NSString * strUrlRequestData = [NSString stringWithFormat:URL_USER_LOGIN,_userName,_userPassword,APP_ID_KEY];
    
    NSDictionary *info = [self startRequest:strUrlRequestAdress andData:strUrlRequestData typeRequest:RequestPost setHeaders:NO andTypeRequest:ApplicationServiceRequestAvtorizeUser];
    
    [appDel.user setUserInfoName:[info objectForKey:keyUsername] appID:[[info objectForKey:keyUserID] intValue]];
    [appDel.user setUserInfoPassword:enterPassword];
    [appDel.user setUserFirstName:[info objectForKey:keyUserFirstName] andSecondName:[info objectForKey:keyUserSecondName]];
    appDel.user.avatarAdress = [info objectForKey:@"Avatar"];
}

- (void)getLocationsAssociatedWithUser
{
    typeOfServiceRequest = ApplicationServiceRequestLocationsAssociatedWithUser;
    NSString * strLocations = [NSString stringWithFormat:@"%i?%@",appDel.user.userID,APP_ID_KEY];
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@%@",strUrl,SubstringLocations,strLocations];

    NSLog(@"Get Locations");
    // * * * *
    NSMutableArray * listLocations = [NSMutableArray new];
    @try {
        //listLocationName = [[NSMutableArray alloc] initWithArray:info.allKeys];
        for (NSDictionary * dicInfo in [self startRequest:strUrlRequestAdress andData:nil typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestLocationsAssociatedWithUser]) {
            Location * location = [Location new];
            [location setValuesFromDict:dicInfo];
            if(![location isLocationDelete] && location.typeLocation == typeFishing)
                [listLocations addObject:location];
        }
        self.isCorrectRezult = YES;
    }
    @catch (NSException *exception) {
        self.isCorrectRezult = NO;
        NSLog(@"ERROR !");
    }
    //if(self.isCorrectRezult)
    appDel.listLocations = [[NSMutableArray alloc] initWithArray:listLocations];
    //else appDel.listLocations = nil;
    //NSLog(@"%@",info);

}

- (void)deleteLocationWithID:(int) _locID
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@%@",strUrl,SubstringLocation,[NSString stringWithFormat:@"%i",_locID]];
    [self startRequest:strUrlRequestAdress andData:APP_ID_KEY typeRequest:RequestDelete setHeaders:YES andTypeRequest:ApplicationServiceRequestDeleteLocation];
}

- (void)updateChooseLocation:(int)_locID
                     newName:(NSString*)_newName
                     newLati:(NSString*)_lati
                     newLong:(NSString*)_long
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@%i",strUrl,SubstringLocation,_locID];
    NSString * strUrlRequestData = [NSString stringWithFormat:@"name=%@&latitude=%@&longitude=%@&%@",[self convertString:_newName],_lati,_long,APP_ID_KEY];

    Location * location = [Location new];
    [location setValuesFromDict:[self startRequest:strUrlRequestAdress andData:strUrlRequestData typeRequest:RequestPut setHeaders:YES andTypeRequest:ApplicationServiceRequestUpdateLocation]];
    for(int i=0 ; i < appDel.listLocations.count; i++){
        Location * loc = [[appDel listLocations] objectAtIndex:i];
        if (location.locID == loc.locID){
            [[appDel listLocations] replaceObjectAtIndex:i withObject:location];
        }
    }

}

#pragma mark - Work with Buddies request

- (void) updateUserTrackingVisibility: (BOOL) _tracking_visibility
{
    int tracking_visibility = _tracking_visibility ? 1 : 0;
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@privacy/%i",strUrl, appDel.user.userID];
    NSString * strUrlRequestData = [NSString stringWithFormat:@"tracking_visibility=%i&%@",tracking_visibility,APP_ID_KEY];
    [self startRequest:strUrlRequestAdress andData:strUrlRequestData typeRequest:RequestPut setHeaders:YES andTypeRequest:ApplicationServiceRequestChangeTrackingVisibility];
}

- (void) getUserTrackingVisibility
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@privacy/%i?%@",strUrl, appDel.user.userID,APP_ID_KEY];

    for (NSDictionary * dic in [self startRequest:strUrlRequestAdress andData:nil typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestGetUserTrackingVisibility])
    {
        appDel.userTrackingVisibility = [[dic objectForKey:@"tracking_visibility"] boolValue];
    }
}

- (void) buddyGetListUsersBuddies
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@?%@",strUrl,SubstringBuddies,APP_ID_KEY];

    NSMutableArray * buddiesList = [NSMutableArray new];
    for(NSDictionary * dic in [self startRequest:strUrlRequestAdress andData:nil typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestGetListOfBuddies]){
        Buddy * buddy = [Buddy new];
        [buddy setData:dic];
        [buddiesList addObject:buddy];
    }
    appDel.listUserBuddies = nil;
    appDel.listUserBuddies = [[NSMutableArray alloc] initWithArray:buddiesList];

}

- (void)buddyAddWithName:(NSString *)buddyName
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@",strUrl,SubstringBuddies];
    NSLog(@"URL : %@",strUrlRequestAdress);
    
    NSString * _userName = [self convertString:buddyName];
    NSString * strUrlRequestData = [NSString stringWithFormat:@"email=%@&is_visible=1&%@",_userName,APP_ID_KEY];
    
    [self startRequest:strUrlRequestAdress andData:strUrlRequestData typeRequest:RequestPost setHeaders:YES andTypeRequest:ApplicationServiceRequestAddBuddy];
}

- (void)buddyGetUserBuddyWithId:(int)_idBuddy
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@/%i?%@",strUrl,SubstringBuddies,_idBuddy,APP_ID_KEY];

    Buddy * buddy = [Buddy new];
    [buddy setData:[self startRequest:strUrlRequestAdress andData:nil typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestGetInfoAboutBuddy]];
    
    UINavigationController * controller = (UINavigationController*)appDel.window.rootViewController;
    id obj = [controller.viewControllers objectAtIndex:(controller.viewControllers.count - 1)];
    if([obj isKindOfClass:[BuddySearchViewController class]]){
        BuddySearchViewController * viewC = (BuddySearchViewController*)[controller.viewControllers objectAtIndex:(controller.viewControllers.count - 1)];
        [viewC addFindingUserToBuddies:buddy];
        return;
    }

}

- (void)buddyDeleteUserFromBuddies:(int)_idBuddy
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@/%i",strUrl,SubstringBuddies,_idBuddy];
    NSString * strUrlRequestData = [NSString stringWithFormat:@"%@",APP_ID_KEY];
    
    [self startRequest:strUrlRequestAdress andData:strUrlRequestData typeRequest:RequestDelete setHeaders:YES andTypeRequest:ApplicationServiceRequestDeleteFromBuddies];
}

- (void)buddyChangeUserBuddy:(int)_idBuddy status:(int)_statusBuddy andVisible:(int)_visible
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@/%i",strUrl,SubstringBuddies,_idBuddy];
    NSString * strUrlRequestData = [NSString stringWithFormat:@"status=%i&is_visible=%i&%@",_statusBuddy,_visible,APP_ID_KEY];
    
    [self startRequest:strUrlRequestAdress andData:strUrlRequestData typeRequest:RequestPut setHeaders:YES andTypeRequest:ApplicationServiceRequestChangeTypeOfBuddyRequest];
}

- (void)buddySearchByLastName:(NSString *)_name
{
    NSString * strConvert = [self convertString:_name];
    NSString * strUrlRequestData = [NSString stringWithFormat:@"name=%@&%@",strConvert,APP_ID_KEY];
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@%@",strUrl,@"users?",strUrlRequestData];

    NSMutableArray * buddiesList = [NSMutableArray new];
    for(NSDictionary * dic in  [self startRequest:strUrlRequestAdress andData:nil typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestSearchBuddy]){
        SearchingBuddy * buddy = [SearchingBuddy new];
        [buddy setData:dic];
        if((appDel.user.userID == [buddy.userID intValue]) || ([self isUserInMyBuddies:buddy.userID]))
        {
            
        } else
            [buddiesList addObject:buddy];
    }
    
    UINavigationController * controller = (UINavigationController*)appDel.window.rootViewController;
    id obj = [controller.viewControllers objectAtIndex:(controller.viewControllers.count - 1)];
    if([obj isKindOfClass:[UITabBarController class]]){
        
        UITabBarController * tabBar = (UITabBarController*) obj;
        BuddySearchViewController * buddySearchVC = (BuddySearchViewController*) [tabBar.viewControllers objectAtIndex:1];
        [buddySearchVC addFindingUsers:buddiesList];
    }

}

#pragma mark - Work with user Location 

- (void)updateUserLocationLat:(NSString*)_latitude andLong:(NSString*)_longitude
{
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@/%i",strUrl,SubstringCurrentLocation,appDel.user.userID];
    NSString * strUrlRequestData1 = [NSString stringWithFormat:@"latitude=%@&longitude=%@&%@",_latitude,_longitude,APP_ID_KEY];
    
    [self startRequest:strUrlRequestAdress andData:strUrlRequestData1 typeRequest:RequestPut setHeaders:YES andTypeRequest:ApplicationServiceRequestUpdateUserCurrentLocation];
}


#pragma mark - REQUEST

- (NSDictionary *)startRequest:(NSString*) _url andData:(NSString*) _data typeRequest:(NSString*) _type setHeaders:(BOOL)_setHeaders andTypeRequest:(int)typeReust{
    /*if(![HPAppDelegate isActiveConnectedToInternet]){
        [HPAppDelegate OpenAlertwithTitle:@"Error" andContent:@"Problen in connection"];
        return;
    }*/
    NSDictionary* info = [NSDictionary new];
    self.isCorrectRezult = NO;
    NSData * data = [_data dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:_url]];
    [request setHTTPMethod:_type];
    if(([_type isEqualToString: RequestPost] || [_type isEqualToString: RequestDelete] || [_type isEqualToString: RequestPut]) && (data != nil))
        [request setHTTPBody: data];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"must-revalidate" forHTTPHeaderField:@"Cashe-Control"];
    [request setTimeoutInterval:30.0f];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    
    if(_setHeaders){
        [request setValue:appDel.user.userName forHTTPHeaderField:@"X-Username"];
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

- (void)getAllSpecies
{
    NSString *strUrlRequestAddress = [NSString stringWithFormat:@"%@species?%@",URLSportsMaster, APP_ID_KEY];
    NSDictionary *info = [NSDictionary new];
    info = [self startRequest:strUrlRequestAddress andData:nil typeRequest:RequestGet setHeaders:NO andTypeRequest:ApplicationServiceRequestAddBuddy];
    appDel.speciesList = [NSMutableArray new];
    for(NSDictionary * dic in info){
        Species *spec = [Species new];
        [spec initSpeciesWithData:dic];
        [appDel.speciesList addObject:spec];
    }
}

- (BOOL)isUserInMyBuddies:(NSString*)_userID{
    BOOL isBuddy = NO;
    
    for (int i = 0; i < appDel.listUserBuddies.count; i++) {
        Buddy * _buddy = (Buddy* )[appDel.listUserBuddies objectAtIndex:i];
        if([_buddy.userID isEqualToString:_userID]) return YES;
    }
    
    return isBuddy;
}

@end
