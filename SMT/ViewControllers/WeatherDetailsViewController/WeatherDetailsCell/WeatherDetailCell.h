//
//  WeatherDetailCell.h
//  HunterPredictor
//
//  Created by Aleksey on 2/20/14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherDetailCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UIImageView *weatherIcon;
@property (strong, nonatomic) IBOutlet UILabel *tepmerature;
@property (strong, nonatomic) IBOutlet UILabel *weatherDescription;
@property (strong, nonatomic) IBOutlet UILabel *wind;
@property (strong, nonatomic) IBOutlet UILabel *humidity;
@property (strong, nonatomic) IBOutlet UILabel *pressure;
@property (strong, nonatomic) IBOutlet UIImageView *windDirectionIcon;

- (void)setWindDirectionN:(NSString*)strWindDirection;

@end
