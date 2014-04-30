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
#import "DailyPrediction.h"
#import "FBConnectClass.h"
#import "ConstantsClass.h"
#import "NSString+HTML.h"
#import "Buddy.h"
#import "SearchingBuddy.h"
#import "BuddySearchViewController.h"

#define RequestPost @"POST"
#define RequestGet @"GET"
#define RequestDelete @"DELETE"
#define RequestPut @"PUT"

#define APP_ID_KEY /*@"app_id=eefffe70&app_key=99b043c0142398fcd928b4a4b62700e4"*/@"app_id=b63800ad&app_key=34eddb50efc407d00f3498dc1874526c"
#define URL_USER_LOGIN @"user=%@&password=%@&%@"
#define URL_USER_CREATE @"firstname=%@&lastname=%@&username=%@&password=%@&birthYear=%@&sex=%@&app_id=b63800ad&app_key=34eddb50efc407d00f3498dc1874526c"

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
    
    @synchronized(self)
    {
        if (instance == nil)
        {
            instance = [[DataLoader alloc] init];
        }
    }
    return instance;
}

- (void)setInitialData{
    keyUsername = @"Username";
    keyUserID = @"User ID";
    self.isCorrectRezult = NO;
}

#pragma mark - Work With Protocol

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // get answer from server
    [receivedData setLength:0];
    NSLog(@"Responce : %@",response.description);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // add new data to receivedData
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // выводим сообщение об ошибке
   /* NSString *errorString = [[NSString alloc] initWithFormat:@"Connection failed! Error - %@ %@ %@",
                             [error localizedDescription],
                             [error description],
                             [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]];
    NSLog(@"Problem in connection : %@",errorString);*/
    NSString * received = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSString * bodyExeption;
    if([received isEqualToString:@"Error: Username or Password is invalid"]) bodyExeption = @"Username or Password is invalid";
    else bodyExeption = @"Problem with connection.\nPlease, try again";
    [AppDelegate OpenAlertwithTitle:@"Error" andContent:bodyExeption];
    NSLog(@"receivedData %@",received);
    
    // освобождаем соединение и полученные данные
    receivedData = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Finish connection succesfull");
    //*****
    /*NSError * jsonError = nil;
    CJSONDeserializer *deserializer = [CJSONDeserializer deserializer];
    info = [deserializer deserialize:receivedData error:&jsonError];
    if(jsonError != nil) {
        NSLog(@"Error JSON :%@", jsonError.description);
    }
    else {
        //NSLog(@"INFO : %@",info);
        [self connectionWasSuccesfull];
    }*/
    if([typeRequest isEqualToString: RequestDelete]){
        NSLog(@"receivedData %@",[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding]);
        self.isCorrectRezult = YES;
        //[self connectionWasSuccesfull];
    }
    else {
        NSError * jsonError = nil;
        CJSONDeserializer *deserializer = [CJSONDeserializer deserializer];
        info = [deserializer deserialize:receivedData error:&jsonError];
        if(jsonError != nil) {
            NSLog(@"Error JSON :%@", jsonError.description);
            NSLog(@"receivedData %@",[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding]);
            
            NSString * htmlString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
            NSString * as = [[[htmlString stringByStrippingTags] stringByRemovingNewLinesAndWhitespace] stringByDecodingHTMLEntities];
            [AppDelegate OpenAlertwithTitle:@"Error" andContent:as];
        }
        else {
            // NSLog(@"INFO : %@",info);
            //[self connectionWasSuccesfull];
            self.isCorrectRezult = YES;
        }
    }
}

#pragma mark - Helpes methods
- (NSString *) convertString:(NSString*)str{
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
    NSString * strUrlRequestData = [NSString stringWithFormat:URL_USER_CREATE,_firstName,_secondName,_userName,_userPassword,_birthYear,_userMale];
    
    enterPassword = userPassword;
    typeOfServiceRequest = ApplicationServiceRequestCreateUser;
    
    [self startRequest:strUrlRequestAdress andData:strUrlRequestData typeRequest:RequestPost setHeaders:NO andTypeRequest:ApplicationServiceRequestCreateUser];
}

