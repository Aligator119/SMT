//
//  HourlyWheather.m
//  HunterPredictor
//
//  Created by Vasya on 21.02.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import "HourlyWheather.h"

#define keyWeatherDesc      @"weatherDesc"
#define keyWinddir16Point   @"winddir16Point"
#define keyWindspeedMiles   @"windspeedMiles"
#define keyCloudcover       @"cloudcover"
#define keyPressure         @"pressure"
#define keyTime             @"time"
#define keyWeatherIconUrl   @"weatherIconUrl"
#define keyTempF            @"tempF"
#define keyHumidity         @"humidity"
#define keyWeatherDesc      @"weatherDesc"
#define keyDayOrNigth       @"daynight"

#define keyWaterTempF       @"waterTemp_F"

@implementation HourlyWheather

- (id)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

- (id)initWithData:(NSDictionary*)_dic
{
    self = [super init];
    if (self)
    {
        [self setData:_dic];
    }
    return self;
}

- (void)setData:(NSDictionary*)_dicInfo{
    self.time = [self setTimeMyType:[_dicInfo objectForKey:keyTime]];
    self.tempF = [_dicInfo objectForKey:keyTempF];
    self.weatherDesc = [_dicInfo objectForKey:keyWeatherDesc];
    self.weatherIconURL = [_dicInfo objectForKey:keyWeatherIconUrl];
    self.windDirection = [_dicInfo objectForKey:keyWinddir16Point];
    self.windSpeedMiles = [_dicInfo objectForKey:keyWindspeedMiles];
    self.dayOrNigth = [_dicInfo objectForKey:keyDayOrNigth];
    self.cloudcover = [_dicInfo objectForKey:keyCloudcover];
    self.humidity = [_dicInfo objectForKey:keyHumidity];
    self.pressure = [_dicInfo objectForKey:keyPressure];

}


- (NSString*)setTimeMyType:(NSString *)time{
    int timeMy = [time intValue];
    NSMutableString * timeNew = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%i",timeMy/100]];
    [timeNew appendString:@":00"];
    return timeNew;
}



@end
