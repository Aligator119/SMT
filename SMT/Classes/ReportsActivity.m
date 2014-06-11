//
//  ReportsActivity.m
//  SMT
//
//  Created by Admin on 6/5/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "ReportsActivity.h"
#import "ReportsHarvestrow.h"

@implementation ReportsActivity

- (id) initWithData: (NSDictionary*) dict{
    if (self = [super init]){
        self.date = [dict objectForKey: @"date"];
        self.activity_id = [[dict objectForKey:@"id"] integerValue];
        self.location_id = [[dict objectForKey:@"location_id"] integerValue];
        NSDictionary *weather = [dict objectForKey:@"weather"];
        self.tempetature = [[weather objectForKey:@"maxtempC"] floatValue];
        self.moonIllumination = [[weather objectForKey:@"moonillum"] floatValue];
        self.harvestrows = [NSMutableArray new];
        for (NSDictionary *harvDict in [dict objectForKey:@"harvestrows"]){
            ReportsHarvestrow *harv = [[ReportsHarvestrow alloc] initWithData:harvDict];
            [self.harvestrows addObject: harv];
        }
    }
    return self;
}

@end
