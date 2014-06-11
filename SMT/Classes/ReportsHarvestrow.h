//
//  ReportsHarvestrow.h
//  SMT
//
//  Created by Admin on 6/10/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportsHarvestrow : NSObject

@property (nonatomic) NSInteger activityLevel;
@property (nonatomic) NSInteger harvested;
@property (nonatomic) NSInteger seen;
@property (nonatomic) NSInteger subspecies_id;

-(id) initWithData: (NSDictionary*) dict;

@end
