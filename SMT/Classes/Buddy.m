//
//  Buddy.m
//  HunterPredictor
//
//  Created by Vasya on 22.01.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import "Buddy.h"

#define BUDDY_EMAIL @"Email"
#define BUDDY_FIRST_NAME @"First Name"
#define BUDDY_LAST_NAME @"Last Name"
#define BUDDY_STATUS @"Status"
#define BUDDY_USER_ID @"User ID"
#define BUDDY_USER_LATITUDE @"Latitude"
#define BUDDY_USER_LONGITUDE @"Longitude"
#define BUDDY_USER_CAN_SEE_BUDDDY @"is_visible"
#define BUDDY_CAN_SEE_USER @"can_see"
#define BUDDY_AVATAR       @"avatar"
/*
 [
 {
 "Email": "venko_132@ukr.net",
 "First Name": "Bas",
 "Last Name": "Santo",
 "User ID": "7",
 "Status": "REQUEST_ACCEPTED",
 "Latitude": "35.70206900",
 "Longitude": "139.77532700",
 "location_time": "0000-00-00 00:00:00",
 "Invited On": "Wednesday, 22-Jan-14 08:09:38 EST"
 //"is_visible": "0",
 //can_see
 }
 ]
 */

@implementation Buddy

- (id)init
{
    self = [super init];
    
    if (self)
    {
        [self setInitialData];
    }
    return self;
}

- (void)setInitialData{
    self.userName = @" ";
    self.userID = @" ";
    self.userFirstName = @" ";
    self.userSecondName = @" ";
    self.userRelation = @" ";
    self.userPosLatitude = @" ";
    self.userPosLatitude = @" ";
    //self.userAvatar      = @" ";
    self.userCanSeeBuddy = NO;
    self.userBuddyCanSeeUser = NO;
}

- (void)setData:(NSDictionary*)dic{
    self.userName = [dic objectForKey:BUDDY_EMAIL];
    self.userID = [dic objectForKey:BUDDY_USER_ID];
    self.userFirstName = [dic objectForKey:BUDDY_FIRST_NAME];
    self.userSecondName = [dic objectForKey:BUDDY_LAST_NAME];
    self.userRelation = [dic objectForKey:BUDDY_STATUS];
    self.userPosLatitude = [dic objectForKey:BUDDY_USER_LATITUDE];
    self.userPosLongitude = [dic objectForKey:BUDDY_USER_LONGITUDE];
    
    self.userBuddyCanSeeUser = [[dic objectForKey:BUDDY_CAN_SEE_USER] boolValue];
    self.userCanSeeBuddy = [[dic objectForKey:BUDDY_USER_CAN_SEE_BUDDDY] boolValue];
}






@end
