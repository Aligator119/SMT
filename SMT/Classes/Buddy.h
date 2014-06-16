//
//  Buddy.h
//  HunterPredictor
//
//  Created by Vasya on 22.01.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import <Foundation/Foundation.h>

enum TypeOfStatus{
    statusIgnored = 0,
    statusSent = 1,
    statusAccepted = 2
};

@interface Buddy : NSObject

@property (strong, nonatomic) NSString * userName;
@property (strong, nonatomic) NSString * userFirstName;
@property (strong, nonatomic) NSString * userSecondName;
@property (strong, nonatomic) NSString * userID;
@property (strong, nonatomic) NSString * userRelation;
@property (strong, nonatomic) NSString * userPosLatitude;
@property (strong, nonatomic) NSString * userPosLongitude;
@property (nonatomic) BOOL userCanSeeBuddy;
@property (nonatomic) BOOL userBuddyCanSeeUser;
@property (nonatomic, strong) NSString * avatar_url;

- (id)init;
- (void)setData:(NSDictionary*)dic;

@end
