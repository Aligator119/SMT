//
//  ReportsHarvestrow.m
//  SMT
//
//  Created by Admin on 6/10/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "ReportsHarvestrow.h"

@implementation ReportsHarvestrow

-(id) initWithData: (NSDictionary*) dict{
    if (self = [super init]){
        self.activityLevel = [[dict objectForKey:@"activitylevel"] integerValue];
        self.harvested = [[dict objectForKey:@"harvested"] integerValue];
        self.seen = [[dict objectForKey:@"seen"] integerValue];
        self.subspecies_id = [[dict objectForKey:@"subspecies_id"] integerValue];
    }
    return self;
}

@end
