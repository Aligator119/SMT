//
//  DailyPrediction.h
//  HunterPredictor
//
//  Created by Admin on 1/9/14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailyPrediction : UIViewController

@property (nonatomic) NSInteger stars;
@property (strong, nonatomic) NSMutableArray * hourlyPredictionsList;
@property (strong, nonatomic) NSDate * date;
@property (strong, nonatomic) NSString * formatedDate;
@property (strong, nonatomic) NSString * dayOfWeek;
@property (strong, nonatomic) NSString * majorTime1;
@property (strong, nonatomic) NSString * majorTime2;
@property (strong, nonatomic) NSString * minorTime1;
@property (strong, nonatomic) NSString * minorTime2;
@property (strong, nonatomic) NSString * moonAge;
@property (strong, nonatomic) NSString * moonPercent;
@property (strong, nonatomic) NSString * moonPhase;
@property (strong, nonatomic) NSString * moonRise;
@property (strong, nonatomic) NSString * moonSet;
@property (nonatomic) NSInteger nextFullMoon;
@property (strong, nonatomic) NSString * sunRise;
@property (strong, nonatomic) NSString * sunSet;

-(void) fillInfoFromDictionary: (NSDictionary*) info;

@end
