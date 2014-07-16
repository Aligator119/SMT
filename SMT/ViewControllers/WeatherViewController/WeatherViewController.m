//
//  WeatherViewController.m
//  HunterPredictor
//
//  Created by Aleksey on 2/19/14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import "WeatherViewController.h"
#import "WeatherCell.h"
#import "WeatherDetailViewController.h"
#import "AppDelegate.h"
#import "DataLoader.h"

#import "DayPredict.h"
#import "HourlyWheather.h"
#import "CurrentCondition.h"
#import "UIImageView+AFNetworking.h"

@interface WeatherViewController ()
{
    AppDelegate *hpApp;
}

@property (nonatomic, weak) IBOutlet NSLayoutConstraint * vericalConstr;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * heightConstr;

@property (nonatomic, weak) IBOutlet UIView * weatherView;
@property (nonatomic, weak) IBOutlet UIView * currentDetailsView;
@property (nonatomic, weak) IBOutlet UITableView *weatherTableView;
@property (nonatomic, weak) IBOutlet UIButton * backButton;
@property (nonatomic, weak) IBOutlet UIButton * changeButton;
@property (nonatomic, weak) IBOutlet UIButton * currentDetailsButton;

@property (strong, nonatomic) IBOutlet UILabel * lblTitle;

@property (strong, nonatomic) IBOutlet UILabel * lblTempNow;
@property (strong, nonatomic) IBOutlet UILabel * lblCloudcover;
@property (strong, nonatomic) IBOutlet UIImageView * imgIconWheather;
@property (strong, nonatomic) IBOutlet UIImageView * imgIconWind;
@property (strong, nonatomic) IBOutlet UILabel * lblWindSpeed;

@property (strong, nonatomic) IBOutlet UILabel * lblWeatherDesc;
@property (strong, nonatomic) IBOutlet UILabel * lblHumidity;
@property (strong, nonatomic) IBOutlet UILabel * lblPressure;

@end

@implementation WeatherViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    hpApp = (AppDelegate *)[UIApplication sharedApplication].delegate;

    self.screenName = @"Weather";
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        self.vericalConstr.constant -= 20;
        self.heightConstr.constant -= 20;
    }
    [self getLocation];
    self.screenName = @"Weather screen";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (self.currentLocation!=nil) {
        [self setUpdateParams];
        [self.weatherTableView reloadData];
    }
}

- (void)getLocation
{
    DataLoader *loader = [[DataLoader alloc]init];
    
    if (hpApp.defaultLocation == nil) {
        if (hpApp.listLocations == nil) {
            [loader getLocationsAssociatedWithUser];
        }
        if ([hpApp.listLocations firstObject]!=nil) {
            self.currentLocation = (Location*)[hpApp.listLocations firstObject];
            [loader getWeatherPredictionForCurrentLocation:self.currentLocation.locID];
            [self setParamsOfView];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Please, add new location" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add new location", nil];
            [alertView show];
        }
    }
    else{
        self.currentLocation = hpApp.defaultLocation;
        [loader getWeatherPredictionForCurrentLocation:self.currentLocation.locID];
        [self setParamsOfView];
    }
}

- (void)setUpdateParams{
    CurrentCondition * currentCondition = hpApp.wheatherPredictList.currentCondition;
    
    self.lblTempNow.text = [NSString stringWithFormat:@"%@°F", currentCondition.tempF];
    self.lblWindSpeed.text = [NSString stringWithFormat:@"%@ %@ mph",currentCondition.winddir16Point,currentCondition.windSpedMiles];
    self.imgIconWheather.image = [UIImage imageWithData:currentCondition.imgData];
    [self setWindDirection:currentCondition.winddir16Point];
    
    self.lblCloudcover.text = [NSString stringWithFormat:@"%@%%", currentCondition.cloudcover];
    self.lblHumidity.text = [NSString stringWithFormat:@"%@%%",currentCondition.humidity];
    self.lblPressure.text = [NSString stringWithFormat:@"%@mb",currentCondition.pressure];
    
    self.moonrise.text = [hpApp deleteZeroFromTime:currentCondition.astronomyMoonrise];
    self.moonset.text = [hpApp deleteZeroFromTime:currentCondition.astronomyMoonset];
    self.sunrise.text = [hpApp deleteZeroFromTime:currentCondition.astronomySunrise];
    self.sunset.text = [hpApp deleteZeroFromTime:currentCondition.astronomySunset];
}

