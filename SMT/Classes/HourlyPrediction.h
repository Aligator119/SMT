//
//  HourlyPrediction.h
//  HunterPredictor
//
//  Created by Admin on 1/9/14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HourlyPrediction : UIViewController

@property (nonatomic) NSInteger stars;
@property (strong, nonatomic) NSString * time;
@property (strong, nonatomic) NSString * dayOrNight;
@property (strong, nonatomic) NSMutableArray * details;
@property (nonatomic) NSInteger weatherCode;
@property (strong, nonatomic) NSString * weatherImageURL;
@property (nonatomic) NSInteger windSpeed;
@property (strong, nonatomic) NSString * windDirection;
@property (nonatomic) NSInteger temperature;


-(void) fillHourlyPredictionWithDictionary: (NSDictionary*) info;

@end
