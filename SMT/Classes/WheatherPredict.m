//
//  WheatherPredict.m
//  HunterPredictor
//
//  Created by Vasya on 21.02.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import "WheatherPredict.h"
#import "DayPredict.h"

#define keyWeather   @"weather"
#define keyData      @"data"
#define keyCurrentCondition @"current_condition"

@implementation WheatherPredict

- (id)init
{
    self = [super init];
    if (self)
    {
        self.dayList = [NSMutableArray new];
    }
    return self;
}

- (void) setDataForWheather:(NSDictionary*)_dic{
    NSDictionary * dicData = [_dic objectForKey:keyData];
    
    if([dicData objectForKey:keyWeather] != nil)
    {
        NSDictionary * dicGetData = [dicData objectForKey:keyWeather];
        
        for(NSDictionary * _dicHourly in dicGetData)
        {
            DayPredict * dayPredict = [DayPredict new];
            [dayPredict setData:_dicHourly];
            [self.dayList addObject:dayPredict];
        }
    }
    if ([dicData objectForKey:keyCurrentCondition] != nil)
    {
        self.currentCondition = [[CurrentCondition alloc]initWithData:[[dicData objectForKey:keyCurrentCondition] firstObject]];
    }
}


@end
