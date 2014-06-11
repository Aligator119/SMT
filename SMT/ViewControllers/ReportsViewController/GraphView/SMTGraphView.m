//
//  SMTGraphView.m
//  SMTGraph
//
//  Created by Alexander on 17.05.14.
//  Copyright (c) 2014 Sasha. All rights reserved.
//

#import "SMTGraphView.h"
#import "DateValues.h"

@interface SMTGraphView ()
{
    float graphRange;
    int maxNumberOfSeenValue;
}

@property (nonatomic, strong) CPTGraphHostingView *hostView;
@property (strong, nonatomic) CPTPlotSpaceAnnotation *annotationNumberOfSeen;
@property (strong, nonatomic) NSMutableArray *datesArray;
@property (strong, nonatomic) NSString *graphType;
@property (strong, nonatomic) NSDate *startDay;
@property (strong, nonatomic) NSDate *endOfDay;
@property (strong, nonatomic) NSMutableDictionary *valuesDict;

@end

#define RANGE_FOR_DAY 0.1f
#define RANGE_FOR_WEEK 0.5f
#define RANGE_FOR_MONTH 1.0f

#define FOR_DAY @"day"
#define FOR_WEEK @"week"
#define FOR_MONTH @"month"


@implementation SMTGraphView

@synthesize hostView = hostView_;

- (void)buildGraphWithDataFromDictionary:(NSMutableDictionary *)dictionary
{
    self.valuesDict = dictionary;
    graphRange = RANGE_FOR_DAY;
    self.graphType = FOR_DAY;
    [self getStartData];
    [self initPlot];
}

- (void)day {
    [self.hostView removeFromSuperview];
    self.hostView=nil;
    graphRange = RANGE_FOR_DAY;
    self.graphType = FOR_DAY;
    [self getStartData];
    [self initPlot];
}
- (void)week {
    [self.hostView removeFromSuperview];
    self.hostView=nil;
    graphRange = RANGE_FOR_WEEK;
    self.graphType = FOR_WEEK;
    [self getStartData];
    [self getDictionaryWithDataForWeek];
    [self initPlot];
}
- (void)month {
    [self.hostView removeFromSuperview];
    self.hostView=nil;
    graphRange = RANGE_FOR_MONTH;
    self.graphType = FOR_MONTH;
    [self getStartData];
    [self getDictionaryWithDataForMonth];
    [self initPlot];
}

- (void)getStartData
{
    self.datesArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [self.valuesDict allKeys].count; i++) {
        DateValues *date = [[DateValues alloc]init];
        [date initWithDate:[self.valuesDict allValues][i]  andValue:[self.valuesDict allKeys][i]];
        [self.datesArray addObject:date];
    }
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    self.datesArray = [NSMutableArray arrayWithArray:[self.datesArray sortedArrayUsingDescriptors:sortDescriptors]];
    
    DateValues *dateValues = [self.datesArray firstObject];
    
    self.startDay = [dateValues getStartFromDateForGraphType:self.graphType];
    self.endOfDay = [dateValues getEndFromDateForGraphType:self.graphType];
    
}

- (void)getDictionaryWithDataForWeek
{
    NSMutableArray *weekArray = [[NSMutableArray alloc]init];
    NSMutableArray *tempWeekArray = [[NSMutableArray alloc]init];
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"valueForDate"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    for (int i = 0; i < self.datesArray.count; i++) {
        DateValues *dateValues = self.datesArray[i];
        if (i>0) {
            DateValues *prevDateValues = self.datesArray[i-1];
            if (dateValues.year != prevDateValues.year) {
                if (tempWeekArray.count >0) {
                    NSMutableArray *valuesArray = [NSMutableArray arrayWithArray:[tempWeekArray sortedArrayUsingDescriptors:sortDescriptors]];
                    [weekArray addObject:[valuesArray lastObject]];
                    [tempWeekArray removeAllObjects];
                    [tempWeekArray addObject:dateValues];
                }
            }
            if (dateValues.week == prevDateValues.week) {
                [tempWeekArray addObject:dateValues];
            } else {
                if (tempWeekArray.count >0) {
                    NSMutableArray *valuesArray = [NSMutableArray arrayWithArray:[tempWeekArray sortedArrayUsingDescriptors:sortDescriptors]];
                    [weekArray addObject:[valuesArray lastObject]];
                    [tempWeekArray removeAllObjects];
                    [tempWeekArray addObject:dateValues];
                }
            }
        } else {
            [tempWeekArray addObject:dateValues];
        }
    }
    if (tempWeekArray.count >0) {
        NSMutableArray *valuesArray = [NSMutableArray arrayWithArray:[tempWeekArray sortedArrayUsingDescriptors:sortDescriptors]];
        [weekArray addObject:[valuesArray lastObject]];
    }
    self.datesArray = weekArray;
}

