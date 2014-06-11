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

@interface BuddyPageViewController ()
{
    NSMutableArray *buddySharedLocations;
    NSMutableArray *globalDataArray;
}

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
    
    self.lbNavigationBarTitle.text = [NSString stringWithFormat:@"%@ %@", self.buddy.userFirstName, self.buddy.userSecondName];
    
    //NSURL * imgURL = [NSURL URLWithString:self.buddy.]
    
    [self.image setBackgroundColor:[UIColor greenColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveToLocationDetails:) name:@"LocationListInfoButtonPressed" object:nil];
    
    [self registerCells];
    [self findSharedLocationsList];
    
    globalDataArray = [NSMutableArray new];
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
    return globalDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.segmentControl.selectedSegmentIndex) {
        case 1:{
            LocationListCell *cell = (LocationListCell*) [tableView dequeueReusableCellWithIdentifier:@"LocationListCell" forIndexPath:indexPath];
            [cell processCellInfo:[globalDataArray objectAtIndex:indexPath.row]];
            return cell;
            break;
        }
            
        default:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
            }
            
            cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
            return cell;
            break;
        }
    }
    
    
    return nil;
    
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"%@ %@", self.buddy.userFirstName, self.buddy.userSecondName];
}

- (IBAction)actBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)segmentControlStateChanged:(id)sender{
    int selected = self.segmentControl.selectedSegmentIndex;
    switch (selected) {
        case 1:
            globalDataArray = [NSMutableArray arrayWithArray:buddySharedLocations];
            [self.table reloadData];
            break;
            
        default:
            break;
    }
}

-(void) moveToLocationDetails: (NSNotification*) notification{
    Location * loc = (Location*) [notification object];
    BaseLocationViewController *updateLocationVC = [BaseLocationViewController new];
    updateLocationVC.location = loc;
    [self.navigationController pushViewController:updateLocationVC animated:YES];
}

@end
