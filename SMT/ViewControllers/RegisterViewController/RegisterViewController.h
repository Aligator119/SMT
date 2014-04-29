//
//  HPSignUpViaEmailViewController.h
//  HunterPredictor
//
//  Created by Admin on 12/25/13.
//  Copyright (c) 2013 mobilesoft365. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "UIViewController+LoaderCategory.h"

#define MAX_STRING_LENGTH 32

@interface RegisterViewController : UIViewController <UITextFieldDelegate>{
    NSString * userFirstName;
    NSString * userSecondName;
    NSString * userName;
    NSString * userSex;
    int userBirthYear;
    NSString * userFid;
}

@property (nonatomic) BOOL isSignWithFacebook;

-(void) fillRegistrationInfo: (NSString*) firstName :(NSString*) lastName :(NSString*) email :(int) birthYear : (NSString*) sex andUserFid:(NSString*)userFID;

@end
