//
//  UserInfo.m
//  testCaAnimation
//
//  Created by Vasya on 02.01.14.
//  Copyright (c) 2014 Vasya. All rights reserved.
//

#import "UserInfo.h"
#import "ConstantsClass.h"

@implementation UserInfo

@synthesize userName, userPassword, userID, userFID;

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setUserInfoName:@" " password:@" " appID:-1];
        [self setInfoFID:@" "];
    }
    return self;
}

- (void)setUserInfoName:(NSString*) _name password:(NSString*)_pass appID:(int) _appID{
    userName = _name;
    userPassword = _pass;
    userID = _appID;
}

- (void)setUserInfoName:(NSString*) _name appID:(int) _appID{
    userName = _name;
    userID = _appID;
}

- (void)setUserInfoPassword:(NSString*)_pass{
    userPassword = _pass;
}
- (void)setInfoFID:(NSString *)_fid{
    userFID = _fid;
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]){
        userID = [[aDecoder decodeObjectForKey:@"userID"] intValue];
        userFID = [aDecoder decodeObjectForKey:@"userFID"];
        userName = [aDecoder decodeObjectForKey:@"userName"];
        userPassword = [aDecoder decodeObjectForKey:@"userPassword"];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:[NSNumber numberWithInt:userID] forKey:@"userID"];
    [aCoder encodeObject:userFID forKey:@"userFID"];
    [aCoder encodeObject:userName forKey:@"userName"];
    [aCoder encodeObject:userPassword forKey:@"userPassword"];
}

+ (BOOL)itsFirstMomentWhenUserLogin:(NSString*)usName{
    
    NSMutableDictionary * userList =  [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:SavedListUsers_KEY]];
    
    if(userList != nil){
        for(UserInfo * usInfo in userList){

            if([usInfo.userName isEqualToString:usName]){
                return NO;
            }
        }
    }
    return YES;
}

+ (int)itsFirstMomentWhenUserLoginAndIsWithFacebook:(NSString*)usName{
    
    NSMutableDictionary * userList =  [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:SavedListUsers_KEY]];
    
    if(userList != nil){
        for(UserInfo * usInfo in userList){
            if([usInfo.userName isEqualToString:usName] && (usInfo.userFID.length > 5)){
                return 2;
            } else if([usInfo.userName isEqualToString:usName]) return 1;
        }
    }
    return 0;
}

- (void)saveUser{
    NSMutableArray * userList =  [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:SavedListUsers_KEY]];
    if(userList == nil) userList = [NSMutableArray new];
    [userList addObject:self];
    
    NSData *savedPredictData = [NSKeyedArchiver archivedDataWithRootObject:userList];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:savedPredictData forKey:SavedListUsers_KEY];
    [defaults synchronize];
}

- (void)redwriteUserFbID:(NSString*) usName andFID:(NSString*)_FbID{
    NSMutableDictionary * userList =  [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:SavedListUsers_KEY]];
    
    if(userList != nil){
        for(UserInfo * usInfo in userList){
            if([usInfo.userName isEqualToString:usName]){
                usInfo.userFID = _FbID;
                break;
            }
        }
    }
    
    NSData *savedPredictData = [NSKeyedArchiver archivedDataWithRootObject:userList];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:savedPredictData forKey:SavedListUsers_KEY];
    [defaults synchronize];
}






@end
