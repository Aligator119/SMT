//
//  FBConnectClass.m
//  HunterPredictor
//
//  Created by Vasya on 03.01.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import "FBConnectClass.h"
#import "DataLoader.h"
#import "ConstantsClass.h"
#import "RegisterViewController.h"
//#import "HPSignUpViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "ConstantsClass.h"
#import <FacebookSDK/FacebookSDK.h>
#import "UserInfo.h"

@implementation FBConnectClass{
    NSDictionary * dicUserKey;
}

@synthesize dicRezultRequest;
@synthesize isCorrectConnect;
@synthesize strError,haveError ;

- (id)init
{
    self = [super init];
    
    if (self)
    {
        dataLoader = [DataLoader instance];
    }
    return self;
}

+ (FBConnectClass *)instance
{
    static FBConnectClass *instance = nil;
    
    @synchronized(self)
    {
        if (instance == nil)
        {
            instance = [[FBConnectClass alloc] init];
        }
    }
    return instance;
}


- (void)sentRequest:(enum TypeOfRequest) _type{
    // FBSample logic
    // if the session is open, then load the data for our view controller
    haveError = NO;
    
    /*if(![HPAppDelegate isActiveConnectedToInternet]){
        [HPAppDelegate OpenAlertwithTitle:@"Error" andContent:@"Problen in connection"];
        return;
    }*/
    
    if (!FBSession.activeSession.isOpen) {
        // if the session is closed, then we open it here, and establish a handler for state changes
        switch (FBSession.activeSession.state) {
            case FBSessionStateOpen:
                /*! Open session state indicating user has logged in or a cached token is available */
                
                break;
                
            case FBSessionStateOpenTokenExtended:
                /*! Open session state indicating token has been extended */
                break;
                
            case FBSessionStateClosedLoginFailed:
            {
                /*! Closed session state indicating that a login attempt failed */
                
            }
                break;
                
            case FBSessionStateClosed:
                /*! Closed session state indicating that the session was closed, but the users token
                 remains cached on the device for later use */
                break;
                
            case FBSessionStateCreated :
                /*! One of two initial states indicating that no valid cached token was found */
                break;
                
            case FBSessionStateCreatedTokenLoaded:
                /*! One of two initial session states indicating that a cached token was loaded;
                 when a session is in this state, a call to open* will result in an open session,
                 without UX or app-switching*/
                break;
                
            case FBSessionStateCreatedOpening:
                /*! One of three pre-open session states indicating that an attempt to open the session
                 is underway*/
                break;
        }
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info",@"email",@"user_birthday",@"user_about_me"]
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState state,
                                                          NSError *error) {
                                          if (error) {
                                              UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                  message:@"Problem with connection.\nPlease, try again"
                                                                                                 delegate:nil
                                                                                        cancelButtonTitle:@"OK"
                                                                                        otherButtonTitles:nil];
                                              [alertView show];
                                              
                                              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                              [[UIApplication sharedApplication]endIgnoringInteractionEvents];
                                              
                                              haveError = YES;
                                              strError = @"Problem with connection.\nPlease, try again";
                                          } else if (session.isOpen) {
                                              
                                              NSDictionary *queryParam = @{@"q" : @"SELECT pic_crop from profile where id=me()"};
                                              
                                              FBRequest * request = [FBRequest requestWithGraphPath:@"/fql" parameters:queryParam HTTPMethod:@"GET"];
                                              [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                                  
                                                  if(!error){
                                                      
                                                      NSArray * resultArray = result[@"data"];
                                                      dicRezultRequest = (id)resultArray[0];
                                                      //NSDictionary * profilePicture = rResult[@"pic_crop"];
                                                     // NSString * profilePictureLink = [NSString stringWithFormat:@"%@", profilePicture[@"uri"]];
                                                      NSString * query = @"SELECT uid, first_name, last_name, email, sex,  birthday_date,username FROM user WHERE uid = me()";
                                                      
                                                      FBRequest *request = [FBRequest requestWithGraphPath:@"/fql" parameters:@{@"q" : query} HTTPMethod:@"GET"];
                                                      [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                                          
                                                          NSString * userErrorDescr = nil;
                                                          if (error){
                                                              NSLog(@"Error whyle do FQL req: %@", [error localizedDescription]);
                                                              userErrorDescr = [NSString stringWithFormat:@"Internet connection error : %@", [error localizedDescription]];
                                                              strError = userErrorDescr;
                                                              haveError = YES;
                                                          }
                                                          else{
                                                              NSArray * arr = result[@"data"];
                                                              dicRezultRequest = (id)arr[0];
                                                              NSLog(@"Dictinary : %@",dicRezultRequest);
                                                              isCorrectConnect = YES;
                                                              if(_type == requestCreate) [self createUser];
                                                              else [self avtorizeUser];
                                                          }
                                                      }];
                                                  } else {
                                                      NSString * userErrorDescr = nil;
                                                      userErrorDescr = [NSString stringWithFormat:@"Internet connection error : %@", [error localizedDescription]];
                                                      strError = userErrorDescr;
                                                      haveError = YES;
                                                  }
                                              }];
                                          }
                                      }];
        
        return;
    } else {
        isCorrectConnect = YES;
        if(_type == requestCreate) [self createUser];
        else [self avtorizeUser];
    }
}

