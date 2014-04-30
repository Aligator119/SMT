//
//  DailyPrediction.m
//  HunterPredictor
//
//  Created by Admin on 1/9/14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import "DailyPrediction.h"
#import "HourlyPrediction.h"

@interface DailyPrediction ()

@end

@implementation DailyPrediction

-(void) fillInfoFromDictionary: (NSDictionary*) info{
    
    NSString * strDate = [info objectForKey:@"date"];
    self.date = [self convertNSStringToDate:strDate];
    
    self.dayOfWeek = [info objectForKey:@"dayofweek"];
    self.formatedDate = [info objectForKey:@"formatteddate"];
    self.stars = [[info objectForKey:@"stars"] integerValue];
    self.majorTime1 = [info objectForKey:@"majortime1"];
    self.majorTime2 = [info objectForKey:@"majortime2"];
    self.minorTime1 = [info objectForKey:@"minortime1"];
    self.minorTime2 = [info objectForKey:@"minortime2"];
    self.moonAge = [info objectForKey:@"moonage"];
    self.moonPercent = [info objectForKey:@"moonpercent"];
    self.moonPhase = [info objectForKey:@"moonphase"];
    self.moonRise = [info objectForKey:@"moonrise"];
    self.moonSet = [info objectForKey:@"moonset"];
    self.nextFullMoon = [[info objectForKey:@"nextfullmoon"] integerValue];
    self.sunRise = [info objectForKey:@"sunrise"];
    self.sunSet = [info objectForKey:@"sunset"];
    
    NSDictionary * hourlyPredictionsDict = [info objectForKey:@"hourly"];
    self.hourlyPredictionsList = [NSMutableArray new];
    
    for (NSDictionary * dict in hourlyPredictionsDict){
        HourlyPrediction * hourlyPrediction = [HourlyPrediction new];
        [hourlyPrediction fillHourlyPredictionWithDictionary:dict];
        [self.hourlyPredictionsList addObject:hourlyPrediction];
    }
    
}

-(NSDate*) convertNSStringToDate: (NSString*) strDate{
    NSDateFormatter * dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * date = [NSDate new];
    date = [dateFormatter dateFromString:strDate];
    return  date;
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    
    if (self=[super init]){
        /*
        self.dayOrNight = [aDecoder decodeObjectForKey:@"dayOrNight"];
        self.stars = [[aDecoder decodeObjectForKey:@"stars"] integerValue];
        self.time = [aDecoder decodeObjectForKey:@"time"];
        self.weatherCode = [[aDecoder decodeObjectForKey:@"weatherCode"] integerValue];
        self.weatherImageURL = [aDecoder decodeObjectForKey:@"weatherImageURL"];*/
        self.date = [aDecoder decodeObjectForKey:@""];
        
        self.dayOfWeek = [aDecoder decodeObjectForKey:@"dayOfWeek"];
        self.formatedDate = [aDecoder decodeObjectForKey:@"formatedDate"];
        self.stars = [[aDecoder decodeObjectForKey:@"stars"] integerValue];
        self.majorTime1 = [aDecoder decodeObjectForKey:@"majorTime1"];
        self.majorTime2 = [aDecoder decodeObjectForKey:@"majorTime2"];
        self.minorTime1 = [aDecoder decodeObjectForKey:@"minorTime1"];
        self.minorTime2 = [aDecoder decodeObjectForKey:@"minorTime2"];
        self.moonAge = [aDecoder decodeObjectForKey:@"moonAge"];
        self.moonPercent = [aDecoder decodeObjectForKey:@"moonPercent"];
        self.moonPhase = [aDecoder decodeObjectForKey:@"moonPhase"];
        self.moonRise = [aDecoder decodeObjectForKey:@"moonRise"];
        self.moonSet = [aDecoder decodeObjectForKey:@"moonSet"];
        self.nextFullMoon = [[aDecoder decodeObjectForKey:@"nextFullMoon"] integerValue];
        self.sunRise = [aDecoder decodeObjectForKey:@"sunRise"];
        self.sunSet = [aDecoder decodeObjectForKey:@"sunSet"];
        self.hourlyPredictionsList = [aDecoder decodeObjectForKey:@"hourlyPredictionsList"];
    }
    
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder{

    [aCoder encodeObject:self.dayOfWeek forKey:@"dayOfWeek"];
    [aCoder encodeObject:self.formatedDate forKey:@"formatedDate"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.stars] forKey:@"stars"];
    [aCoder encodeObject:self.majorTime1 forKey:@"majorTime1"];
    [aCoder encodeObject:self.majorTime2 forKey:@"majorTime2"];
    [aCoder encodeObject:self.minorTime1 forKey:@"minorTime1"];
    [aCoder encodeObject:self.minorTime2 forKey:@"minorTime2"];
    [aCoder encodeObject:self.moonAge forKey:@"moonAge"];
    [aCoder encodeObject:self.moonPercent forKey:@"moonPercent"];
    [aCoder encodeObject:self.moonPhase forKey:@"moonPhase"];
    [aCoder encodeObject:self.moonRise forKey:@"moonRise"];
    [aCoder encodeObject:self.moonSet forKey:@"moonSet"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.nextFullMoon] forKey:@"nextFullMoon"];
    [aCoder encodeObject:self.sunRise forKey:@"sunRise"];
    [aCoder encodeObject:self.sunSet forKey:@"sunSet"];
    [aCoder encodeObject:self.hourlyPredictionsList forKey:@"hourlyPredictionsList"];
}


@end
