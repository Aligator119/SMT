//
//  AppDelegate.h
//  SMT
//
//  Created by Mac on 4/28/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LoginViewController * viewController;
@property (strong, nonatomic) UINavigationController * navigationController;

@end
