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
#import "LogAnActivityViewController.h"
#import "DataLoader.h"
#import "BuddyListViewController.h"
#import "PredictionViewController.h"
#import "ReportsViewController.h"
#import "NewLog1ViewController.h"
#import "FlyoutMenuCell.h"
#import "UIViewController+LoaderCategory.h"
#import "ImageShow.h"
#import "CameraViewController.h"



#define USER_DATA @"userdata"

#define COLECTION_SHOW 5555
#define COLECTION_DATA 1234

@interface FlyoutMenuViewController ()
{
    NSArray * menuItems;
    NSDictionary *functionsDictionary;
    DataLoader * dataLoader;
}
@property (strong, nonatomic) IBOutlet UIView *presentView;
@property (strong, nonatomic) IBOutlet UIView *forTabBar;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint * topViewHeightConstr;


@property (nonatomic, weak) IBOutlet UICollectionView *table;
@property (strong, nonatomic) IBOutlet UICollectionView *colectionView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segment;



- (void)photoClick:(id)notification;


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
        
    }
    [self.colectionView registerNib:[UINib nibWithNibName:@"FlyoutMenuCell" bundle:nil] forCellWithReuseIdentifier:@"FlyoutMenuCell"];
    [self.table registerNib:[UINib nibWithNibName:@"ImageShow" bundle:nil] forCellWithReuseIdentifier:@"ImageShow"];

    self.table.tag = COLECTION_SHOW;
    self.colectionView.tag = COLECTION_DATA;
    
    dataLoader = [DataLoader instance];
    
    [self.table registerNib:[UINib nibWithNibName:@"FlyoutMenuCell" bundle:nil] forCellWithReuseIdentifier:@"FlyoutMenuCell"];
//--------------------------------------------------------------------------------------------------------------------
    menuItems = [[NSArray alloc]initWithObjects:@"Log an Activity", @"Hunting Map", @"Fishing Map", @"Camera/Photos", @"Prediction", @"Reports", @"Weather", @"Buddies", @"Settings", @"Logout", nil];
    
    NSArray *functionsArrayIdentifiers = [[NSArray alloc] initWithObjects:@"openLogAnActivity", @"openHuntingMap", @"openFishingMap", @"openCameraAndPhotos", @"openPrediction", @"openReports", @"openWeather", @"openBuddies", @"openSettings", @"logout", nil];
    
    NSArray *iconsArray = [NSArray arrayWithObjects:@"log_and_activity", @"hunting_map", @"fishing_map", @"camera", @"prediction", @"reports", @"weather", @"buddies", @"settings", @"logout", nil];
    
    functionsDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:functionsArrayIdentifiers, @"identifiers", menuItems, @"strings", iconsArray, @"icons", nil];
//--------------------------------------------------------------------------------------------------------------------
//    if ([app.speciesList firstObject] == nil) {
//        DataLoader * dataLoader = [DataLoader instance];
//        
//        dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        dispatch_async(newQueue, ^(){
//             [dataLoader getAllSpecies];
//        });
//       
//    }
    [self AddActivityIndicator:[UIColor redColor] forView:self.view];
    
    self.table.backgroundView = nil;
    
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoClick:)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setDelegate:self];
    
    [self.view addSubview:self.presentView];
    isPresent = YES;
    [((UIButton *)[self.tabBar viewWithTag:1]) setBackgroundImage:[UIImage imageNamed:@"home_icon_press.png"] forState:UIControlStateNormal];

}

-(void) setIsPresent:(BOOL)present
{
    isPresent = present;
    if (isPresent) {
    [((UIButton *)[self.tabBar viewWithTag:1]) setBackgroundImage:[UIImage imageNamed:@"home_icon_press.png"] forState:UIControlStateNormal];
    [((UIButton *)[self.tabBar viewWithTag:2]) setBackgroundImage:[UIImage imageNamed:@"global_icon.png"] forState:UIControlStateNormal];
    [((UIButton *)[self.tabBar viewWithTag:3]) setBackgroundImage:[UIImage imageNamed:@"camera_icon.png"] forState:UIControlStateNormal];
    [((UIButton *)[self.tabBar viewWithTag:4]) setBackgroundImage:[UIImage imageNamed:@"note_icon.png"] forState:UIControlStateNormal];
    [((UIButton *)[self.tabBar viewWithTag:5]) setBackgroundImage:[UIImage imageNamed:@"st_icon.png"] forState:UIControlStateNormal];
    } else {
        [((UIButton *)[self.tabBar viewWithTag:1]) setBackgroundImage:[UIImage imageNamed:@"home_icon.png"] forState:UIControlStateNormal];
    }
}

