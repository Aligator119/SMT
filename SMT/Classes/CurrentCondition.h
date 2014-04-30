//
//  CurrentCondition.h
//  testCaAnimation
//
//  Created by Vasya on 03.03.14.
//  Copyright (c) 2014 Vasya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentCondition : NSObject

@property (strong, nonatomic) NSString * humidity;
@property (strong, nonatomic) NSString * pressure;
@property (strong, nonatomic) NSString * cloudcover;
@property (strong, nonatomic) NSString * tempF;
@property (strong, nonatomic) NSString * weatherDesc;
@property (strong, nonatomic) NSString * windSpedMiles;
@property (strong, nonatomic) NSString * winddir16Point;
@property (strong, nonatomic) NSString * weatherIconUrl;
@property (strong, nonatomic) NSString * weatherLargeIconUrl;
@property (strong, nonatomic) NSString * precipMM;
@property (strong, nonatomic) NSData   * imgData;
@property (strong, nonatomic) NSString * astronomySunset;
@property (strong, nonatomic) NSString * astronomySunrise;
@property (strong, nonatomic) NSString * astronomyMoonrise;
@property (strong, nonatomic) NSString * astronomyMoonset;
@property (strong, nonatomic) NSString * astronomyMoonage;

- (id)initWithData:(NSDictionary* )_dicInfo;

@end
