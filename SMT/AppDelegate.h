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

@interface AppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LoginViewController * viewController;
@property (strong, nonatomic) UINavigationController * navigationController;

+ (NSString*) nibNameForBaseName:(NSString *)baseName;
+ (void)OpenAlertwithTitle:(NSString *)_title andContent:(NSString *)_content;

@end
