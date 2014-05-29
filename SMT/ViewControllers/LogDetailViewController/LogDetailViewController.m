//
//  LogDetailViewController.m
//  SMT
//
//  Created by Mac on 5/13/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "LogDetailViewController.h"
#import "NewLog1ViewController.h"
#import "LogDetail2ViewController.h"
#import "Species.h"

@interface LogDetailViewController ()
{
    NSDictionary * enteredData;
    Activity * activity;
    NSArray * activityDetails;
    NSMutableArray * displayedCell;
}


- (void) addNewCell:(UIButton *) sender;
@end

@implementation LogDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andProperty:(NSDictionary *)dict
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        enteredData = dict;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.list = [enteredData objectForKey:@"specie"];
    activity = [enteredData objectForKey:@"activity"];
    activityDetails = [enteredData objectForKey:@"activityDetails"];
    displayedCell = [[NSMutableArray alloc]init];
    for (int i=0;i<=[self.list count];i++) {
        [displayedCell addObject:@(1)];
    }
    // Do any additional setup after loading the view from its nib.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        self.navigationBarHeightConstr.constant -= 20;
        self.navigationBarVerticalConstr.constant -=20;
    }
    UINib *cellNib1 = [UINib nibWithNibName:@"LogDetailCell" bundle:[NSBundle mainBundle]];
    [self.table registerNib:cellNib1 forCellReuseIdentifier:@"LogDetailCell"];
    UINib *cellNib2 = [UINib nibWithNibName:@"AddCell" bundle:[NSBundle mainBundle]];
    [self.table registerNib:cellNib2 forCellReuseIdentifier:@"AddCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[displayedCell objectAtIndex:section] integerValue] > ((ActivityDetails *)[activityDetails objectAtIndex:section]).seen ? ((ActivityDetails *)[activityDetails objectAtIndex:section]).seen : [[displayedCell objectAtIndex:section] integerValue];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    NSInteger numberOfCell = [[displayedCell objectAtIndex:indexPath.section] integerValue];
    ActivityDetails * details = [activityDetails objectAtIndex:indexPath.section];
    
    if (numberOfCell <= details.seen && numberOfCell-1 == indexPath.row) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AddCell"];
        ((AddCell *)cell).btnAdd.tag = indexPath.section;
        [((AddCell *)cell).btnAdd addTarget:self action:@selector(addNewCell:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        
            cell = [tableView dequeueReusableCellWithIdentifier:@"LogDetailCell"];
        
            NSString * str = [[@"Harvested(" stringByAppendingString:[NSString stringWithFormat:@"%d",indexPath.row + 1]] stringByAppendingString:@")"];
            ((LogDetailCell *)cell).lbText.text = str;
            ((LogDetailCell *)cell).lbDetailText.text = @"Add Detail";
        
     if (numberOfCell > details.harvested && indexPath.row >= details.harvested)   {
            cell = [tableView dequeueReusableCellWithIdentifier:@"LogDetailCell"];
        
            NSString * str = [[@"Seen(" stringByAppendingString:[NSString stringWithFormat:@"%d",indexPath.row + 1]] stringByAppendingString:@")"];
            ((LogDetailCell *)cell).lbText.text = str;
            ((LogDetailCell *)cell).lbDetailText.text = @"Add Detail";
            }
    }
    
    
    return cell;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return ((Species *)[self.list objectAtIndex:section]).name;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * str = [[@"Harvested(" stringByAppendingString:[NSString stringWithFormat:@"%d",indexPath.row + 1]] stringByAppendingString:@")"];
    NSDictionary * buf = [[NSDictionary alloc]initWithObjectsAndKeys:str, @"name", [enteredData objectForKey:@"startTime"], @"startTime", [enteredData objectForKey:@"endTime"], @"endTime", nil];
    LogDetail2ViewController * ld2vc = [[LogDetail2ViewController alloc]initWithNibName:@"LogDetail2ViewController" bundle:nil andData:buf];
    [self.navigationController pushViewController:ld2vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addNewCell:(UIButton *)sender
{
    NSInteger num = [[displayedCell objectAtIndex:sender.tag] integerValue];
    //if (num<((ActivityDetails *)[activityDetails objectAtIndex:sender.tag]).seen) {
        num++;
    //}
    [displayedCell replaceObjectAtIndex:sender.tag withObject:@(num)];
    [self.table reloadData];
}

- (IBAction)actClose:(id)sender {
    NewLog1ViewController * nlvc = [[NewLog1ViewController alloc] initWithNibName:@"NewLog1ViewController" bundle:nil];
    [self.navigationController pushViewController:nlvc animated:YES];
}
@end
