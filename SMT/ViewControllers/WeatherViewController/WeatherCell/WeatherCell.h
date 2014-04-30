//
//  WeatherCell.h
//  HunterPredictor
//
//  Created by Aleksey on 2/20/14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *weatherDescription;
@property (strong, nonatomic) IBOutlet UIImageView * imgWeather;
@property (strong, nonatomic) IBOutlet UIImageView * imgDetail;

@end