-(void) getPredictionWithLocationID: (int) lid andSpecieID: (int)sid {
    NSString * strUrlRequestAddress = [NSString stringWithFormat:@"http://api.sportsmantracker.com/v1/predict/?lid=%@&sid=%@&%@", [NSString stringWithFormat:@"%d", lid], [NSString stringWithFormat:@"%d", sid] , APP_ID_KEY];
    NSString * strUrlRequestData = @"";
    typeOfServiceRequest = ApplicationServiceRequestPredictionInfo;
    [self startRequest:strUrlRequestAddress andData:strUrlRequestData typeRequest:RequestGet setHeaders:NO andTypeRequest:ApplicationServiceRequestPredictionInfo];
}

-(void) createLocationWithName : (NSString*) name Latitude: (double) latitude Longitude: (double) longitude{
    
    CFTimeInterval begin = CACurrentMediaTime();
    NSString * LocationName = [self convertString:name/*@"ыиъйзж"*/];
    NSString * lat = [self convertString:[NSString stringWithFormat:@"%f", latitude]];
    NSString * longit = [self convertString:[NSString stringWithFormat:@"%f", longitude]];
    
    NSString *userId = [NSString stringWithFormat:@"%d", appDel.user.userID];
    
    NSString * strUrlRequestAddress = @"http://api.sportsmantracker.com/v1/location";
    NSString * strUrlRequestData = [NSString stringWithFormat: @"user_id=%@&type_id=1&name=%@&latitude=%@&longitude=%@&%@", userId, LocationName, lat, longit, APP_ID_KEY];
    typeOfServiceRequest = ApplicationServiceRequestCreateLocation;
    
    [self startRequest:strUrlRequestAddress andData:strUrlRequestData typeRequest:RequestPost setHeaders:YES andTypeRequest:ApplicationServiceRequestCreateLocation];
    CFTimeInterval end = CACurrentMediaTime();
    NSLog(@" TIME : %f", end-begin);
}

- (void)avtorizeUser:(NSString*) userName password:(NSString*) userPassword
{
    NSString * _userName = [self convertString:userName];
    NSString * _userPassword = [self convertString:userPassword];
    
    enterPassword = userPassword;
    typeOfServiceRequest = ApplicationServiceRequestAvtorizeUser;
    
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@",strUrl,SubstringLogin];
    NSString * strUrlRequestData = [NSString stringWithFormat:URL_USER_LOGIN,_userName,_userPassword,APP_ID_KEY];
    
    [self startRequest:strUrlRequestAdress andData:strUrlRequestData typeRequest:RequestPost setHeaders:NO andTypeRequest:ApplicationServiceRequestAvtorizeUser];
}

- (void)getLocationsAssociatedWithUser{
    typeOfServiceRequest = ApplicationServiceRequestLocationsAssociatedWithUser;
    NSString * strLocations = [NSString stringWithFormat:@"%i?%@",appDel.user.userID,APP_ID_KEY];
    
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@%@&%@",strUrl,SubstringLocations,strLocations, APP_ID_KEY];
    NSLog(@"URL : %@",strUrlRequestAdress);
    [self startRequest:strUrlRequestAdress andData:nil typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestLocationsAssociatedWithUser];
}

- (void)deleteLocationWithID:(int) _locID{
    typeOfServiceRequest = ApplicationServiceRequestDeleteLocation;
    
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@%@",strUrl,SubstringLocation,[NSString stringWithFormat:@"%i",_locID]];
    NSLog(@"URL : %@",strUrlRequestAdress);
    
    [self startRequest:strUrlRequestAdress andData:APP_ID_KEY typeRequest:RequestDelete setHeaders:YES andTypeRequest:ApplicationServiceRequestDeleteLocation];
}

- (void)updateChooseLocation:(int)_locID
                     newName:(NSString*)_newName
                     newLati:(NSString*)_lati
                     newLong:(NSString*)_long {
    typeOfServiceRequest = ApplicationServiceRequestUpdateLocation;
    
    //curl -v  -X PUT "http://api.sportsmantracker.com/v1/location/61" -d 'name=pole+1&latitude=32.3223&longitude=32.3223&app_id=eefffe70&app_key=99b043c0142398fcd928b4a4b62700e4'
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@%i",strUrl,SubstringLocation,_locID];
    NSLog(@"URL : %@",strUrlRequestAdress);
    NSString * strUrlRequestData = [NSString stringWithFormat:@"name=%@&latitude=%@&longitude=%@&%@",[self convertString:_newName],_lati,_long, APP_ID_KEY];
    
    [self startRequest:strUrlRequestAdress andData:strUrlRequestData typeRequest:RequestPut setHeaders:YES andTypeRequest:ApplicationServiceRequestUpdateLocation];
}

#pragma mark - Work with Buddies request

