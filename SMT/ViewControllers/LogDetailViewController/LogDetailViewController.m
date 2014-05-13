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
    NSDictionary * specieDictionary;
}
@end

@implementation LogDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andProperty:(NSDictionary *)dict
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        specieDictionary = dict;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.list = [specieDictionary objectForKey:@"specie"];
    // Do any additional setup after loading the view from its nib.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        self.navigationBarHeightConstr.constant -= 20;
        self.navigationBarVerticalConstr.constant -=20;
    }
    UINib *cellNib1 = [UINib nibWithNibName:@"LogDetailCell" bundle:[NSBundle mainBundle]];
    [self.table registerNib:cellNib1 forCellReuseIdentifier:@"LogDetailCell"];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Species * specie = [self.list objectAtIndex:section];
    return specie.harvested;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LogDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LogDetailCell"];
    
    if (!cell) {
        cell = [[LogDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LogDetailCell"];
    }
    NSString * str = [[@"Harvested(" stringByAppendingString:[NSString stringWithFormat:@"%d",indexPath.row + 1]] stringByAppendingString:@")"];
    cell.lbText.text = str;
    cell.lbDetailText.text = @"Add Detail";
    return cell;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return ((Species *)[self.list objectAtIndex:section]).name;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * str = [[@"Harvested(" stringByAppendingString:[NSString stringWithFormat:@"%d",indexPath.row + 1]] stringByAppendingString:@")"];
    NSDictionary * buf = [[NSDictionary alloc]initWithObjectsAndKeys:str, @"name", [specieDictionary objectForKey:@"startTime"], @"startTime", [specieDictionary objectForKey:@"endTime"], @"endTime", nil];
    LogDetail2ViewController * ld2vc = [[LogDetail2ViewController alloc]initWithNibName:@"LogDetail2ViewController" bundle:nil andData:buf];
    [self.navigationController pushViewController:ld2vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actClose:(id)sender {
    NewLog1ViewController * nlvc = [[NewLog1ViewController alloc] initWithNibName:@"NewLog1ViewController" bundle:nil];
    [self.navigationController pushViewController:nlvc animated:YES];
}
@end
