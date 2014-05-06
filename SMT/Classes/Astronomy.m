//
//  Astronomy.m
//  HunterPredictor
//
//  Created by Vasya on 21.02.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import "Astronomy.h"

#define keySunset   @"sunset"
#define keySunrise  @"sunrise"
#define keyMoonset @"moonset"
#define keyMoonrise @"moonrise"

@implementation Astronomy

- (id)init
{
    self = [super init];
    if (self)
    {
        self.moonrise = @" ";
        self.moonset = @" ";
        self.sunrise = @" ";
        self.sunset = @" ";
    }
    return self;
}

- (void)setData:(NSDictionary*)_dic{
    for(NSDictionary * dicAstronomy in _dic){
        self.moonrise = [dicAstronomy objectForKey:keyMoonrise];
        self.moonset = [dicAstronomy objectForKey:keyMoonset];
        self.sunset = [dicAstronomy objectForKey:keySunset];
        self.sunrise = [dicAstronomy objectForKey:keySunset];
    }
}



@end