- (void) buddyGetListUsersBuddies{
    //curl -v -H "X-Username:venko_132@ukr.net" -H "X-Password:1234++" -X GET "http://api.sportsmantracker.com/v1/buddies?app_id=eefffe70&app_key=99b043c0142398fcd928b4a4b62700e4"
    
    typeOfServiceRequest = ApplicationServiceRequestGetListOfBuddies;
    
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@?%@",strUrl,SubstringBuddies,APP_ID_KEY];
    NSLog(@"URL : %@",strUrlRequestAdress);
    [self startRequest:strUrlRequestAdress andData:nil typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestGetListOfBuddies];
}

- (void)buddyAddWithName:(NSString *)buddyName{
  //  curl -v -H "X-Username:venko_12@ukr.net" -H "X-Password:1234++" -X POST "http://api.sportsmantracker.com/v1/buddies" -d 'email=venko_132%40ukr.net&app_id=eefffe70&app_key=99b043c0142398fcd928b4a4b62700e4'
    typeOfServiceRequest = ApplicationServiceRequestAddBuddy;
    
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@",strUrl,SubstringBuddies];
    NSLog(@"URL : %@",strUrlRequestAdress);
    
    NSString * _userName = [self convertString:buddyName];
    NSString * strUrlRequestData = [NSString stringWithFormat:@"email=%@&is_visible=1&%@",_userName,APP_ID_KEY];
    
    [self startRequest:strUrlRequestAdress andData:strUrlRequestData typeRequest:RequestPost setHeaders:YES andTypeRequest:ApplicationServiceRequestAddBuddy];
}

- (void)buddyGetUserBuddyWithId:(int)_idBuddy{
    //curl -v -H "X-Username:venko_132@ukr.net" -H "X-Password:1234++" -X GET "http://api.sportsmantracker.com/v1/buddies/50?app_id=eefffe70&app_key=99b043c0142398fcd928b4a4b62700e4"
    
    typeOfServiceRequest = ApplicationServiceRequestGetInfoAboutBuddy;
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@/%i?%@",strUrl,SubstringBuddies,_idBuddy,APP_ID_KEY];
    NSLog(@"URL : %@",strUrlRequestAdress);
    [self startRequest:strUrlRequestAdress andData:nil typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestGetInfoAboutBuddy];
}

- (void)buddyDeleteUserFromBuddies:(int)_idBuddy{
    //curl -v -H "X-Username:venko_12@ukr.net" -H "X-Password:1234++" -X DELETE "http://api.sportsmantracker.com/v1/buddies/7" -d 'app_id=eefffe70&app_key=99b043c0142398fcd928b4a4b62700e4'
    
    typeOfServiceRequest = ApplicationServiceRequestDeleteFromBuddies;
    
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@/%i",strUrl,SubstringBuddies,_idBuddy];
    NSLog(@"URL : %@",strUrlRequestAdress);

    NSString * strUrlRequestData = [NSString stringWithFormat:@"%@",APP_ID_KEY];
    
    [self startRequest:strUrlRequestAdress andData:strUrlRequestData typeRequest:RequestDelete setHeaders:YES andTypeRequest:ApplicationServiceRequestDeleteFromBuddies];
}

- (void)buddyChangeUserBuddy:(int)_idBuddy status:(int)_statusBuddy andVisible:(int)_visible{
    //curl -v -H "X-Username:venko_132@ukr.net" -H "X-Password:1234++" -X PUT "http://api.sportsmantracker.com/v1/buddies/50" -d 'status=1&app_id=eefffe70&app_key=99b043c0142398fcd928b4a4b62700e4'
    
    typeOfServiceRequest = ApplicationServiceRequestChangeTypeOfBuddyRequest;
    
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@/%i",strUrl,SubstringBuddies,_idBuddy];
    NSLog(@"URL : %@",strUrlRequestAdress);
    
    NSString * strUrlRequestData = [NSString stringWithFormat:@"status=%i&is_visible=%i&%@",_statusBuddy,_visible,APP_ID_KEY];
    
    [self startRequest:strUrlRequestAdress andData:strUrlRequestData typeRequest:RequestPut setHeaders:YES andTypeRequest:ApplicationServiceRequestChangeTypeOfBuddyRequest];
}

