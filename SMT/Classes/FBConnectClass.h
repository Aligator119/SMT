//
//  FBConnectClass.h
//  HunterPredictor
//
//  Created by Vasya on 03.01.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "DataLoader.h"

enum TypeOfRequest{
    requestLogin = 0,
    requestCreate = 1
};

@interface FBConnectClass : NSObject{
    DataLoader * dataLoader;
}

@property (strong, nonatomic, readonly) NSDictionary * dicRezultRequest;
@property (assign, nonatomic, readonly) BOOL isCorrectConnect;
@property (strong, nonatomic) id delegate;
@property (strong, nonatomic, readonly) NSString * strError;
@property (nonatomic, readonly) BOOL haveError;

- (id)init;
+ (FBConnectClass *)instance;
- (void)sentRequest:(enum TypeOfRequest) _type;
//+ (void)saveUserIDapp:(int)_appID andFacebook:(NSString*)_fID pass:(NSString*)_password name:(NSString*)_usrName;
+ (void)fbLogOut;
//- (void)avtorizeUser;


@end
