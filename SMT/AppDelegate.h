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

@interface AppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LoginViewController * viewController;
@property (strong, nonatomic) UINavigationController * navigationController;

@property (strong, nonatomic) FBSession *session;
@property (strong, nonatomic) UserInfo * user;
@property (strong, nonatomic) NSMutableArray * dailyPredict;
@property (strong, nonatomic) NSMutableArray * listLocations;
@property (strong, nonatomic) NSMutableArray * listUserBuddies;
// TEST
@property (nonatomic) int predictionsCalls;
@property (nonatomic) BOOL isUserSign;
@property (assign,nonatomic) BOOL isApplicationInBackground;

@property (strong, nonatomic) NSMutableArray * pred;

//@property (strong, nonatomic) UserLocationInThisMoment * userLocation;
//@property (strong, nonatomic) NSTimer * timerForUserPositionsUpdating;

+ (NSString*) nibNameForBaseName:(NSString *)baseName;
+ (void)OpenAlertwithTitle:(NSString *)_title andContent:(NSString *)_content;

- (void)getPredictionsCalls;

+ (BOOL)removeGapsWithString:(NSString*)_str;

@end
