//
//  LogAnActivityViewController.m
//  SMT
//
//  Created by Mac on 5/7/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "LogAnActivityViewController.h"
#import "NewLog1ViewController.h"
#import "LogHistoryViewController.h"

@interface LogAnActivityViewController ()



- (IBAction)actButtonBack:(UIButton *)sender;
- (IBAction)actButtonHistory:(UIButton *)sender;
@end

@implementation LogAnActivityViewController

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
    // Do any additional setup after loading the view from its nib.
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        self.navigationBarHeightConstr.constant -= 20;
        self.navigationBarVerticalConstr.constant -=20;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actButtonBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actButtonHistory:(UIButton *)sender
{
    LogHistoryViewController * lhvc = [[LogHistoryViewController alloc]initWithNibName:@"LogHistoryViewController" bundle:nil];
    [self.navigationController pushViewController:lhvc animated:YES];
}



- (IBAction)actPhotoLog:(id)sender {
}

- (IBAction)actTraditionalLog:(id)sender {
    NewLog1ViewController * nlvc = [[NewLog1ViewController alloc]initWithNibName:@"NewLog1ViewController" bundle:nil];
    [self.navigationController pushViewController:nlvc animated:YES];
}
@end
