//
//  PredictionViewController.m
//  SMT
//
//  Created by Mac on 5/14/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "PredictionViewController.h"

@interface PredictionViewController ()

- (void) downloadHunter:(id)sender;
- (void) downloadFish:(id)sender;
@end

@implementation PredictionViewController

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

    UITapGestureRecognizer * huntRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downloadHunter:)];
    [huntRecognizer setNumberOfTapsRequired:1];
    [huntRecognizer setDelegate:self];
    [self.huntPredictor addGestureRecognizer:huntRecognizer];
    
    UITapGestureRecognizer * fishRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downloadFish:)];
    [fishRecognizer setNumberOfTapsRequired:1];
    [fishRecognizer setDelegate:self];
    [self.fishPredictor addGestureRecognizer:fishRecognizer];
    
    self.screenName = @"Prediction screen";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) downloadHunter:(id)sender
{
    NSURL * url = [NSURL URLWithString:@"https://itunes.apple.com/ru/app/hunt-predictor-hunting-times/id645518545?mt=8"];
    
    if (![[UIApplication sharedApplication] openURL:url])
        
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
}

- (void) downloadFish:(id)sender
{
    NSURL * url = [NSURL URLWithString:@"https://itunes.apple.com/us/app/fish-predictor-fishing-times/id721943983?mt=8"];
    
    if (![[UIApplication sharedApplication] openURL:url])
        
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
}

- (IBAction)actBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
