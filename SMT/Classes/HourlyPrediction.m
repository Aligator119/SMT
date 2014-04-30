//
//  HourlyPrediction.m
//  HunterPredictor
//
//  Created by Admin on 1/9/14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import "HourlyPrediction.h"
#import "HourlyPredictionDetails.h"
#import "ConstantsClass.h"

@interface HourlyPrediction ()

@end

@implementation HourlyPrediction

-(void) fillHourlyPredictionWithDictionary: (NSDictionary*) info{
    
    self.dayOrNight = [info objectForKey:@"daynight"];
    self.stars = [[info objectForKey:@"stars"] integerValue];
    self.time = [info objectForKey:@"time"];
    self.weatherCode = [[info objectForKey:@"weatherCode"] integerValue];
    self.weatherImageURL = [info objectForKey:@"weatherUrl"];
    self.windDirection = [info objectForKey:@"winddirection"];
    self.windSpeed = [[info objectForKey:@"windspeed"] integerValue];
    self.temperature = [[info objectForKey:@"temp"] integerValue];
    //****
    self.details = nil;
    self.details = [NSMutableArray new];
    NSDictionary * dicDetails = [info objectForKey:@"details"];
    for (NSDictionary * dict in dicDetails){
        HourlyPredictionDetails * detail = [HourlyPredictionDetails new];
        
        [detail setName:[dict valueForKey:HourlyDetails_Name]
            description:[dict valueForKey:HourlyDetails_Description]
                  stars:[dict valueForKey:HourlyDetails_starsCount]];
        [self.details addObject:detail];
    }
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    
    if (self=[super init]){
        self.dayOrNight = [aDecoder decodeObjectForKey:@"dayOrNight"];
        self.stars = [[aDecoder decodeObjectForKey:@"stars"] integerValue];
        self.time = [aDecoder decodeObjectForKey:@"time"];
        self.weatherCode = [[aDecoder decodeObjectForKey:@"weatherCode"] integerValue];
        self.weatherImageURL = [aDecoder decodeObjectForKey:@"weatherImageURL"];
        self.details = [aDecoder decodeObjectForKey:@"details"];
        self.windSpeed = [aDecoder decodeIntegerForKey:@"windSpeed"];
        self.windDirection = [aDecoder decodeObjectForKey:@"windDirection"];
        self.temperature = [aDecoder decodeIntegerForKey:@"temperature"];
    }
    
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.dayOrNight forKey:@"dayOrNight"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.stars] forKey:@"stars"];
    [aCoder encodeObject:self.time forKey:@"time"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.weatherCode] forKey:@"staweatherCoders"];
    [aCoder encodeObject:self.weatherImageURL forKey:@"weatherImageURL"];
    [aCoder encodeObject:self.details forKey:@"details"];
    [aCoder encodeInteger:self.windSpeed forKey:@"windSpeed"];
    [aCoder encodeInteger:self.temperature forKey:@"temperature"];
    [aCoder encodeObject:self.windDirection forKey:@"windDirection"];
}

@end
