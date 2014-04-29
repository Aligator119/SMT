//
//  HPForgotPasswordViewController.m
//  HunterPredictor
//
//  Created by Admin on 1/6/14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "AppDelegate.h"

@interface ForgotPasswordViewController ()

@property (nonatomic, weak) IBOutlet UIWebView * webView;
@property (nonatomic, strong) UIApplication * app;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * leadingConstr;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * heightConstr;

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.app = [UIApplication sharedApplication];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        self.heightConstr.constant -=20;
        self.leadingConstr.constant -= 20;
    }
    
    NSURL *url = [NSURL URLWithString:PAGE_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:NO];
    if ([self isMovingFromParentViewController]){
        [self.app setNetworkActivityIndicatorVisible:NO];
        [_webView stopLoading];
    }
}

-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma webView delegate


- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.app setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.app setNetworkActivityIndicatorVisible:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.app setNetworkActivityIndicatorVisible:NO];
}



@end
