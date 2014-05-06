//
//  DayPredict.h
//  HunterPredictor
//
//  Created by Vasya on 21.02.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HourlyWheather.h"
#import "Astronomy.h"
#import "TidesPredict.h"

@interface DayPredict : NSObject

@property (strong, nonatomic) NSString * astronomySunset;
@property (strong, nonatomic) NSString * astronomySunrise;
@property (strong, nonatomic) NSString * astronomyMoonrise;
@property (strong, nonatomic) NSString * astronomyMoonset;
@property (strong, nonatomic) NSString * astronomyMoonage;
@property (strong, nonatomic) NSString * astronomyMoonphase;
@property (strong, nonatomic) NSString * astronomyMoonicon;
@property (strong, nonatomic) NSString * astronomyMoonpercent;
@property (strong, nonatomic) NSString * astronomyNextFullMoon;

@property (strong, nonatomic) NSDate * timeDate;
@property (strong, nonatomic) NSString * timeDayOfWeek;
@property (strong, nonatomic) NSString * timeFormattedDate;
@property (strong, nonatomic) NSString * timeMajorTime1;
@property (strong, nonatomic) NSString * timeMajorTime2;
@property (strong, nonatomic) NSString * timeMinorTime1;
@property (strong, nonatomic) NSString * timeMinorTime2;

@property (strong, nonatomic) NSString * tempMaxF;
@property (strong, nonatomic) NSString * tempMinF;

@property (strong, nonatomic) NSMutableArray * listHourlyPrediction;

- (void)setData:(NSDictionary*)_dic;

@end
