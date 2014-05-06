//
//  Astronomy.h
//  HunterPredictor
//
//  Created by Vasya on 21.02.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Astronomy : NSObject

@property (strong, nonatomic) NSString * moonrise;
@property (strong, nonatomic) NSString * moonset;
@property (strong, nonatomic) NSString * sunrise;
@property (strong, nonatomic) NSString * sunset;

- (void)setData:(NSDictionary*)_dic;

@end