- (void)buddySearchByLastName:(NSString *)_name{
    //curl -v -H "X-Username:venko_132@ukr.net" -H "X-Password:1234++" -X GET "http://api.sportsmantracker.com/v1/users?name=as+as+as%40"
    typeOfServiceRequest = ApplicationServiceRequestSearchBuddy;
    NSString * strConvert = [self convertString:_name];
    NSString * strUrlRequestData = [NSString stringWithFormat:@"name=%@&%@",strConvert,APP_ID_KEY];
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@%@",strUrl,@"users?",strUrlRequestData];
    NSLog(@"URL : %@",strUrlRequestAdress);
    
    [self startRequest:strUrlRequestAdress andData:nil typeRequest:RequestGet setHeaders:YES andTypeRequest:ApplicationServiceRequestSearchBuddy];
}

#pragma mark - Work with user Location 

- (void)updateUserLocationLat:(NSString*)_latitude andLong:(NSString*)_longitude{
    //update current location
    //curl -X PUT -H "X-Username: {username}" -H "X-Password: {password}" http://localhost/v1/current_location/{user_id} -d latitude={latitude} -d longitude={longitude}
    
    typeOfServiceRequest = ApplicationServiceRequestUpdateUserCurrentLocation;
    
    NSString * strUrlRequestAdress = [NSString stringWithFormat:@"%@%@/%i",strUrl,SubstringCurrentLocation,appDel.user.userID];
    NSLog(@"URL : %@",strUrlRequestAdress);
    
    NSString * strUrlRequestData1 = [NSString stringWithFormat:@"latitude=%@&longitude=%@&%@",_latitude,_longitude, APP_ID_KEY];
    
    [self startRequest:strUrlRequestAdress andData:strUrlRequestData1 typeRequest:RequestPut setHeaders:YES andTypeRequest:ApplicationServiceRequestUpdateUserCurrentLocation];
}


#pragma mark - REQUEST

- (void)startRequest:(NSString*) _url andData:(NSString*) _data typeRequest:(NSString*) _type setHeaders:(BOOL)_setHeaders andTypeRequest:(int)typeReust{
    /*if(![HPAppDelegate isActiveConnectedToInternet]){
        [HPAppDelegate OpenAlertwithTitle:@"Error" andContent:@"Problen in connection"];
        return;
    }*/
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
    //*** A.C.
    
   /* NSURLConnection * connection = [NSURLConnection connectionWithRequest:request delegate:self];
    if (connection) {
        NSLog(@"Connecting...");
        // создаем NSMutableData, чтобы сохранить полученные данные
        receivedData = [NSMutableData data];
    } else {
        NSLog(@"Connection error!");
        [HPAppDelegate OpenAlertwithTitle:@"Error" andContent:@"Problem with internet\nconnection"];
        return;
    }*/
   // NSLog(@"Responce : %@",response);
    //NSLog(@"receivedData %@",[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding]);
    if(reqError == nil){
        if([_type isEqualToString: RequestDelete]){
            NSLog(@"receivedData %@",[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding]);
            self.isCorrectRezult = YES;
            [self connectionWasSuccesfull:typeReust];
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
                if([as isEqualToString:@"Error Couldn't create user Attribute: username This email already exists."])
                    bdExeption = @"Couldn't create user.\nThis email already exists.";
                
                else if([as isEqualToString:@"Missing first_name and/or last_name"])
                    bdExeption = @"Missing users with these\nfirst name and last name";
                
                else if ([as isEqualToString:@"No users were found"])
                    bdExeption = @"No users were found";
                else bdExeption = @"Problem with connection.\nPlease, try again";
                
                //No buddies were found
                if(typeReust == ApplicationServiceRequestGetListOfBuddies){
                    info = [NSDictionary new];
                    [self connectionWasSuccesfull:typeReust];
                    self.isCorrectRezult = YES;
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^(){
                        if(typeReust != ApplicationServiceRequestGetListOfBuddies)
                            [AppDelegate OpenAlertwithTitle:@"Error" andContent:bdExeption];
                    
                        //if([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                        //   [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                    });
                }
            }
            else {
                [self connectionWasSuccesfull:typeReust];
                self.isCorrectRezult = YES;
            }
        }
    /*if(reqError == nil){
        if([_type isEqualToString: RequestDelete]){
            NSLog(@"receivedData %@",[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding]);
            self.isCorrectRezult = YES;
            [self connectionWasSuccesfull];
        }
        else {
            NSError * jsonError = nil;
            CJSONDeserializer *deserializer = [CJSONDeserializer deserializer];
            info = [deserializer deserialize:receivedData error:&jsonError];
            if(jsonError != nil) {
                NSLog(@"Error JSON :%@", jsonError.description);
                NSLog(@"receivedData %@",[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding]);
                
                NSString * htmlString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
                NSString * as = [[[htmlString stringByStrippingTags] stringByRemovingNewLinesAndWhitespace] stringByDecodingHTMLEntities];
                
                dispatch_async(dispatch_get_main_queue(), ^(){
                    [HPAppDelegate OpenAlertwithTitle:@"Error" andContent:as];
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                });
            }
            else {
                // NSLog(@"INFO : %@",info);
                [self connectionWasSuccesfull];
                self.isCorrectRezult = YES;
            }
        }*/
        
    } else {
        NSString * received = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        NSLog(@"receivedData %@",received);
        NSString * bodyExeption;
        if([received isEqualToString:@"Error: Username or Password is invalid"]) bodyExeption = @"Username or Password is invalid";
        else bodyExeption = @"Problem with connection.\nPlease, try again";
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            if(!appDel.isApplicationInBackground){
                if(typeReust != ApplicationServiceRequestGetListOfBuddies)
                    [AppDelegate OpenAlertwithTitle:@"Error" andContent:bodyExeption];
            }
        });
        
        NSLog(@"receivedData %@",received);
        
    }
}

