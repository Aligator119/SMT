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
    BOOL selectedBtn1;
    BOOL selectedBtn2;
    BOOL selectedBtn3;
    BOOL selectedBtn4;
}
@property (strong, nonatomic) IBOutlet UIView *forTabBar;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint * topViewHeightConstr;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btn1Hegth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btn4Hegth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btn2Hegth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btn3Hegth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tabBarWidth;
@property (strong, nonatomic) IBOutlet UIView *btn1fone;
@property (strong, nonatomic) IBOutlet UIView *btn2fone;
@property (strong, nonatomic) IBOutlet UIView *btn3fone;
@property (strong, nonatomic) IBOutlet UIView *btn4fone;

@property (nonatomic, weak) IBOutlet UICollectionView *table;
@property (strong, nonatomic) IBOutlet UICollectionView *colectionView;
@property (strong, nonatomic) IBOutlet UIImageView *btn1;
@property (strong, nonatomic) IBOutlet UIImageView *btn2;
@property (strong, nonatomic) IBOutlet UIImageView *btn3;
@property (strong, nonatomic) IBOutlet UIImageView *btn4;
@property (strong, nonatomic) IBOutlet UIPageControl *pageController;

- (void)actHome:(id)sender;
- (void)actLookSee:(id)sender;
- (void)actVideo:(id)sender;
- (void)actTIPS:(id)sender;

- (void)reverseBackroundImageWithNumber:(int)num;
- (void)setImageWithAllButton;
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
    selectedBtn1 = NO;
    selectedBtn2 = NO;
    selectedBtn3 = NO;
    selectedBtn4 = NO;
    [self reverseBackroundImageWithNumber:1];
    
    self.pageController.numberOfPages = 5;
    UITapGestureRecognizer * btn1Recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actHome:)];
    [btn1Recognizer setNumberOfTapsRequired:1];
    [btn1Recognizer setDelegate:self];
    [self.btn1 addGestureRecognizer:btn1Recognizer];
    UITapGestureRecognizer * btn2Recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actLookSee:)];
    [btn2Recognizer setNumberOfTapsRequired:1];
    [btn2Recognizer setDelegate:self];
    [self.btn2 addGestureRecognizer:btn2Recognizer];
    UITapGestureRecognizer * btn3Recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actVideo:)];
    [btn3Recognizer setNumberOfTapsRequired:1];
    [btn3Recognizer setDelegate:self];
    [self.btn3 addGestureRecognizer:btn3Recognizer];
    UITapGestureRecognizer * btn4Recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actTIPS:)];
    [btn4Recognizer setNumberOfTapsRequired:1];
    [btn4Recognizer setDelegate:self];
    [self.btn4 addGestureRecognizer:btn4Recognizer];
//    self.btn1fone.backgroundColor = [UIColor blackColor];
//    self.btn2fone.backgroundColor = [UIColor blackColor];
//    self.btn3fone.backgroundColor = [UIColor blackColor];
//    self.btn4fone.backgroundColor = [UIColor blackColor];
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
    self.btn1Hegth.constant = self.view.frame.size.width / 4;
    self.btn2Hegth.constant = self.btn1Hegth.constant;
    self.btn3Hegth.constant = self.btn1Hegth.constant;
    self.btn4Hegth.constant = self.btn1Hegth.constant;
    self.tabBarWidth.constant = self.view.frame.size.width;
    [self.view updateConstraintsIfNeeded];
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
                ((ImageShow *)cell).image.image = [UIImage imageNamed:@"tips_icon.png"];
                break;
            case 1:
                ((ImageShow *)cell).image.image = [UIImage imageNamed:@"tips_icon.png"];
                break;
            case 2:
                ((ImageShow *)cell).image.image = [UIImage imageNamed:@"tips_icon.png"];
                break;
            case 3:
                ((ImageShow *)cell).image.image = [UIImage imageNamed:@"tips_icon.png"];
                break;
            default:
                ((ImageShow *)cell).image.image = [UIImage imageNamed:@"tips_icon.png"];
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
        self.pageController.currentPage = indexPath.row+1;
    }
}


- (IBAction)actHome:(id)sender {
    [self reverseBackroundImageWithNumber:1];
}

- (IBAction)actLookSee:(id)sender {
    [self reverseBackroundImageWithNumber:2];
}

- (IBAction)actVideo:(id)sender {
    [self reverseBackroundImageWithNumber:3];
}
- (IBAction)actTIPS:(id)sender {
    [self reverseBackroundImageWithNumber:4];
}

- (void)reverseBackroundImageWithNumber:(int)num
{
    switch (num) {
        case 1:
        {
            selectedBtn1 = NO;
            selectedBtn2 = YES;
            selectedBtn3 = YES;
            selectedBtn4 = YES;
            [self setImageWithAllButton];
        }
            break;
        case 2:
        {
            selectedBtn1 = YES;
            selectedBtn2 = NO;
            selectedBtn3 = YES;
            selectedBtn4 = YES;
            [self setImageWithAllButton];
        }
            break;
        case 3:
        {
            selectedBtn1 = YES;
            selectedBtn2 = YES;
            selectedBtn3 = NO;
            selectedBtn4 = YES;
            [self setImageWithAllButton];
        }
            break;
        case 4:
        {
            selectedBtn1 = YES;
            selectedBtn2 = YES;
            selectedBtn3 = YES;
            selectedBtn4 = NO;
            [self setImageWithAllButton];
        }
            break;
    }
}

- (void)setImageWithAllButton
{
    if (selectedBtn1) {
        self.btn1.image = [UIImage imageNamed:@"foto_icon.png"];
        self.btn1fone.backgroundColor = [UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:1.0];
    } else {
        self.btn1fone.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0];
        self.btn1.image = [UIImage imageNamed:@"foto_icon_press.png"];
    }
    if (selectedBtn2) {
        self.btn2.image = [UIImage imageNamed:@"look_icon.png"];
        self.btn2fone.backgroundColor = [UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:1.0];
    } else {
        self.btn2fone.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0];
        self.btn2.image = [UIImage imageNamed:@"look_icon_press.png"];
    }
    if (selectedBtn3) {
        self.btn3.image = [UIImage imageNamed:@"video_camera_icon.png"];
        self.btn3fone.backgroundColor = [UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:1.0];
    } else {
        self.btn3fone.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0];
        self.btn3.image = [UIImage imageNamed:@"video_camera_icon_press.png"];
    }
    if (selectedBtn4) {
        self.btn4.image = [UIImage imageNamed:@"tips_icon.png"];
        self.btn4fone.backgroundColor = [UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:1.0];
    } else {
        self.btn4fone.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0];
        self.btn4.image = [UIImage imageNamed:@"tips_icon_press.png"];
    }
}

@end
