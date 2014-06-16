//
//  BuddyPageViewController.m
//  SMT
//
//  Created by Mac on 5/12/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "BuddyPageViewController.h"
#import "AppDelegate.h"
#import "LocationListCell.h"
#import "BaseLocationViewController.h"
#import "DataLoader.h"
#import "Photo.h"
#import "UIViewController+LoaderCategory.h"
#import "ActivityCell.h"
#import "ImageCell.h"

@interface BuddyPageViewController ()
{
    NSMutableArray *buddySharedLocations;
    NSArray * activityList;
    NSMutableDictionary * activityPhoto;
    NSArray * locationsList;
    NSArray * trophyList;
    NSArray * photosList;
    NSMutableDictionary * cashPhotoList;
    NSMutableDictionary * cashTrophy;
    DataLoader * dataLoader;
}
@property (strong, nonatomic) IBOutlet UICollectionView *collectionTable;

- (void)loadData;

@end

@implementation BuddyPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withBuddy:(Buddy *)buddy
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.buddy = buddy;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        self.navigationBarHeightConstr.constant -= 20;
        self.navigationBarVerticalConstr.constant -=20;
        self.lbNavigationBarTitle.text = [NSString stringWithFormat:@"%@ %@", self.buddy.userFirstName, self.buddy.userSecondName];
    }
    
    dataLoader = [DataLoader instance];
    
    self.lbNavigationBarTitle.text = [NSString stringWithFormat:@"%@ %@", self.buddy.userFirstName, self.buddy.userSecondName];
    
    //NSURL * imgURL = [NSURL URLWithString:self.buddy.]
    
    UINib *cellNib = [UINib nibWithNibName:@"ActivityCell" bundle:[NSBundle mainBundle]];
    [self.table registerNib:cellNib forCellReuseIdentifier:@"ActivityCell"];
    UINib *cellNibPhoto = [UINib nibWithNibName:@"ImageCell" bundle:[NSBundle mainBundle]];
    [self.collectionTable registerNib:cellNibPhoto forCellWithReuseIdentifier:@"imagecell"];
    UINib *headerNib = [UINib nibWithNibName:@"CustomHeader" bundle:[NSBundle mainBundle]];
    [self.collectionTable registerClass:[CustomHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.collectionTable registerNib:headerNib forCellWithReuseIdentifier:@"header"];
    
    //[self.image setBackgroundColor:[UIColor greenColor]];
    [self AddActivityIndicator:[UIColor redColor] forView:self.table];
    //[self AddActivityIndicator:[UIColor redColor] forView:self.collectionTable];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveToLocationDetails:) name:@"LocationListInfoButtonPressed" object:nil];
    
    [self registerCells];
    [self findSharedLocationsList];
    activityPhoto = [NSMutableDictionary new];
    cashPhotoList = [NSMutableDictionary new];
    cashTrophy    = [NSMutableDictionary new];
    self.collectionTable.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self startLoader];
    [self loadData];
    [self.segmentControl setSelectedSegmentIndex:1];
    locationsList = [NSMutableArray arrayWithArray:buddySharedLocations];
    self.table.hidden = NO;
    self.collectionTable.hidden = YES;
    [self.table reloadData];
}


-(void) findSharedLocationsList{
    AppDelegate *appDel = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSMutableArray *sharedLocations = [NSMutableArray arrayWithArray: appDel.listSharedFishLocations];
    [sharedLocations addObjectsFromArray:appDel.listSharedHuntLocations];
    buddySharedLocations = [NSMutableArray new];
    for (Location* loc in sharedLocations){
        if (loc.locUserId == [self.buddy.userID intValue]){
            [buddySharedLocations addObject:loc];
        }
    }  
}

- (void) registerCells{
    [self.table registerNib:[UINib nibWithNibName:@"LocationListCell" bundle:nil] forCellReuseIdentifier:@"LocationListCell"];
}

- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark table delegate metods

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int row = 0;
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:
        {
            row = activityList.count;
        }
            break;
            
        case 1:
        {
            row = locationsList.count;
        }
            break;
            
        case 2:
        {
            row = trophyList.count;
        }
            break;
    }
    if (row == 0) {
        [self endLoader];
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self endLoader];
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:{
            NSDictionary * cb = [activityList objectAtIndex:indexPath.row];
            ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell"];
            if (![[activityPhoto allKeys] containsObject:[NSString stringWithFormat:@"%d",indexPath.row]]) {
                NSURL * url = [NSURL URLWithString:[@"http://sportsmantracker.com/" stringByAppendingString:[[cb objectForKey:@"species"] objectForKey:@"thumbnail"]]];
                UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                [activityPhoto setValue:img forKey:[NSString stringWithFormat:@"%d",indexPath.row]];
            }
            cell.img.image = [activityPhoto objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
            cell.lbName.text = [[cb objectForKey:@"species"] objectForKey:@"name"];
            cell.lbLocation.text = [[cb objectForKey:@"location"] objectForKey:@"name"];
            cell.lbDate.text = [cb objectForKey:@"date"];
            return cell;
            break;
        }
        case 1:{
            LocationListCell *cell = (LocationListCell*) [tableView dequeueReusableCellWithIdentifier:@"LocationListCell" forIndexPath:indexPath];
            [cell processCellInfo:[locationsList objectAtIndex:indexPath.row]];
            return cell;
            break;
        }
        case 2:{
            NSDictionary * trophyDict = [trophyList objectAtIndex:indexPath.row];
            ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell"];
            if (![[cashTrophy allKeys] containsObject:[NSString stringWithFormat:@"%d",indexPath.row]]) {
                int photo_id = [[trophyDict objectForKey:@"photo_id"] intValue];
                Photo * photo = photo_id ? [dataLoader getPhotoWithId:photo_id] : nil;
                NSURL * url = [NSURL URLWithString:photo.thumbnail];
                UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                [cashTrophy setValue:img forKey:[NSString stringWithFormat:@"%d",indexPath.row]];
            }
            cell.img.image = [cashTrophy objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
            cell.lbName.text = @"subSpecies";//[trophyDict objectForKey:@"<#string#>"];
            cell.lbLocation.text = @"";
            cell.lbDate.text = [trophyDict objectForKey:@"time"];
            return cell;
            break;
        }
    }
    
    return nil;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float row = 0;
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:
        {
            row = 60.0f;
        }
            break;
            
        case 1:
        {
            row = 44.0f;
        }
            break;
            
        case 2:
        {
           row = 60.0f;
        }
            break;
            
    }
    
    return row;

}

//- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [NSString stringWithFormat:@"%@ %@", self.buddy.userFirstName, self.buddy.userSecondName];
//}


#pragma mark Collection table delegate metods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return photosList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self endLoader];
    ImageCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imagecell" forIndexPath:indexPath];
    Photo * photo = [photosList objectAtIndex:indexPath.row];
    if (![[cashPhotoList allKeys] containsObject:photo.photoID]) {
        
        Photo * bbb = [dataLoader getPhotoWithId:[photo.photoID intValue]];
       
        UIImage * imgPhoto = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:bbb.fullPhoto]]];
        [cashPhotoList setValue:imgPhoto forKey:photo.photoID];
    }
    cell.foneImage.image = [cashPhotoList objectForKey:photo.photoID];
    return cell;

}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CustomHeader * headerView = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        UILabel * lb = [[UILabel alloc]initWithFrame:headerView.frame];
        lb.text = [[NSString stringWithFormat:@" %@",self.buddy.userFirstName] stringByAppendingString:self.buddy.userSecondName];
        lb.textColor = [UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:159.0/255.0 alpha:1.0];
        [headerView setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1.0]];
        [headerView addSubview:lb];
        return headerView;
    }
    return nil;
}



- (IBAction)actBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)segmentControlStateChanged:(id)sender{
    [self startLoader];
    int selected = self.segmentControl.selectedSegmentIndex;
    switch (selected) {
        case 0: {
            if (!activityList) {
                activityList = [dataLoader getActivitiesWithBuddyID:[self.buddy.userID intValue]];
                self.table.hidden = NO;
                self.collectionTable.hidden = YES;
                [activityPhoto removeAllObjects];
            }
            [self.table reloadData];
        }
            break;
        case 1: {
            locationsList = [NSMutableArray arrayWithArray:buddySharedLocations];
            self.table.hidden = NO;
            self.collectionTable.hidden = YES;
            [self.table reloadData];
        }
            break;
        case 2: {
            if (!activityList) {
                activityList = [dataLoader getActivitiesWithBuddyID:[self.buddy.userID intValue]];
            } //else {
                NSMutableArray * array = [[NSMutableArray alloc]init];
                for (NSDictionary * dic in activityList) {
                    for (NSDictionary * dic2 in [dic objectForKey:@"sightings"]) {
                        if ([[dic2 objectForKey:@"trophy"] integerValue] > 0) {
                            [array addObject:dic2];
                         }
                }
            }
            self.table.hidden = NO;
            self.collectionTable.hidden = YES;
            trophyList = array;
            [self.table reloadData];
        }
            break;
        case 3: {
            [self endLoader];
            if (photosList.firstObject == nil) {
            photosList = [dataLoader getPhotoWithBuddyId:[self.buddy.userID intValue]];
            }
            self.table.hidden = YES;
            self.collectionTable.hidden = NO;
            [self.collectionTable reloadData];
        }
            break;
    }
}





- (void)loadData
{
    activityList = [dataLoader getActivitiesWithBuddyID:[self.buddy.userID intValue]];
    trophyList = [NSMutableArray new];
    //photosList = [dataLoader getPhotoWithBuddyId:[self.buddy.userID intValue]];
    [self endLoader];
}

-(void) moveToLocationDetails: (NSNotification*) notification{
    Location * loc = (Location*) [notification object];
    BaseLocationViewController *updateLocationVC = [BaseLocationViewController new];
    updateLocationVC.location = loc;
    [self.navigationController pushViewController:updateLocationVC animated:YES];
}

@end
