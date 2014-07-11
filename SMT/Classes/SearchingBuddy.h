//
//  SearchingBuddy.h
//  HunterPredictor
//
//  Created by Vasya on 17.02.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchingBuddy : NSObject

@property (strong, nonatomic) NSString * userName;
@property (strong, nonatomic) NSString * sex;
@property (strong, nonatomic) NSString * userEmail;
@property (strong, nonatomic) NSString * userFirstName;
@property (strong, nonatomic) NSString * userSecondName;
@property (strong, nonatomic) NSString * birthYear;
//@property (strong, nonatomic) NSString * userAvatar;
//@property (strong, nonatomic) NSDictionary * userProfile;
@property (strong, nonatomic) NSString * userID;

- (id)init;
- (void)setData:(NSDictionary*)dic;

@end
