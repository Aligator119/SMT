//
//  BuddyPageViewController.m
//  SMT
//
//  Created by Mac on 5/12/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "BuddyPageViewController.h"

@interface BuddyPageViewController ()
{
    NSArray * activityList;
    NSArray * locationsList;
    NSArray * trophyList;
    NSArray * photosList;
}

- (void) actChangeSelect:(id)sender;

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
    
    
    [self.segmentControl addTarget:self action:@selector(actChangeSelect:) forControlEvents:UIControlEventValueChanged];
    
    //NSURL * imgURL = [NSURL URLWithString:self.buddy.]
    
    [self.image setBackgroundColor:[UIColor greenColor]];
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
            
        case 3:
        {
            row = photosList.count;
        }
            break;
    }
    
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    
    return cell;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"%@ %@", self.buddy.userFirstName, self.buddy.userSecondName];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) actChangeSelect:(id)sender
{
    NSLog(@"%d",self.segmentControl.selectedSegmentIndex);
}

@end
