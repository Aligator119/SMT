//
//  SearchingBuddy.m
//  HunterPredictor
//
//  Created by Vasya on 17.02.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import "SearchingBuddy.h"

/*
 "Email": "venko_29@ukr.net",
 "First Name": "as",
 "Last Name": "as",
 "User ID": "103"
 }
 */

#define BUDDY_EMAIL @"Email"
#define BUDDY_FIRST_NAME @"First Name"
#define BUDDY_LAST_NAME @"Last Name"
#define BUDDY_STATUS @"Status"
#define BUDDY_USER_ID @"User ID"

@implementation SearchingBuddy

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
}

- (void)setData:(NSDictionary*)dic{
    self.userName = [dic objectForKey:BUDDY_EMAIL];
    self.userID = [dic objectForKey:BUDDY_USER_ID];
    self.userFirstName = [dic objectForKey:BUDDY_FIRST_NAME];
    self.userSecondName = [dic objectForKey:BUDDY_LAST_NAME];
}


@end
