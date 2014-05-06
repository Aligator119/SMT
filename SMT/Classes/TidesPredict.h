//
//  TidesPredict.h
//  HunterPredictor
//
//  Created by Aleksey on 3/3/14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TidesPredict : NSObject

@property (strong, nonatomic) NSString *tideHeight;
@property (strong, nonatomic) NSString *tideTime;

- (id)initWithData:(NSDictionary*)_dic;

@end