- (void)logout
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_DATA];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [((AppDelegate *)[UIApplication sharedApplication].delegate).listLocations removeAllObjects];
    [((AppDelegate *)[UIApplication sharedApplication].delegate).speciesList removeAllObjects];
    ((AppDelegate *)[UIApplication sharedApplication].delegate).defaultLocation = nil;
    [((AppDelegate *)[UIApplication sharedApplication].delegate).listUserBuddies removeAllObjects];
    ((AppDelegate *)[UIApplication sharedApplication].delegate).wheatherPredictList = nil;
    [((AppDelegate *)[UIApplication sharedApplication].delegate).pred removeAllObjects];
    NSString * nibName = [AppDelegate nibNameForBaseName:@"LoginViewController"];
    LoginViewController * lvc = [[LoginViewController alloc]initWithNibName:nibName bundle:nil];
    [self.navigationController pushViewController:lvc animated:YES];
}

- (void)openReports
{
    [self startLoader];
    DataLoader *loader = [DataLoader instance];
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        NSMutableArray *result = [NSMutableArray arrayWithArray:[loader getAllActivities]];
        
        dispatch_async(dispatch_get_main_queue(),^(){
            [self endLoader];
            ReportsViewController *reportsVC = [ReportsViewController new];
            reportsVC.activitiesArray = [NSMutableArray arrayWithArray:result];
            [self.navigationController pushViewController:reportsVC animated:YES];
        });
    });
}

- (void)openWeather
{
    [self.navigationController pushViewController:[[WeatherViewController alloc]init] animated:YES];
}

- (void)openPrediction
{
    [self.navigationController pushViewController:[[PredictionViewController alloc]init] animated:YES];
}


- (void)openBuddies
{
    [self.navigationController pushViewController:[[BuddyListViewController alloc]init] animated:YES];
}

- (void)openLogAnActivity
{
    //[self.navigationController pushViewController:[[LogAnActivityViewController alloc]init] animated:YES];
    [self.navigationController pushViewController:[[NewLog1ViewController alloc]init] animated:YES];
}

- (void)openCameraAndPhotos
{
    PhotoVideoViewController * pvvc = [[PhotoVideoViewController alloc]initWithNibName:@"PhotoVideoViewController" bundle:nil];
    [self.navigationController pushViewController:pvvc animated:YES];
}

-(void)openHuntingMap{
        
        dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(newQueue, ^(){
            [dataLoader getLocationsAssociatedWithUser];
            
            dispatch_async(dispatch_get_main_queue(),^(){
                
                MapViewController * mapVC = [MapViewController new];
                mapVC.mapType = typeHunting;
                [self.navigationController pushViewController:mapVC animated:YES];
            });
        });
}

-(void)openSettings
{
    [self.navigationController pushViewController:[SettingsViewController new] animated:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return menuItems.count;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell;
    if (collectionView.tag == COLECTION_DATA) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FlyoutMenuCell" forIndexPath:indexPath];
        [((FlyoutMenuCell *)cell) processCellWithImageName:[[functionsDictionary objectForKey:@"icons"] objectAtIndex:indexPath.row] andTitle:[menuItems objectAtIndex:indexPath.row]];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageShow" forIndexPath:indexPath];
        switch (indexPath.row) {
            case 0:
                ((ImageShow *)cell).image.image = [UIImage imageNamed:@"bg_reports_selected"];
                break;
            case 1:
                ((ImageShow *)cell).image.image = [UIImage imageNamed:@"global_icon.png"];
                break;
            case 2:
                ((ImageShow *)cell).image.image = [UIImage imageNamed:@"camera_icon.png"];
                break;
            case 3:
                ((ImageShow *)cell).image.image = [UIImage imageNamed:@"note_icon.png"];
                break;
            default:
                ((ImageShow *)cell).image.image = [UIImage imageNamed:@"bg_reports_selected"];
                break;
        }
        
    }
    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (collectionView.tag == COLECTION_DATA) {
        [self performSelector:NSSelectorFromString([[functionsDictionary objectForKey:@"identifiers"] objectAtIndex:indexPath.row])];
    }
    
    if (collectionView.tag == COLECTION_SHOW) {
        CGPoint point = collectionView.contentOffset;
        point.x += 321.0;
        if (point.x >= collectionView.contentSize.width) {
            point.x = 0.0;
        }
        [UIView animateWithDuration:0.7f animations:^{
            collectionView.contentOffset = point;
        }];
        
    }
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
    cell.textLabel.textColor = [UIColor blackColor];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = nil;
    //cell.contentView.backgroundColor =  [UIColor colorWithWhite:1 alpha:0.7];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSelector:NSSelectorFromString([[functionsDictionary objectForKey:@"identifiers"] objectAtIndex:indexPath.row])];
}

- (void) photoClick:notification
{
    PhotoVideoViewController * pvvc = [PhotoVideoViewController new];
    pvvc.delegate = self;
    [self.navigationController pushViewController:pvvc animated:YES];
}


- (void)selectPhoto:(Photo *)photo
{
    [self startLoader];
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
       UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photo.fullPhoto]]];
        //NSString * str =
        [dataLoader setUserAvatar:image];
        
        dispatch_async(dispatch_get_main_queue(),^(){
            
            if(!dataLoader.isCorrectRezult) {
                NSLog(@"Error upload avatar");
                [self endLoader];
            } else {
                //self.imgUser.image = image;
                [self endLoader];
            }

        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
