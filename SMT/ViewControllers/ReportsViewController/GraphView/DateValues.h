//
//  DateValues.h
//  SMTGraph
//
//  Created by Alexander on 16.05.14.
//  Copyright (c) 2014 Sasha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateValues : NSObject

@property (strong, nonatomic) NSDate *date;

@property (assign, nonatomic) int valueForDate;
@property (assign, nonatomic) int day;
@property (assign, nonatomic) int week;
@property (assign, nonatomic) int month;
@property (assign, nonatomic) int year;

- (void)initWithDate: (NSDate*) date andValue: (NSString*)dateValue;
- (NSDate *)getStartFromDateForGraphType:(NSString *) graphType;
- (NSDate *)getEndFromDateForGraphType:(NSString *) graphType;

@end
