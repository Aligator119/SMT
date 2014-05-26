//
//  Activity.h
//  SMT
//
//  Created by Admin on 5/26/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Activity : NSObject

@property (nonatomic, strong) NSString * startTime;
@property (nonatomic, strong) NSString * date;
@property (nonatomic, strong) NSString * endTime;
@property (nonatomic) NSInteger location_id;
@property (nonatomic) BOOL predict;
@property (nonatomic, strong) NSString * notes;

@end
