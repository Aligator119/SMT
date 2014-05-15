//
//  HPLoginViewController.h
//  HunterPredictor
//
//  Created by Admin on 12/24/13.
//  Copyright (c) 2013 mobilesoft365. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIButton * btnFb;
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) IBOutlet UIButton *btnRegister;
@property (strong, nonatomic) IBOutlet UIView *logoView;

- (void)fbUserLogin:(NSString*)uName password:(NSString*)uPassword;
- (void)fbUserFirstLogin:(NSString*)_name fbID:(NSString*)_fbID;
- (void)sessionIsActive;

@end
