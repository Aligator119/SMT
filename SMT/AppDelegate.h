//
//  AppDelegate.h
//  SMT
//
//  Created by Mac on 4/28/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "UserInfo.h"
#import "WheatherPredict.h"
#import "Location.h"
#import "CurrentCondition.h"
#import <GoogleMaps/GoogleMaps.h>

@class UserInfo;
@class UserLocationInThisMoment;

static NSString * const kGoogleMapsKey = @"AIzaSyCyCqldV67LGrJTLb9oSNr61-iHMUIUlsA";
static NSString * const kGoogleBrouserAPIkey = @"AIzaSyAgYW3MOr37pwGSATMfWXWklbfn_oaBhCA";

@interface AppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LoginViewController * viewController;
@property (strong, nonatomic) UINavigationController * navigationController;

@property (strong, nonatomic) FBSession *session;
@property (strong, nonatomic) UserInfo * user;
@property (strong, nonatomic) Location * defaultLocation;
@property (strong, nonatomic) NSMutableArray * dailyPredict;
@property (strong, nonatomic) NSMutableArray * listLocations;
@property (strong, nonatomic) NSMutableArray * listUserBuddies;
@property (strong, nonatomic) NSMutableArray * speciesList;
// TEST
@property (strong, nonatomic) WheatherPredict * wheatherPredictList;
@property (strong, nonatomic) CurrentCondition * currentCondition;
@property (nonatomic) int predictionsCalls;
@property (nonatomic) BOOL isUserSign;
@property (assign,nonatomic) BOOL isApplicationInBackground;

@property (strong, nonatomic) NSMutableArray * pred;

//@property (strong, nonatomic) UserLocationInThisMoment * userLocation;
//@property (strong, nonatomic) NSTimer * timerForUserPositionsUpdating;
@property (nonatomic) BOOL userTrackingVisibility;

+ (NSString*) nibNameForBaseName:(NSString *)baseName;
+ (void)OpenAlertwithTitle:(NSString *)_title andContent:(NSString *)_content;

- (void)getPredictionsCalls;

+ (BOOL)removeGapsWithString:(NSString*)_str;

- (void)getSignUser;
- (void)saveSignUser:(UserInfo*)_userInfo;
- (BOOL)isUserSignIn;
- (void)saveStateOfUser:(BOOL)_isSign;
- (void)startUpdateUserPosition;
- (NSString*)deleteZeroFromTime:(NSString*)_time;

@end
