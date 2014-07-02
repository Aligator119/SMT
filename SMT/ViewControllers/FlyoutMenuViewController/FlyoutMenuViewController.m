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
#import "TipsCell.h"
#import "CreateTipsCell.h"
#import "SpeciesCell.h"
#import "TIPS.h"



#define USER_DATA @"userdata"

#define COLECTION_SHOW 5555
#define COLECTION_DATA 1234

@interface FlyoutMenuViewController ()
{
    DataLoader * dataLoader;
    AppDelegate * appDelegate;
    BOOL selectedBtn1;
    BOOL selectedBtn2;
    BOOL selectedBtn3;
    BOOL selectedBtn4;
    NSMutableArray * tipsList;
    NSMutableArray * photoList;
    
    NSArray * subSpecies;
    Species * selectSpecie;
    Species * selectSubSpecie;
    NSMutableDictionary * cashedPhoto;
    float width;
    int activeSegment;
    NSIndexPath * index;
}
@property (strong, nonatomic) IBOutlet UIView *forTabBar;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topBarHiegthConstrainsSubView;
@property (strong, nonatomic) IBOutlet UITableView *tableSelect;
@property (strong, nonatomic) IBOutlet UIView *subView;

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
- (void)actSelectSpecie;
- (void)actSelectSubSpecie;

- (void)downloadTIPS;
- (void)downloadPhotos;

- (IBAction)actCloseSubView:(id)sender;
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
        self.topBarHiegthConstrainsSubView.constant -=20;
    }
    [self.colectionView registerNib:[UINib nibWithNibName:@"TipsCell" bundle:nil] forCellWithReuseIdentifier:@"TipsCell"];
    [self.colectionView registerNib:[UINib nibWithNibName:@"CreateTipsCell" bundle:nil] forCellWithReuseIdentifier:@"CreateTipsCell"];
    [self.colectionView registerNib:[UINib nibWithNibName:@"ImageShow" bundle:nil] forCellWithReuseIdentifier:@"ImageShow"];
    
    
    [self.table registerNib:[UINib nibWithNibName:@"ImageShow" bundle:nil] forCellWithReuseIdentifier:@"ImageShow"];
    UINib *cellNib = [UINib nibWithNibName:@"SpeciesCell" bundle:[NSBundle mainBundle]];
    [self.tableSelect registerNib:cellNib forCellReuseIdentifier:@"SpeciesCell"];

    self.table.tag = COLECTION_SHOW;
    self.colectionView.tag = COLECTION_DATA;
    
    dataLoader = [DataLoader instance];
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    activeSegment = 1;
    cashedPhoto = [[NSMutableDictionary alloc]init];
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
    
    [self AddActivityIndicator:[UIColor redColor] forView:self.view];
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
    width = self.view.frame.size.width;
    [self downloadPhotos];
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    int num;
    if (collectionView.tag == COLECTION_DATA) {
        if (!selectedBtn1) {
            num = photoList.count;
        } else if (!selectedBtn2) {
            num = 1;
        } else if (!selectedBtn3) {
            num = 1;
        } else if (!selectedBtn4) {
            num = tipsList.count;
        }
    } else {
        num = 5;
    }
    return num;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell;
    if (collectionView.tag == COLECTION_DATA) {
        switch (activeSegment) {
            case 1:
            {
                if (photoList.count) {
                Photo * photo = [photoList objectAtIndex:indexPath.row];
                if (![[cashedPhoto allKeys] containsObject:photo.photoID]) {
                    UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photo.fullPhoto]]];
                    [cashedPhoto addEntriesFromDictionary:@{photo.photoID: img}];
                }
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageShow" forIndexPath:indexPath];
                ((ImageShow *)cell).image.image = [cashedPhoto objectForKey:photo.photoID];
                }
            }
                break;
            case 2:
            {
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TipsCell" forIndexPath:indexPath];
            }
                break;
            case 3:
            {
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TipsCell" forIndexPath:indexPath];
            }
                break;
            case 4:
            {
                if ([[tipsList objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]) {
                    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CreateTipsCell" forIndexPath:indexPath];
                    [((CreateTipsCell *)cell).btnSelectSpecie addTarget:self action:@selector(actSelectSpecie) forControlEvents:UIControlEventTouchUpInside];
                    [((CreateTipsCell *)cell).btnSelectSubSpecie addTarget:self action:@selector(actSelectSubSpecie) forControlEvents:UIControlEventTouchUpInside];
                    [((CreateTipsCell *)cell).tfText setDelegate:self];
                    index = indexPath;
                } else {
                    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TipsCell" forIndexPath:indexPath];
                    //add data to bottom colectionView
                    ((TipsCell *)cell).lbName.text = @"My Name";
                    ((TipsCell *)cell).lbDate.text = @"10.10.2010";
                    ((TipsCell *)cell).lbText.text = @"qwertyuiop[]asdfghjkl;'zxcvbbnm,./qwertyuiop[]assdffgghjjkll;;;'''zxccvvbbnnmm,,../qwerty";
                }
            }
                break;
        }
        
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


- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    if (collectionView.tag == COLECTION_DATA) {
        if (!selectedBtn1) {
             size = CGSizeMake(self.colectionView.frame.size.width-10, self.colectionView.frame.size.height/1.5);
        } else if (!selectedBtn2) {
            //num = 1;
        } else if (!selectedBtn3) {
            //num = 1;
        } else if (!selectedBtn4) {
             size = CGSizeMake(self.colectionView.frame.size.width-20, self.colectionView.frame.size.height);
        }
    } else {
        size = CGSizeMake(self.table.frame.size.width, self.table.frame.size.height);
    }
    return size;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (collectionView.tag == COLECTION_DATA) {
        // action for bottom colectionView
    }
    
    if (collectionView.tag == COLECTION_SHOW) {
        // action for top colectionView
        CGPoint point = collectionView.contentOffset;
        point.x += width+1;
        if (point.x >= collectionView.contentSize.width) {
            point.x = 0.0;
        }
        [UIView animateWithDuration:0.7f animations:^{
            collectionView.contentOffset = point;
        }];
        self.pageController.currentPage = indexPath.row+1;
    }
}


- (void)actHome:(id)sender {
    [self reverseBackroundImageWithNumber:1];
}

- (void)actLookSee:(id)sender {
    [self reverseBackroundImageWithNumber:2];
}

- (void)actVideo:(id)sender {
    [self reverseBackroundImageWithNumber:3];
}
- (void)actTIPS:(id)sender {
    [self reverseBackroundImageWithNumber:4];
}

- (void)reverseBackroundImageWithNumber:(int)num
{
    activeSegment = num;
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
            if (tipsList.count < 2) {
                [self downloadTIPS];
            }
        }
            break;
    }
    [self.colectionView reloadData];
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
#pragma mark table delegates metods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.tableSelect.tag == 1) {
        return appDelegate.speciesList.count;
    } else {
        return subSpecies.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SpeciesCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SpeciesCell"];
    
    if (tableView.tag == 1) {
        [cell setSpecie:[appDelegate.speciesList objectAtIndex:indexPath.row]];
    } else {
        [cell setSpecie:[subSpecies objectAtIndex:indexPath.row]];
    }
    //cell.contentView.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * buf = [self.colectionView cellForItemAtIndexPath:index];
    if (tableView.tag == 1) {
        selectSpecie = [appDelegate.speciesList objectAtIndex:indexPath.row];
        [((CreateTipsCell *)buf).btnSelectSpecie setTitle:selectSpecie.name forState:UIControlStateNormal];
        [self.subView removeFromSuperview];
    } else {
        selectSubSpecie = [subSpecies objectAtIndex:indexPath.row];
        [((CreateTipsCell *)buf).btnSelectSubSpecie setTitle:selectSubSpecie.name forState:UIControlStateNormal];
        [self.subView removeFromSuperview];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark Select Species and SubSpecies

- (void)actSelectSpecie
{
    self.tableSelect.tag = 1;
    [self.tableSelect reloadData];
    [self.view addSubview:self.subView];
}

- (void)actSelectSubSpecie
{
    if (!selectSpecie) {
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"No select Specie" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
    } else {
        [self startLoader];
        self.tableSelect.tag = 2;
        dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(newQueue, ^(){
            subSpecies = [[NSArray alloc]initWithArray:[dataLoader getSubSpecies:[selectSpecie.specId intValue]]] ;
        
            dispatch_async(dispatch_get_main_queue(), ^(){
            
                if(!dataLoader.isCorrectRezult) {
                    NSLog(@"Error download sybSpecie");
                    [self endLoader];
                } else {
                    [self.tableSelect reloadData];
                    [self.view addSubview:self.subView];
                    [self endLoader];
                }
            });
       });
    }
}

#pragma mark UITextViewDelegats metods

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self startLoader];
    NSLog(@"send tips");
    // add send tips to servrs
    int subID;
    UICollectionViewCell * buf = [self.colectionView cellForItemAtIndexPath:index];
    if (((CreateTipsCell *)buf).tfText.text && selectSpecie) {
        if (!selectSubSpecie) {
            subID = 0;
        } else {
            subID = [selectSubSpecie.specId intValue];
        }
        dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(newQueue, ^(){
            [dataLoader createNewTipsWithSpecieID:[selectSpecie.specId intValue] tip:((CreateTipsCell *)buf).tfText.text subSpecieID:subID andUserID:appDelegate.user.userID];
        
            dispatch_async(dispatch_get_main_queue(), ^(){
            
                if(!dataLoader.isCorrectRezult) {
                    NSLog(@"Error create tips");
                    [self endLoader];
                } else {
                    //[self.colectionView reloadData];
                    NSLog(@"YES");
                    [self endLoader];
                    [self downloadTIPS];
                }
           });
        });
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


#pragma mark Download data

- (void)downloadTIPS
{
    [self startLoader];
    tipsList = [[NSMutableArray alloc]initWithObjects:@"new tips", nil];
//    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(newQueue, ^(){
//        NSArray * array = [dataLoader getTipsWithUserId:1] ;
//        
//        dispatch_async(dispatch_get_main_queue(), ^(){
//            
//            if(!dataLoader.isCorrectRezult) {
//                NSLog(@"Error download sybSpecie");
//                [self endLoader];
//            } else {
//                tipsList = [[NSMutableArray alloc]initWithObjects:@"new tips", nil];
//                [tipsList addObjectsFromArray:array];
//                [self.colectionView reloadData];
//                [self endLoader];
//            }
//        });
//    });
    [self endLoader];
}


- (void)downloadPhotos
{
    [self startLoader];
    photoList = [[NSMutableArray alloc]init];
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        photoList = [[NSMutableArray alloc]initWithArray:[dataLoader getPhoto]];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            if(!dataLoader.isCorrectRezult) {
                NSLog(@"Error download sybSpecie");
                [self endLoader];
            } else {
                [self.colectionView reloadData];
                [self endLoader];
            }
        });
    });
}

- (IBAction)actCloseSubView:(id)sender {
    [self.subView removeFromSuperview];
}

@end
