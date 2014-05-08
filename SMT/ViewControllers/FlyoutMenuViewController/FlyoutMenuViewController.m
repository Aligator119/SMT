//
//  FlyoutMenuViewController.m
//  SMT
//
//  Created by Mac on 4/29/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "FlyoutMenuViewController.h"
#import "WeatherViewController.h"
#import "AppDelegate.h"
#import "MapViewController.h"
#import "SettingsViewController.h"

@interface FlyoutMenuViewController ()
{
    NSArray * menuItems;
    NSDictionary *functionsDictionary;
}
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * topViewHeightConstr;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * topViewVerticalConstr;

@end

@implementation FlyoutMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        self.topViewHeightConstr.constant -= 20;
        self.topViewVerticalConstr.constant -= 20;
    }
    
    AppDelegate  *app = [[UIApplication sharedApplication] delegate];
    self.lbName.text = app.user.userFirstName;
    self.lbLocation.text = app.user.userName;
    //self.lbLocation.text = app.user.userSecondName;
    self.imgUser.layer.masksToBounds = YES;
    self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width / 2;
    NSURL * imgURL = [[NSURL alloc]initWithString:app.user.avatarAdress];
    NSData * data = [[NSData alloc]initWithContentsOfURL:imgURL];
    self.imgUser.image = [UIImage imageWithData:data];
//--------------------------------------------------------------------------------------------------------------------
    menuItems = [[NSArray alloc]initWithObjects:@"Log an Activity", @"Hunting Map", @"Fishing Map", @"Camera/Photos", @"Prediction", @"Reports", @"Weather", @"Buddies", @"Settings", @"Logout", nil];
    
    NSArray *functionsArrayIdentifiers = [[NSArray alloc] initWithObjects:@"openLogAnActivity", @"openHuntingMap", @"openFishingMap", @"openCameraAndPhotos", @"openPrediction", @"openReports", @"openWeather", @"openBuddies", @"openSettings", @"logout", nil];
    
    functionsDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:functionsArrayIdentifiers, @"identifiers", menuItems, @"strings", nil];
}

- (void)openWeather
{
    [self.navigationController pushViewController:[[WeatherViewController alloc]init] animated:YES];
}

-(void)openHuntingMap{
    [self.navigationController pushViewController:[MapViewController new] animated:YES];
}

-(void)openSettings
{
    [self.navigationController pushViewController:[SettingsViewController new] animated:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = [menuItems objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    [cell.contentView setBackgroundColor:[UIColor colorWithRed:56/255.0 green:84/255.0 blue:135/255.0 alpha:1.0]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSelector:NSSelectorFromString([[functionsDictionary objectForKey:@"identifiers"] objectAtIndex:indexPath.row])];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