#pragma  mark - Work with Server RESPONCE

- (void)connectionWasSuccesfull:(int)_typeRequest{
    switch (_typeRequest) {
        case ApplicationServiceRequestAvtorizeUser:
            [self processingDataAvtorizeUser];
            break;
        case ApplicationServiceRequestCreateUser:
            [self processingDataCreateUser];
            break;
        case ApplicationServiceRequestLocationsAssociatedWithUser:
            [self proccesingDataGetLocationsAssociatedWithUser];
            break;
        case ApplicationServiceRequestPredictionInfo:
           [self processingPredictionData];
            break;
        case ApplicationServiceRequestDeleteLocation:
            [self processingPredictionDataDeleteLocation];
            break;
        case ApplicationServiceRequestUpdateLocation:
            [self processingPredictionDataUpdateLocation];
            break;
        case ApplicationServiceRequestCreateLocation:
            [self processingPredictionDataCreateLocation];
            break;
        case ApplicationServiceRequestAddBuddy:
            [self processingPredictionDataAddBuddy];
            break;
        case ApplicationServiceRequestGetListOfBuddies:
            [self processingPredictionDataGetListOfBuddies];
            break;
        case ApplicationServiceRequestGetInfoAboutBuddy:
            [self processingPredictionDataGetInfoAboutBuddy];
            break;
        case ApplicationServiceRequestDeleteFromBuddies:
            [self processingPredictionDataDeleteBuddy];
            break;
        case ApplicationServiceRequestChangeTypeOfBuddyRequest:
            [self processingPredictionDataChangeTypeOfBuddyStatus];
            break;
        case ApplicationServiceRequestUpdateUserCurrentLocation:
            [self processingPredictionDataUpdateUserCurrentLocation];
            break;
        case ApplicationServiceRequestSearchBuddy:
            [self processingPredictionDataSearchBuddy];
            break;
            
        default:
            break;
    }
}

- (void)processingDataCreateUser{
    [appDel.user setUserInfoName:[info objectForKey:keyUsername] appID:[[info objectForKey:keyUserID] intValue]];
    [appDel.user setUserInfoPassword:enterPassword];
    
    NSDictionary *retrievedDictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:FB_USER_SIGN];
    if(retrievedDictionary == nil)
        //[FBConnectClass saveUserIDapp:appDel.user.userID andFacebook:appDel.user.userFID pass:appDel.user.userPassword name:appDel.user.userName];
        [appDel.user saveUser];
    info = nil;
}

- (void)processingDataAvtorizeUser{
    [appDel.user setUserInfoName:[info objectForKey:keyUsername] appID:[[info objectForKey:keyUserID] intValue]];
    [appDel.user setUserInfoPassword:enterPassword];
    info = nil;
}

- (void)proccesingDataGetLocationsAssociatedWithUser{
    NSLog(@"Get Locations");
    // * * * *
    NSMutableArray * listLocations = [NSMutableArray new];
    @try {
        //listLocationName = [[NSMutableArray alloc] initWithArray:info.allKeys];
        for (NSDictionary * dicInfo in info) {
            Location * location = [Location new];
            [location setValuesFromDict:dicInfo];
            if(![location isLocationDelete] && location.typeLocation == typeHunting)
                [listLocations addObject:location];
        }
        self.isCorrectRezult = YES;
    }
    @catch (NSException *exception) {
        self.isCorrectRezult = NO;
        NSLog(@"ERROR !");
    }
    appDel.listLocations = [[NSMutableArray alloc] initWithArray:listLocations];
}

