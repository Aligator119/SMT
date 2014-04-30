//
//  CurrentCondition.m
//  testCaAnimation
//
//  Created by Vasya on 03.03.14.
//  Copyright (c) 2014 Vasya. All rights reserved.
//

#import "CurrentCondition.h"

#define keyCloudCover       @"cloudcover"
#define keyHumidity         @"humidity"
#define keyPrecipMM         @"precipMM"
#define keyPressure         @"pressure"
#define keyTempF            @"temp_F"
#define keyWeatherDesc      @"weatherDesc"
#define keyWeatherIconUrl   @"weatherIconUrl"
#define keyLargeWeatherIconUrl   @"weatherLargeIconUrl"
#define keyWinddir16Point   @"winddir16Point"
#define keyWindspeedMiles   @"windspeedMiles"
#define keySunset           @"sunset"
#define keySunrise          @"sunrise"
#define keyMoonset          @"moonset"
#define keyMoonrise         @"moonrise"

@implementation CurrentCondition

- (id)initWithData:(NSDictionary* )_dicInfo
{
    self = [super init];
    if (self)
    {
        self.cloudcover = [_dicInfo objectForKey:keyCloudCover];
        self.humidity = [_dicInfo objectForKey:keyHumidity];
        self.precipMM = [_dicInfo objectForKey:keyPrecipMM];
        self.pressure = [_dicInfo objectForKey:keyPressure];
        self.tempF = [_dicInfo objectForKey:keyTempF];
        self.weatherDesc = [_dicInfo objectForKey:keyWeatherDesc];
        self.winddir16Point = [_dicInfo objectForKey:keyWinddir16Point];
        self.windSpedMiles = [_dicInfo objectForKey:keyWindspeedMiles];
        self.weatherIconUrl = [_dicInfo objectForKey:keyWeatherIconUrl];
        self.weatherLargeIconUrl = [_dicInfo objectForKey:keyLargeWeatherIconUrl];
        self.imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.weatherLargeIconUrl]];
        self.astronomyMoonrise = [_dicInfo objectForKey:keyMoonrise];
        self.astronomyMoonset = [_dicInfo objectForKey:keyMoonset];
        self.astronomySunrise = [_dicInfo objectForKey:keySunrise];
        self.astronomySunset = [_dicInfo objectForKey:keySunset];
    }
    return self;
}

@end
