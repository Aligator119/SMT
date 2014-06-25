//
//  FlyoutMenuViewController.m
//  SMT
//
//  Created by Mac on 4/29/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "FlyoutMenuViewController.h"
#import "AppDelegate.h"
#import "MapViewController.h"
#import "LogAnActivityViewController.h"
#import "DataLoader.h"
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
    DataLoader * dataLoader;
}
@property (strong, nonatomic) IBOutlet UIView *presentView;
@property (strong, nonatomic) IBOutlet UIView *forTabBar;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint * topViewHeightConstr;


@property (nonatomic, weak) IBOutlet UICollectionView *table;
@property (strong, nonatomic) IBOutlet UICollectionView *colectionView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segment;


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
    [self.colectionView registerNib:[UINib nibWithNibName:@"ImageShow" bundle:nil] forCellWithReuseIdentifier:@"ImageShow"];
    [self.table registerNib:[UINib nibWithNibName:@"ImageShow" bundle:nil] forCellWithReuseIdentifier:@"ImageShow"];

    self.table.tag = COLECTION_SHOW;
    self.colectionView.tag = COLECTION_DATA;
    
    dataLoader = [DataLoader instance];
    
//--------------------------------------------------------------------------------------------------------------------
    [self AddActivityIndicator:[UIColor redColor] forView:self.view];
    
    self.table.backgroundView = nil;
    
    isPresent = YES;
    [((UIButton *)[self.tabBar viewWithTag:1]) setBackgroundImage:[UIImage imageNamed:@"home_icon_press.png"] forState:UIControlStateNormal];
    
    [self.segment setBackgroundImage:[UIImage imageNamed:@"segment_control_black_BG.png"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
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

//- (void)openReports
//{
//    [self startLoader];
//    DataLoader *loader = [DataLoader instance];
//    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(newQueue, ^(){
//        NSMutableArray *result = [NSMutableArray arrayWithArray:[loader getAllActivities]];
//        
//        dispatch_async(dispatch_get_main_queue(),^(){
//            [self endLoader];
//            ReportsViewController *reportsVC = [ReportsViewController new];
//            reportsVC.activitiesArray = [NSMutableArray arrayWithArray:result];
//            [self.navigationController pushViewController:reportsVC animated:YES];
//        });
//    });
//}


- (void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView.tag == COLECTION_DATA) {
        return 1;
    }
    return 5;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell;
    if (collectionView.tag == COLECTION_DATA) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageShow" forIndexPath:indexPath];
        //add data to bottom colectionView
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
        // action for bottom colectionView
    }
    
    if (collectionView.tag == COLECTION_SHOW) {
        // action for top colectionView
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


@end
