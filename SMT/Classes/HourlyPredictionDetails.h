//
//  HourlyPredictionDetails.h
//  HunterPredictor
//
//  Created by Vasya on 13.01.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HourlyPredictionDetails : NSObject

@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * description;
@property (strong, nonatomic) NSString * starsCount;

- (void)setName:(NSString *)_nameDetail description:(NSString*) _descriptionD stars:(NSString*)count;
@end
