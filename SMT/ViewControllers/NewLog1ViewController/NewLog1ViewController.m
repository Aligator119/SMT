//
//  NewLog1ViewController.m
//  SMT
//
//  Created by Mac on 5/8/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "NewLog1ViewController.h"
#import "LogHistoryViewController.h"
#import "DataLoader.h"
#import "AppDelegate.h"
#import "Species.h"
#import "NewLog2ViewController.h"

@interface NewLog1ViewController ()
{
    AppDelegate * appDelegate;
}
- (IBAction)actButtonBack:(UIButton *)sender;
- (IBAction)actButtonHistory:(UIButton *)sender;
@end

@implementation NewLog1ViewController

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
        self.navigationBarHeightConstr.constant -= 20;
        self.navigationBarVerticalConstr.constant -=20;
    }

    
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    DataLoader *loader = [[DataLoader alloc]init];
    if ([appDelegate.speciesList firstObject] == nil) {
        [loader getAllSpecies];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return appDelegate.speciesList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    Species * spec = [appDelegate.speciesList objectAtIndex:indexPath.row];
    cell.imageView.image = spec.thumbnail;
    cell.textLabel.text = spec.name;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Select Species";
    }
    return @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewLog2ViewController * nlvc = [[NewLog2ViewController alloc]initWithNibName:@"NewLog2ViewController" bundle:nil andSpecies: [appDelegate.speciesList objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:nlvc animated:YES];
}


- (IBAction)actButtonHistory:(UIButton *)sender
{
    LogHistoryViewController * lhvc = [[LogHistoryViewController alloc]initWithNibName:@"LogHistoryViewController" bundle:nil];
    [self.navigationController pushViewController:lhvc animated:YES];
}

- (IBAction)actButtonBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