- (void)getDictionaryWithDataForMonth
{
    NSMutableArray *monthsArray = [[NSMutableArray alloc]init];
    NSMutableArray *tempMonthsArray = [[NSMutableArray alloc]init];
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"valueForDate"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    for (int i = 0; i < self.datesArray.count; i++) {
        DateValues *dateValues = self.datesArray[i];
        if (i>0) {
            DateValues *prevDateValues = self.datesArray[i-1];
            if (dateValues.year != prevDateValues.year) {
                if (tempMonthsArray.count >0) {
                    NSMutableArray *valuesArray = [NSMutableArray arrayWithArray:[tempMonthsArray sortedArrayUsingDescriptors:sortDescriptors]];
                    [monthsArray addObject:[valuesArray lastObject]];
                    [tempMonthsArray removeAllObjects];
                    [tempMonthsArray addObject:dateValues];
                }
            }
            if (dateValues.month == prevDateValues.month) {
                [tempMonthsArray addObject:dateValues];
            } else {
                if (tempMonthsArray.count >0) {
                    NSMutableArray *valuesArray = [NSMutableArray arrayWithArray:[tempMonthsArray sortedArrayUsingDescriptors:sortDescriptors]];
                    [monthsArray addObject:[valuesArray lastObject]];
                    [tempMonthsArray removeAllObjects];
                    [tempMonthsArray addObject:dateValues];
                }
            }
        } else {
            [tempMonthsArray addObject:dateValues];
        }
    }
    if (tempMonthsArray.count >0) {
        NSMutableArray *valuesArray = [NSMutableArray arrayWithArray:[tempMonthsArray sortedArrayUsingDescriptors:sortDescriptors]];
        [monthsArray addObject:[valuesArray lastObject]];
    }
    self.datesArray = monthsArray;
}

-(void)initPlot {
    [self configureHost];
    [self configureGraph];
    [self configureAxes];
    [self configurePlots];
}

#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [self.valuesDict allValues].count;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    
    NSInteger valueCount = self.datesArray.count;
    DateValues *dateValues = [DateValues new];
    
    switch (fieldEnum) {
        case CPTScatterPlotFieldX:
            if (index < valueCount) {
                double interval;
                dateValues = [self.datesArray objectAtIndex:index];
                interval = [dateValues.date timeIntervalSinceDate:self.startDay]*12;
                return [NSNumber numberWithDouble:interval];
            } break;
        case CPTScatterPlotFieldY:
            if (index < valueCount){
                dateValues = [self.datesArray objectAtIndex:index];
                return [NSNumber numberWithInt:dateValues.valueForDate];
            }break;
    }
    return nil;
}

- (void)configureHost
{
    self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:self.bounds];
    self.hostView.allowPinchScaling = NO;
    [self addSubview:self.hostView];
}

