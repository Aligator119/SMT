//
//  WeatherDetailViewController.m
//  HunterPredictor
//
//  Created by Aleksey on 2/20/14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import "WeatherDetailViewController.h"
#import "WeatherDetailCell.h"
#import "AppDelegate.h"

#import "DayPredict.h"
#import "HourlyWheather.h"
#import "UIImageView+AFNetworking.h"

//#import "TidesViewController.h"
#import "DayPredict.h"

@interface WeatherDetailViewController ()
{
    AppDelegate *hpApp;
    NSInteger dayIndex;
    int countListOfDay;
}

@property (nonatomic, weak) IBOutlet NSLayoutConstraint * vericalConstr;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * heightConstr;
@property (nonatomic, weak) IBOutlet UITableView *weatherDetailTableView;
@property (nonatomic, weak) IBOutlet UIButton * backButton;

@end

@implementation WeatherDetailViewController

- (id)initWithIndexPathRow:(NSInteger)row
{
    self = [super init];
    if (self) {
        // Custom initialization
        dayIndex = row;
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        self.vericalConstr.constant -= 20;
        self.heightConstr.constant -= 20;
    }
    hpApp = (AppDelegate *)[UIApplication sharedApplication].delegate;
    countListOfDay = hpApp.wheatherPredictList.dayList.count;
    [self setParamsOfContents];
}

- (void)setParamsOfContents{
    
    DayPredict *day = (DayPredict*)[hpApp.wheatherPredictList.dayList objectAtIndex:dayIndex];
    
    self.lblTitle.text = self.currentLocation.locName;
    
    NSDateFormatter *dateString = [[NSDateFormatter alloc] init];
    [dateString setDateFormat:@"EEEE, MMMM dd"];
    self.date.text = [dateString stringFromDate:day.timeDate];
    self.sunrise.text = [hpApp deleteZeroFromTime:day.astronomySunrise] ;
    self.sunset.text = [hpApp deleteZeroFromTime:day.astronomySunset];
    self.moonrise.text = [hpApp deleteZeroFromTime:day.astronomyMoonrise];
    self.moonset.text = [hpApp deleteZeroFromTime:day.astronomyMoonset];
    //******
    NSString * strTitleName = @"Moon ";
    NSString * strMoonPercent = [NSString stringWithFormat:@"%@%@",day.astronomyMoonpercent,@"%"];
    UIColor * colorTitle = [UIColor colorWithRed:(0.0f/255.0f) green:(102.0f/255.0f) blue:(102.0f/255.0f) alpha:1.0f];
    UIColor * colorMoonPercent = [UIColor whiteColor];
    
    self.lblMoonPercent.attributedText = [self createStringWithTitle:strTitleName Value:strMoonPercent TitleColor:colorTitle ValueColor:colorMoonPercent];
    //*******
    [self.imgMoonIcon setImageWithURL:[NSURL URLWithString:day.astronomyMoonicon] placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((DayPredict*)[hpApp.wheatherPredictList.dayList objectAtIndex:section]).listHourlyPrediction.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    WeatherDetailCell *cell = (WeatherDetailCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WeatherDetailCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    HourlyWheather *hourly = (HourlyWheather*)[((DayPredict*)[hpApp.wheatherPredictList.dayList objectAtIndex:dayIndex]).listHourlyPrediction objectAtIndex:indexPath.row];
    
    cell.time.text = [NSString stringWithFormat:@"     %@",[hpApp deleteZeroFromTime:[self changeHourFrom24FormatTo12:hourly.time]]];
    cell.tepmerature.text = [NSString stringWithFormat:@"%@F",hourly.tempF];
    cell.weatherDescription.text = hourly.weatherDesc;
    cell.wind.text = [NSString stringWithFormat:@"%@ %@mph", hourly.windDirection, hourly.windSpeedMiles];
    cell.humidity.text = [NSString stringWithFormat:@"Humidity: %@%@", hourly.humidity,@"%"];
    cell.pressure.text = [NSString stringWithFormat:@"Pressure: %@mb", hourly.pressure];
    [cell.weatherIcon setImageWithURL:[NSURL URLWithString:hourly.weatherIconURL] placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"]];
    [cell setWindDirectionN:hourly.windDirection];
    
    return cell;
}

- (IBAction)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextPrevDay:(id)sender
{
    if([sender tag] == 1){
        dayIndex--;
        dayIndex = dayIndex < 0 ?  0 : dayIndex;
    } else {
        dayIndex++;
        dayIndex = dayIndex >= countListOfDay ?  (countListOfDay - 1) : dayIndex;
    }
    [self setParamsOfContents];
    [self.weatherDetailTableView reloadData];
}


- (NSAttributedString*)createStringWithTitle:(NSString*)title Value:(NSString*)value TitleColor:(UIColor*)titleColor ValueColor:(UIColor*)valueColor{
    NSString * strTitleNameFull = [NSString stringWithFormat:@"%@%@",title,value];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:strTitleNameFull];
    [attributedText addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(0, title.length)];
    [attributedText addAttribute:NSForegroundColorAttributeName value:valueColor range:NSMakeRange( title.length, value.length)];
    return attributedText;
}
- (NSString*)changeHourFrom24FormatTo12:(NSString*)_time{
    NSArray *hourParts = [_time componentsSeparatedByString:@":"];
    NSInteger hour = ((NSString*)[hourParts firstObject]).floatValue;
    NSString *timeSufix;
    if (hour > 12) {
        hour -= 12;
        timeSufix = @"pm";
    } else {
        timeSufix = @"am";
    }
    NSString *minutes;
    if (hourParts.count > 1) minutes = [NSString stringWithFormat:@":%@", [hourParts lastObject]];
    else minutes = @"";
    NSString *changedTime = [NSString stringWithFormat:@"%i%@ %@", hour, minutes, timeSufix];
    return changedTime;
}






@end