- (void) processingPredictionData{
    NSMutableArray * dailyPredictionsList = [NSMutableArray new];
        for (NSDictionary * dict in info){
            DailyPrediction * dailyPrediction = [DailyPrediction new];
            [dailyPrediction fillInfoFromDictionary:dict];
            [dailyPredictionsList addObject:dailyPrediction];
        }
    appDel.dailyPredict = nil;
    appDel.dailyPredict = [[NSMutableArray alloc] initWithArray:dailyPredictionsList];
}

- (void)processingPredictionDataDeleteLocation{
    NSLog(@"Location was deleted");
}

- (void)processingPredictionDataUpdateLocation{
    NSLog(@"Location was update");
    Location * location = [Location new];
    [location setValuesFromDict:info];
    for(int i=0 ; i < appDel.listLocations.count; i++){
        Location * loc = [[appDel listLocations] objectAtIndex:i];
        if (location.locID == loc.locID){
            [[appDel listLocations] replaceObjectAtIndex:i withObject:location];
        }
    }
}

- (void)processingPredictionDataCreateLocation{
    NSLog(@"Location was created");
    Location * location = [Location new];
    [location setValuesFromDict:info];
    [appDel.listLocations addObject:location];
}

- (void)processingPredictionDataAddBuddy{
    NSLog(@"Friend is add");
    NSLog(@"LOCATION : %@",info);
}

- (void)processingPredictionDataGetListOfBuddies{
    NSLog(@"Get list of buddies");
    NSLog(@"LOCATION : %@",info);
    
    NSMutableArray * buddiesList = [NSMutableArray new];
    @try {
        for(NSDictionary * dic in info){
            Buddy * buddy = [Buddy new];
            [buddy setData:dic];
            [buddiesList addObject:buddy];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Error with getting buddies list in LocationViewController Timer");
    }

    
    appDel.listUserBuddies = nil;
    appDel.listUserBuddies = [[NSMutableArray alloc] initWithArray:buddiesList];
}

- (void)processingPredictionDataGetInfoAboutBuddy{
    NSLog(@"Get info about buddy");
    NSLog(@"LOCATION : %@",info);
    //*******
    Buddy * buddy = [Buddy new];
    [buddy setData:info];
    
    UINavigationController * controller = (UINavigationController*)appDel.window.rootViewController;
    id obj = [controller.viewControllers objectAtIndex:(controller.viewControllers.count - 1)];
    if([obj isKindOfClass:[BuddySearchViewController class]]){
        BuddySearchViewController * viewC = (BuddySearchViewController*)[controller.viewControllers objectAtIndex:(controller.viewControllers.count - 1)];
        [viewC addFindingUserToBuddies:buddy];
        return;
    }
}

- (void)processingPredictionDataDeleteBuddy{
    NSLog(@"Get info about buddy");
    NSLog(@"LOCATION : Buddy with ID <b>0</b> has been deleted");
}

- (void)processingPredictionDataChangeTypeOfBuddyStatus{
    NSLog(@"ChangeTypeOfBuddyStatus");
    //NSLog(@"%@",info);
}

- (void)processingPredictionDataUpdateUserCurrentLocation{
    NSLog(@"UpdateUserCurrentLocation");
}

- (void)processingPredictionDataSearchBuddy{
    NSLog(@"SearchBuddy");
    
    NSMutableArray * buddiesList = [NSMutableArray new];
    for(NSDictionary * dic in info){
        SearchingBuddy * buddy = [SearchingBuddy new];
        [buddy setData:dic];
        //***
        if((appDel.user.userID == [buddy.userID intValue]) || ([self isUserInMyBuddies:buddy.userID])){
            
        } else
            [buddiesList addObject:buddy];
    }
    
    UINavigationController * controller = (UINavigationController*)appDel.window.rootViewController;
    id obj = [controller.viewControllers objectAtIndex:(controller.viewControllers.count - 1)];
    if([obj isKindOfClass:[BuddySearchViewController class]]){
        BuddySearchViewController * viewC = (BuddySearchViewController*)[controller.viewControllers objectAtIndex:(controller.viewControllers.count - 1)];
        [viewC addFindingUsers:buddiesList];
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
