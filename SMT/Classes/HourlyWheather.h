//
//  HourlyWheather.h
//  HunterPredictor
//
//  Created by Vasya on 21.02.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HourlyWheather : NSObject

@property (strong, nonatomic) NSString * time;
@property (strong, nonatomic) NSString * tempF;
@property (strong, nonatomic) NSString * windSpeedMiles;
@property (strong, nonatomic) NSString * windDirection;
@property (strong, nonatomic) NSString * weatherIconURL;
@property (strong, nonatomic) NSString * weatherDesc;
@property (strong, nonatomic) NSString * dayOrNigth;
@property (strong, nonatomic) NSString * cloudcover;
@property (strong, nonatomic) NSString * humidity;
@property (strong, nonatomic) NSString * pressure;/*
swellDir16Point : "WNW"
swellHeight_ft : "2.3"
swellHeight_m : "0.7"
swellPeriod_secs : "7.7"
 */

- (id)initWithData:(NSDictionary*)_dic;
- (void)setData:(NSDictionary*)_dic;


@end
