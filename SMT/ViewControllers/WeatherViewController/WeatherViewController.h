//
//  WeatherViewController.h
//  HunterPredictor
//
//  Created by Aleksey on 2/19/14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
#import "SelectLocationViewController.h"

@interface WeatherViewController : GAITrackedViewController <UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate, LocationListViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *sunrise;
@property (strong, nonatomic) IBOutlet UILabel *sunset;
@property (strong, nonatomic) IBOutlet UILabel *moonrise;
@property (strong, nonatomic) IBOutlet UILabel *moonset;
@property (strong, nonatomic) IBOutlet UILabel *date;

@property (nonatomic, copy) NSString * screenName;

@property (strong, nonatomic) Location * currentLocation;

@end
