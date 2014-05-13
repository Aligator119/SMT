//
//  BuddyPageViewController.m
//  SMT
//
//  Created by Mac on 5/12/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "BuddyPageViewController.h"

@interface BuddyPageViewController ()

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
        self.lbNavigationBarTitle.text = self.buddy.userName;
    }
    
    self.lbNavigationBarTitle.text = self.buddy.userFirstName;
    
    
    [self.segmentControl addTarget:self action:@selector(actChangeSelect:) forControlEvents:UIControlEventValueChanged];
    
    [self.image setBackgroundColor:[UIColor greenColor]];
}

#pragma mark table delegate metods

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
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
    return self.buddy.userFirstName;
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
