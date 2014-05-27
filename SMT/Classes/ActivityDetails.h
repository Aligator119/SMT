//
//  ActivityDetails.h
//  SMT
//
//  Created by Admin on 5/26/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityDetails : NSObject <NSCoding>

@property (nonatomic) NSInteger subspecies_id;
@property (nonatomic) NSInteger activitylevel;
@property (nonatomic) NSInteger harvested;
@property (nonatomic) NSInteger seen;

@end