-(void)configureGraph {
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    [graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    self.hostView.hostedGraph = graph;
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
}

-(void)configurePlots {
    CPTGraph *graph = self.hostView.hostedGraph;
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    CPTScatterPlot *reportPlot = [[CPTScatterPlot alloc] init];
    CPTColor *reportColor = [CPTColor colorWithComponentRed:74.0/255.0f green:122.0/255.0f blue:216.0/255.0f alpha:1.0f];
    reportPlot.dataSource = self;
    
    [graph addPlot:reportPlot toPlotSpace:plotSpace];
    [plotSpace scaleToFitPlots:[NSArray arrayWithObject:reportPlot]];
    
    CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
    xRange.location = CPTDecimalFromCGFloat(-1.0f);
    DateValues *maxDate = (DateValues*)[self.datesArray lastObject];
    xRange.length = CPTDecimalFromDouble([maxDate.date timeIntervalSinceDate:self.startDay]*12);
    [xRange expandRangeByFactor:CPTDecimalFromCGFloat(graphRange)];
    plotSpace.xRange = xRange;
    CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
    yRange.location = CPTDecimalFromCGFloat(-1.0f);

    [plotSpace setGlobalXRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble([self.startDay timeIntervalSinceDate:self.startDay]) length:CPTDecimalFromDouble([maxDate.date timeIntervalSinceDate:self.startDay]*12 )]];
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"valueForDate"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSMutableArray *valuesArray = [NSMutableArray arrayWithArray:[self.datesArray sortedArrayUsingDescriptors:sortDescriptors]];
    
    DateValues *datesValue = [valuesArray lastObject];
    
    maxNumberOfSeenValue = datesValue.valueForDate;
    yRange.length = CPTDecimalFromInt(maxNumberOfSeenValue+maxNumberOfSeenValue/10);
    [yRange expandRangeByFactor:CPTDecimalFromCGFloat(1.1f)];
    plotSpace.yRange = yRange;
    plotSpace.delegate = self;
    
    //[plotSpace setGlobalYRange:yRange];
    
    CPTMutableLineStyle *reportLineStyle = [reportPlot.dataLineStyle mutableCopy];
    reportLineStyle.lineWidth = 1.5;
    reportLineStyle.lineColor = reportColor;
    reportPlot.dataLineStyle = reportLineStyle;
    CPTMutableLineStyle *reportSymbolLineStyle = [CPTMutableLineStyle lineStyle];
    reportSymbolLineStyle.lineColor = reportColor;
    CPTPlotSymbol *reportSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    reportSymbol.fill = [CPTFill fillWithColor:reportColor];
    reportSymbol.lineStyle = reportSymbolLineStyle;
    reportSymbol.size = CGSizeMake(6.0f, 6.0f);
    reportPlot.plotSymbol = reportSymbol;
    
    reportPlot.areaFill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:74.0/255.0f green:122.0/255.0f blue:216.0/255.0f alpha:0.5f]];
    reportPlot.areaBaseValue = CPTDecimalFromInteger(0.0f);
}



