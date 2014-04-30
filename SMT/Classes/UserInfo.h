//
//  UserInfo.h
//  testCaAnimation
//
//  Created by Vasya on 02.01.14.
//  Copyright (c) 2014 Vasya. All rights reserved.
//

#import <Foundation/Foundation.h>

enum fbAttribute{
    fbUserMissing = 0,
    fbUserCreate = 1,
    fbUserCreateFB = 2
};

//com.mobilesoft365.HunterPredictor
//${PRODUCT_NAME}

@interface UserInfo : NSObject

@property (strong, nonatomic) NSString * userName;
@property (strong, nonatomic) NSString * userPassword;
@property (nonatomic, readonly) int userID;
@property (strong, nonatomic) NSString * userFID;

- (id) init;
- (void)setUserInfoName:(NSString*) _name password:(NSString*)_pass appID:(int) _appID;
- (void)setUserInfoName:(NSString*) _name appID:(int) _appID;
- (void)setUserInfoPassword:(NSString*) _pass;
- (void)setInfoFID:(NSString*)_fid;

+ (int)itsFirstMomentWhenUserLoginAndIsWithFacebook:(NSString*)usName;
+ (BOOL)itsFirstMomentWhenUserLogin:(NSString*)usName;
- (void)saveUser;
- (void)redwriteUserFbID:(NSString*) usName andFID:(NSString*)_FbID;

@end