- (void)setWindDirection:(NSString*)strWindDirection{
    UIImage * img;
    if(strWindDirection.length <= 2){
        img = [UIImage imageNamed:[NSString stringWithFormat:@"%@_arrow_icon.png",strWindDirection]];
        if(img == nil) {
            NSString * charFirst = [strWindDirection substringToIndex:1];
            NSString * charSecond = [strWindDirection substringFromIndex:1];
            strWindDirection = [NSString stringWithFormat:@"%@%@",charSecond,charFirst];
            img = [UIImage imageNamed:[NSString stringWithFormat:@"%@_arrow_icon.png",strWindDirection]];
        }
        self.imgIconWind.image = img;
    } else {
        NSArray * arrKeys = [[NSArray alloc] initWithObjects:@"SSE",@"WSW",@"NNW",@"ENE", nil];
        float gradusReturn = 22.5f;
        BOOL isAddedValue = NO;
        for(NSString* strCompare in arrKeys){
            if([strCompare isEqualToString:strWindDirection]) {
                strWindDirection = [strWindDirection substringFromIndex:1];
                isAddedValue = YES;
                break;
            }
            if(isAddedValue) break;
        }
        if(!isAddedValue){
            strWindDirection = [strWindDirection substringFromIndex:1];
            gradusReturn *= -1;
        }
        img = [UIImage imageNamed:[NSString stringWithFormat:@"%@_arrow_icon.png",strWindDirection]];
        self.imgIconWind.image = img;
        self.imgIconWind.transform = CGAffineTransformRotate(self.imgIconWind.transform, gradusReturn);
        [self chooseWindDirection:gradusReturn];
    }
}

- (void)chooseWindDirection:(float)_gradus{
    
    self.imgIconWind.transform = CGAffineTransformRotate(self.imgIconWind.transform, M_PI / 2);
    
    [UIView animateWithDuration:0.02f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.imgIconWind.transform = CGAffineTransformRotate(self.imgIconWind.transform, M_PI / 2);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                         }
                     }
     ];

    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.01f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.imgIconWind.transform = CGAffineTransformRotate(self.imgIconWind.transform, _gradus * (M_PI/360));
    [UIView commitAnimations];
    
}

- (HourlyWheather*) getHourlyWheatherForThisTime:(int)index
{
    DayPredict *day = (DayPredict*)[hpApp.wheatherPredictList.dayList objectAtIndex:index];
    
    NSDate * dateNow = [NSDate date];
    
    int hour = [self getHour:dateNow];
    if(hour == 24) hour = 0;
    hour = (int)(hour/3);

    HourlyWheather *hourlyWeather = (HourlyWheather*)[day.listHourlyPrediction objectAtIndex:hour];
    return hourlyWeather;
}


- (int)getHour:(NSDate*)_dateS{
    NSDateFormatter *dateString = [[NSDateFormatter alloc] init];
    
    [dateString setDateFormat:@"HH"];
    float nowHour = [dateString stringFromDate:_dateS].floatValue;
    
    [dateString setDateFormat:@"mm"];
    float nowMinute = [dateString stringFromDate:_dateS].floatValue/60.0f;
    
    nowHour +=nowMinute;
    nowHour = roundf(nowHour);
    
    return (int)nowHour;
}

- (NSString*)returnWindIcon{
    return @"test";
}

- (void)setParamsOfView{
    self.currentDetailsView.hidden = YES;
    hpApp = (AppDelegate*) [UIApplication sharedApplication].delegate;
    
    self.lblTitle.text = self.currentLocation.locName;
}


#pragma  mark - Work with Table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *celllIdentifier = @"cell";
    WeatherCell *cell = (WeatherCell*)[tableView dequeueReusableCellWithIdentifier:celllIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WeatherCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    DayPredict *day = (DayPredict*)[hpApp.wheatherPredictList.dayList objectAtIndex:(indexPath.row)];
    HourlyWheather *hourlyWeather = [self getHourlyWheatherForThisTime:indexPath.row];
    NSDateFormatter *dateString = [[NSDateFormatter alloc] init];
    [dateString setDateFormat:@"   EEEE, MMMM dd"];
    cell.dateLabel.text = [dateString stringFromDate:day.timeDate];
    NSString *maxTemperature = day.tempMaxF;
    NSString *minTemperature = day.tempMinF;
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@°F/%@°F", maxTemperature, minTemperature]];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:cell.temperatureLabel.font.fontName size:20] range: NSMakeRange(0, maxTemperature.length+2)];
    cell.temperatureLabel.attributedText = attrStr;
    cell.weatherDescription.text = hourlyWeather.weatherDesc;
    [cell.imgWeather setImageWithURL:[NSURL URLWithString:hourlyWeather.weatherIconURL] placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeatherDetailViewController * weatherDetailController = [[WeatherDetailViewController alloc] initWithIndexPathRow:indexPath.row];
    weatherDetailController.currentLocation = self.currentLocation;
    [self.navigationController pushViewController:weatherDetailController animated:YES];
}


- (IBAction)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changeLocation{
    SelectLocationViewController *locationSelector = [[SelectLocationViewController alloc]init];
    locationSelector.delegate = self;
    [self.navigationController pushViewController:locationSelector animated:YES];
}

- (void)openWeatherPredictionForLocation:(Location *)_location{
    self.currentLocation = _location;
    DataLoader *loader = [[DataLoader alloc]init];
    [loader getWeatherPredictionForCurrentLocation:self.currentLocation.locID];
    self.lblTitle.text = _location.locName;
    [self setUpdateParams];
    [self.weatherTableView reloadData];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        //present map
    }
}
//- (void)setPrediction:(FishPredictionForLocation*) _fishPredictionForLocation{
//    predictionForLocation = _fishPredictionForLocation;
//}

- (void)selectLocation:(Location *)location
{
    [self openWeatherPredictionForLocation:location];
    
}

@end
