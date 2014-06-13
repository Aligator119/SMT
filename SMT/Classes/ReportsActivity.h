//
//  ReportsActivity.h
//  SMT
//
//  Created by Admin on 6/5/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportsActivity : NSObject

@property (nonatomic, strong) NSString *date;
@property (nonatomic) NSInteger activity_id;
@property (nonatomic) NSInteger location_id;
@property (nonatomic, strong) NSMutableArray * harvestrows;
@property (nonatomic) float tempetature;
@property (nonatomic) float moonIllumination;
@property (nonatomic) NSInteger species_id;

- (id) initWithData: (NSDictionary*) dict;

@end
