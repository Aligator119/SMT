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
#import "UIViewController+LoaderCategory.h"

@interface NewLog1ViewController ()
{
    AppDelegate * appDelegate;
    DataLoader *loader;
}
- (IBAction)actButtonBack:(UIButton *)sender;
- (IBAction)actButtonHistory:(UIButton *)sender;
- (void)actDownloadData;
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

    self.navigationController.navigationBar.hidden = YES;
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    loader = [[DataLoader alloc]init];
    [self AddActivityIndicator:[UIColor grayColor] forView:self.view];
    
    UINib *cellNib = [UINib nibWithNibName:@"SpeciesCell" bundle:[NSBundle mainBundle]];
    [self.table registerNib:cellNib forCellReuseIdentifier:@"SpeciesCell"];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    
    [self actDownloadData];
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
    SpeciesCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SpeciesCell"];
        
    [cell setSpecie:[appDelegate.speciesList objectAtIndex:indexPath.row]];
    
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (void) actDownloadData
{
    if ([appDelegate.speciesList firstObject] == nil) {
    [self startLoader];
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        
       [loader getAllSpecies];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            if(!loader.isCorrectRezult) {
                NSLog(@"Error download sybSpecie");
                [self endLoader];
            } else {
                [self.table reloadData];
                [self endLoader];
            }
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            {
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            }
        });
    });
    }
}


@end
