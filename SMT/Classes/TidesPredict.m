//
//  TidesPredict.m
//  HunterPredictor
//
//  Created by Aleksey on 3/3/14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import "TidesPredict.h"

#define keyTideHeight_mt      @"tideHeight_mt"
#define keyTideTime      @"tideTime"

@implementation TidesPredict

- (id)initWithData:(NSDictionary*)_dic
{
    self = [super init];
    if (self)
    {
        self.tideHeight = [_dic objectForKey:keyTideHeight_mt];
        self.tideTime = [_dic objectForKey:keyTideTime];
    }
    return self;
}

@end