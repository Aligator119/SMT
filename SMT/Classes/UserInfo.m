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

@synthesize name, userPassword, userID, userFID, userEmail, region_id;

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
    userEmail = _name;
    userPassword = _pass;
    userID = _appID;
}

- (void)setUserInfoName:(NSString*) _name appID:(int) _appID{
    userEmail = _name;
    userID = _appID;
}

- (void)setUserInfoPassword:(NSString*)_pass{
    userPassword = _pass;
}
- (void)setInfoFID:(NSString *)_fid{
    userFID = _fid;
}

- (void)setUserName:(NSString *)_userName {
    name = _userName;
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]){
        userID = [[aDecoder decodeObjectForKey:@"userID"] intValue];
        userFID = [aDecoder decodeObjectForKey:@"userFID"];
        name = [aDecoder decodeObjectForKey:@"Name"];
        userPassword = [aDecoder decodeObjectForKey:@"userPassword"];
        userEmail = [aDecoder decodeObjectForKey:@"userName"];
        region_id = [[aDecoder decodeObjectForKey:@"reginID"] intValue];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:[NSNumber numberWithInt:userID] forKey:@"userID"];
    [aCoder encodeObject:userFID forKey:@"userFID"];
    [aCoder encodeObject:name forKey:@"userName"];
    [aCoder encodeObject:userPassword forKey:@"userPassword"];
    [aCoder encodeObject:userEmail forKey:@"userName"];
    [aCoder encodeObject:@(region_id) forKey:@"reginID"];
}

+ (BOOL)itsFirstMomentWhenUserLogin:(NSString*)usName{
    
    NSMutableDictionary * userList =  [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:SavedListUsers_KEY]];
    
    if(userList != nil){
        for(UserInfo * usInfo in userList){

            if([usInfo.userEmail isEqualToString:usName]){
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
            if([usInfo.userEmail isEqualToString:usName] && (usInfo.userFID.length > 5)){
                return 2;
            } else if([usInfo.userEmail isEqualToString:usName]) return 1;
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
            if([usInfo.userEmail isEqualToString:usName]){
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


- (void)loadImg{
    self.imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.avatarAdress]];
}



@end
