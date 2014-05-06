//
//  WheatherPredict.h
//  HunterPredictor
//
//  Created by Vasya on 21.02.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrentCondition.h"

@interface WheatherPredict : NSObject

@property (strong, nonatomic) NSMutableArray * dayList;
@property (strong, nonatomic) CurrentCondition * currentCondition;

- (void) setDataForWheather:(NSDictionary*)_dic;

@end
