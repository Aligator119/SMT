//
//  SMTGraphView.h
//  SMTGraph
//
//  Created by Alexander on 17.05.14.
//  Copyright (c) 2014 Sasha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface SMTGraphView : UIView <CPTPlotDataSource, CPTPlotSpaceDelegate>

- (void)buildGraphWithDataFromDictionary: (NSMutableDictionary *)dictionary;
- (void)initPlot;

@end
