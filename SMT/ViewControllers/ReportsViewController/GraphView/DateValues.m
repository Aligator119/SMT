//
//  DateValues.m
//  SMTGraph
//
//  Created by Alexander on 16.05.14.
//  Copyright (c) 2014 Sasha. All rights reserved.
//

#import "DateValues.h"
#define FOR_DAY @"day"
#define FOR_WEEK @"week"
#define FOR_MONTH @"month"

@implementation DateValues


- (void)initWithDate: (NSDate*) date andValue:(NSString *)dateValue
{
    self.date = date;
    self.valueForDate = [dateValue integerValue];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit) fromDate:date];
    
    self.day = dateComponents.day;
    self.week = dateComponents.week;
    self.month = dateComponents.month;
    self.year = dateComponents.year;
}


- (NSDate *)getStartFromDateForGraphType:(NSString *) graphType
{
    NSDate *startDate = [[NSDate alloc]init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    if ([graphType isEqualToString:FOR_DAY]) {
        NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit) fromDate:self.date];
        [dateComponents setHour:0];
        [dateComponents setMinute:0];
        [dateComponents setSecond:0];
        
        startDate = [calendar dateFromComponents:dateComponents];
    }
    else if ([graphType isEqualToString:FOR_WEEK]){
        
        NSDateComponents *dateComponents = [calendar components:( NSYearForWeekOfYearCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit |NSWeekdayCalendarUnit) fromDate:self.date];
        [dateComponents setWeekday:0];
        [dateComponents setHour:0];
        [dateComponents setMinute:0];
        [dateComponents setSecond:0];
        
        startDate = [calendar dateFromComponents:dateComponents];
        
    }
    else if ([graphType isEqualToString:FOR_MONTH]){
        NSDateComponents *dateComponents = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit ) fromDate:self.date];
        [dateComponents setDay:0];
        [dateComponents setHour:0];
        [dateComponents setMinute:0];
        [dateComponents setSecond:0];
        
        startDate = [calendar dateFromComponents:dateComponents];
        
    }
    return startDate;
}



- (NSDate *)getEndFromDateForGraphType:(NSString *) graphType
{
    NSDate *lastDate = [[NSDate alloc]init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    if ([graphType isEqualToString:FOR_DAY]) {
        NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit) fromDate:self.date];
        [dateComponents setHour:24];
        [dateComponents setMinute:0];
        [dateComponents setSecond:0];
        
        lastDate = [calendar dateFromComponents:dateComponents];
    }
    else if ([graphType isEqualToString:FOR_WEEK]){
        
        NSDateComponents *dateComponents = [calendar components:( NSYearForWeekOfYearCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit |  NSWeekCalendarUnit) fromDate:self.date];
        [dateComponents setWeekday:7];
        [dateComponents setHour:0];
        [dateComponents setMinute:0];
        [dateComponents setSecond:0];
        
        lastDate = [calendar dateFromComponents:dateComponents];
        
    }
    else if ([graphType isEqualToString:FOR_MONTH]){
        NSDateComponents *dateComponents = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit ) fromDate:self.date];
        [dateComponents setDay:0];
        [dateComponents setMonth:dateComponents.month +1];
        [dateComponents setHour:0];
        [dateComponents setMinute:0];
        [dateComponents setSecond:0];
        
        lastDate = [calendar dateFromComponents:dateComponents];
        
    }
    return lastDate;
}


@end
