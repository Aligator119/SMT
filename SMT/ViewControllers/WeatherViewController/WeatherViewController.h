//
//  WeatherViewController.h
//  HunterPredictor
//
//  Created by Aleksey on 2/19/14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
//#import "PopUpListLocationViewController.h"
//#import "FishPredictionForLocation.h"

@interface WeatherViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *sunrise;
@property (strong, nonatomic) IBOutlet UILabel *sunset;
@property (strong, nonatomic) IBOutlet UILabel *moonrise;
@property (strong, nonatomic) IBOutlet UILabel *moonset;
@property (strong, nonatomic) IBOutlet UILabel *date;

@property (nonatomic, copy) NSString * screenName;

@property (strong, nonatomic) Location * currentLocation;
//@property (strong, nonatomic) PopUpListLocationViewController * vwListLocations;

//- (void)setPrediction:(FishPredictionForLocation*) _fishPredictionForLocation;

@end