- (void)createUser{
    NSLog(@"User registration");
    if(isCorrectConnect){
        
        NSString * userName = [dicRezultRequest objectForKey:FB_USER_EMAIL];
        NSString * userID = [NSString stringWithFormat:@"%@",[dicRezultRequest objectForKey:FB_USER_FID]];
        NSString * userSecondName = [dicRezultRequest objectForKey:FB_USER_LASTNAME];
        NSString * userFirsName = [dicRezultRequest objectForKey:FB_USER_FIRSTNAME];
        NSString * userSex = [dicRezultRequest objectForKey:FB_USER_SEX];
        
        NSString * buffer = [dicRezultRequest objectForKey:FB_USER_Birthday];
        int userBirthYear = 0;
        if(buffer != nil){
            NSArray * buff = [buffer componentsSeparatedByString:@"/"];
            userBirthYear = [[buff objectAtIndex:([buff count] - 1)] intValue];
        }

        NSString * _nibName = [AppDelegate nibNameForBaseName:@"RegisterViewController"];
        
        RegisterViewController * view = [[RegisterViewController alloc] initWithNibName:_nibName bundle:nil];
        [view fillRegistrationInfo:userFirsName :userSecondName :userName :userBirthYear :userSex andUserFid:userID];
        view.isSignWithFacebook = YES;
        /*
        SEL open = @selector(fbRegistaration:);
        if([self.delegate respondsToSelector:open]){
            [self.delegate fbRegistaration:view];
        }
    } else {
        [self.delegate stopInternatIndicator];
    }
         */}
}

- (void)avtorizeUser{
    NSLog(@"User avtorize");
    if(isCorrectConnect){
        NSString * userName = [dicRezultRequest objectForKey:FB_USER_EMAIL];
        NSString * userFBid = [NSString stringWithFormat:@"%@",[dicRezultRequest objectForKey:FB_USER_FID] ];
        
        //**** Is first time when youser login from facebook
        BOOL isFirst = YES;
        UserInfo * findUser = nil;
        
        NSMutableArray * userList =  [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:SavedListUsers_KEY]];
        
        if(userList != nil){
            for(UserInfo * usInfo in userList){
                if([usInfo.userFID isEqualToString:userFBid]){
                    isFirst = NO;
                    findUser = usInfo;
                    break;
                }
            }
            if(!isFirst){
                // * * * * *
                SEL open = @selector(fbUserLogin:password:);
                if([self.delegate respondsToSelector:open]){
                    [self.delegate fbUserLogin:findUser.userName password:findUser.userPassword];
                    
                }
            } else { // Data is upsent
                SEL open = @selector(fbUserFirstLogin:fbID:);
                if([self.delegate respondsToSelector:open]){
                    [self.delegate fbUserFirstLogin:userName fbID:userFBid];
                }
            }
            
        } else { //empty lis
            SEL open = @selector(fbUserFirstLogin:fbID:);
            if([self.delegate respondsToSelector:open]){
                [self.delegate fbUserFirstLogin:userName fbID:userFBid];
            }
        }
    } else {
        NSLog(@"Problen in connect");
        strError = @"Problen in avtorize, try again";
    }
}


/*+ (void)saveUserIDapp:(int)_appID andFacebook:(NSString*)_fID pass:(NSString*)_password name:(NSString*)_usrName{
    NSMutableDictionary *dic = [[NSMutableDictionary  alloc] init];
    [dic setObject:[NSString stringWithFormat:@"%i",_appID] forKey:@"appID"];
    [dic setObject:_fID forKey:@"fID"];
    [dic setObject:_password forKey:@"appPass"];
    [dic setObject:_usrName forKey:@"userName"];
    
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:FB_USER_SIGN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}*/

+ (void)saveUser:(UserInfo*)_userInfo{
    NSMutableArray * userList =  [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:SavedListUsers_KEY]];
    
    [userList addObject:_userInfo];
    
    NSData *savedPredictData = [NSKeyedArchiver archivedDataWithRootObject:userList];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:savedPredictData forKey:SavedListUsers_KEY];
    [defaults synchronize];
}

/*- (BOOL)isLogin:(NSString*)_userID{
    NSDictionary *retrievedDictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:FB_USER_SIGN];
    NSString * fID = [NSString stringWithFormat:@"%@",[retrievedDictionary objectForKey:@"fID"]];
    
    dicUserKey = nil;
    dicUserKey = retrievedDictionary;
    if(![fID isEqualToString:fID]) return NO;
    return YES;
}*/

+ (void)fbLogOut{
    [FBSession.activeSession closeAndClearTokenInformation];
}



@end