-(void)configureAxes {
    
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 1.0f;
    axisLineStyle.lineColor = [CPTColor blackColor];
    CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc] init];
    axisTextStyle.color = [CPTColor blackColor];
    axisTextStyle.fontName = @"Helvetica-Bold";
    axisTextStyle.fontSize = 8.0f;
    CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [CPTColor blackColor];
    tickLineStyle.lineWidth = 2.0f;
    CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
    gridLineStyle.lineColor = [CPTColor grayColor];
    gridLineStyle.lineWidth = 0.5f;
    
    tickLineStyle.lineColor = [CPTColor blackColor];
    tickLineStyle.lineWidth = 1.0f;
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
    
    CPTAxis *x = axisSet.xAxis;
    x.axisLineStyle = axisLineStyle;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.labelTextStyle = axisTextStyle;
    x.majorTickLineStyle = axisLineStyle;
    x.majorTickLength = 4.0f;
    x.tickDirection = CPTSignNegative;
    CGFloat dateCount = self.datesArray.count;
    
    
    NSMutableSet *xLabels = [NSMutableSet setWithCapacity:dateCount];
    NSMutableSet *xLocations = [NSMutableSet setWithCapacity:dateCount];
    CGFloat dayInterval = (float)[self.endOfDay timeIntervalSinceDate:self.startDay]*12;
    
    CGFloat location = 0;
    
    DateValues *startDayValue = [self.datesArray firstObject];
    DateValues *lastDayValue = [self.datesArray lastObject];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-mm-dd"];
    NSDateComponents *dayDifference = [[NSDateComponents alloc] init];
    
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    NSUInteger dayOffset = 1;
    NSDate *nextDate = [startDayValue getStartFromDateForGraphType:self.graphType];
    do {
        [dates addObject:nextDate];
        if ([self.graphType isEqualToString:FOR_DAY]) {
            [dayDifference setDay:dayOffset++];
        }
        else if ([self.graphType isEqualToString:FOR_WEEK]){
            [dayDifference setWeek:dayOffset++];
        }
        else{
            [dayDifference setMonth:dayOffset++];
        }
        NSDate *date = [[NSCalendar currentCalendar] dateByAddingComponents:dayDifference toDate:[startDayValue getStartFromDateForGraphType:self.graphType] options:0];
        nextDate = date;
    } while([nextDate compare:[lastDayValue getEndFromDateForGraphType:self.graphType]] == NSOrderedAscending);
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [[NSDateComponents alloc]init];
    
    if ([self.graphType isEqualToString:FOR_DAY]) {
        for (int i = 0; i < dates.count; i++) {
            dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit) fromDate:dates[i]];
            CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%@ %i", [dateFormatter shortMonthSymbols][dateComponents.month-1], dateComponents.day]  textStyle:x.labelTextStyle];
            location += dayInterval;
            label.tickLocation = CPTDecimalFromCGFloat(location);
            label.offset = x.majorTickLength;
            if (label) {
                [xLabels addObject:label];
                [xLocations addObject:[NSNumber numberWithDouble:location]];
            }
        }
    }
    else if ([self.graphType isEqualToString:FOR_WEEK]){
        for (int i = 0; i < dates.count; i++) {
            dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit) fromDate:dates[i]];
            CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"Week  %@ ",  [dateFormatter shortMonthSymbols][dateComponents.month-1]]  textStyle:x.labelTextStyle];
            location += dayInterval;
            label.tickLocation = CPTDecimalFromCGFloat(location);
            label.offset = x.majorTickLength;
            if (label) {
                [xLabels addObject:label];
                [xLocations addObject:[NSNumber numberWithDouble:location]];
            }
        }
    } else {
        for (int i = 0; i < dates.count; i++) {
            dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit) fromDate:dates[i]];
            CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%i %@", dateComponents.year, [dateFormatter shortMonthSymbols][dateComponents.month-1]]  textStyle:x.labelTextStyle];
            location += dayInterval;
            label.tickLocation = CPTDecimalFromCGFloat(location);
            label.offset = x.majorTickLength;
            if (label) {
                [xLabels addObject:label];
                [xLocations addObject:[NSNumber numberWithDouble:location]];
            }
        }
    }
    
    
    
    x.axisLabels = xLabels;
    x.majorTickLocations = xLocations;
    
    CPTMutableLineStyle *yaxisLineStyle = [CPTMutableLineStyle lineStyle];
    yaxisLineStyle.lineWidth = 0.0f;
    CPTAxis *y = axisSet.yAxis;
    y.axisLineStyle = yaxisLineStyle;
    y.majorGridLineStyle = gridLineStyle;
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    y.labelTextStyle = axisTextStyle;
    y.labelOffset = 1.0f;
    y.majorTickLength = 0.0f;
    
    
    NSInteger majorIncrement = 1;
    NSInteger minorIncrement = 1;
    NSMutableSet *yLabels = [NSMutableSet set];
    NSMutableSet *yMajorLocations = [NSMutableSet set];
    NSMutableSet *yMinorLocations = [NSMutableSet set];
    
    for (NSInteger j = minorIncrement; j <= 700; j += minorIncrement) {
        NSUInteger mod = j % majorIncrement;
        if (mod == 0) {
            CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%li", (long)j] textStyle:y.labelTextStyle];
            NSDecimal location = CPTDecimalFromInteger(j);
            label.tickLocation = location;
            label.offset = y.labelOffset;
            if(j%5==0){
                if (label) {
                    [yLabels addObject:label];
                }
                [yMajorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:location]];}
        } else {
            [yMinorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInteger(j)]];
        }
    }
    y.axisLabels = yLabels;
    y.majorTickLocations = yMajorLocations;
    y.minorTickLocations = yMinorLocations;
}


- (CPTPlotRange *)plotSpace:(CPTPlotSpace *)space
      willChangePlotRangeTo:(CPTPlotRange *)newRange
              forCoordinate:(CPTCoordinate)coordinate {
    
    CPTPlotRange *updatedRange = nil;
    
    switch ( coordinate ) {
        case CPTCoordinateX:
            updatedRange = newRange;
            break;
        case CPTCoordinateY:
            updatedRange = ((CPTXYPlotSpace *)space).yRange;
            break;
        case CPTCoordinateZ:
            break;
    }
    return updatedRange;
}

@end
