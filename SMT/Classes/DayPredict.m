//
//  DayPredict.m
//  HunterPredictor
//
//  Created by Vasya on 21.02.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import "DayPredict.h"

#define keyHourly    @"hourly"
#define keyTides    @"tides"
#define keyDate      @"date"
#define keyAstronomy @"astronomy"
#define keyMaxtempF  @"maxtempF"
#define keyMintempF  @"mintempF"
#define keyHourly       @"hourly"
#define keyMaxtempF     @"maxtempF"
#define keyMintempF     @"mintempF"
#define keyDate         @"date"
#define keySunset       @"sunset"
#define keySunrise      @"sunrise"
#define keyMoonset      @"moonset"
#define keyMoonrise     @"moonrise"

#define keyMoonIcon         @"moonicon"
#define keyMoonAge          @"moonage"
#define keyMoonPhase        @"moonphase"
#define keyMoonPercent      @"moonpercent"
#define keyMoonNextFullMoon @"nextfullmoon"

#define keyDateDayOfWeek    @"dayofweek"
#define keyDateFormattedDay @"formatteddate"

#define keyPikMajorTime1    @"majortime1"
#define keyPikMajorTime2    @"majortime2"
#define keyPikMinorTime1    @"minortime1"
#define keyPikMinorTime2    @"minortime2"

@implementation DayPredict

- (id)init
{
    self = [super init];
    if (self)
    {

    }
    return self;
}

- (void)setData:(NSDictionary*)_dicInfo{
    self.astronomyMoonage = [_dicInfo objectForKey:keyMoonAge];
    self.astronomyMoonicon = [_dicInfo objectForKey:keyMoonIcon];
    self.astronomyMoonpercent = [_dicInfo objectForKey:keyMoonPercent];
    self.astronomyMoonphase = [_dicInfo objectForKey:keyMoonAge];
    self.astronomyNextFullMoon = [_dicInfo objectForKey:keyMoonNextFullMoon];
    
    self.astronomyMoonrise = [_dicInfo objectForKey:keyMoonrise];
    self.astronomyMoonset = [_dicInfo objectForKey:keyMoonset];
    self.astronomySunrise = [_dicInfo objectForKey:keySunrise];
    self.astronomySunset = [_dicInfo objectForKey:keySunset];
    
    self.timeDate = [self setDateFromString:[_dicInfo objectForKey:keyDate] ];
    self.timeDayOfWeek = [_dicInfo objectForKey:keyDateDayOfWeek];
    self.timeFormattedDate = [_dicInfo objectForKey:keyDateFormattedDay];
    
    self.timeMajorTime1 = [_dicInfo objectForKey:keyPikMajorTime1];
    self.timeMajorTime2 = [_dicInfo objectForKey:keyPikMajorTime2];
    self.timeMinorTime1 = [_dicInfo objectForKey:keyPikMinorTime1];
    self.timeMinorTime2 = [_dicInfo objectForKey:keyPikMinorTime2];
    
    self.tempMaxF = [_dicInfo objectForKey:keyMaxtempF];
    self.tempMinF = [_dicInfo objectForKey:keyMintempF];
    
    self.listHourlyPrediction = [NSMutableArray new];
    for (NSDictionary * dicHourly in [_dicInfo objectForKey:keyHourly]) {
        HourlyWheather * hourlyPrediction = [[HourlyWheather alloc] initWithData:dicHourly];
        [self.listHourlyPrediction addObject:hourlyPrediction];}
}

- (NSDate*)setDateFromString:(NSString*)_dateString{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate * _dateNew = [dateFormatter dateFromString:_dateString];
        return _dateNew;
    }
- (void)setHourlyFromDic:(NSDictionary* )_dic{
    for(NSDictionary * dicHourly in _dic){
        HourlyWheather * hourlyItem = [[HourlyWheather alloc] initWithData:dicHourly];
        [self.listHourlyPrediction addObject:hourlyItem];
    }
}

@end
