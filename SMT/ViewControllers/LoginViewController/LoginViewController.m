//
//  LoginViewController.m
//  SMT
//
//  Created by Mac on 4/29/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize session = _session;

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
    
    [FBSession openActiveSessionWithPublishPermissions: @[@"user_friends",@"basic_info",@"read_friendlists", @"user_activities",@"user_hometown",@"email",@"user_birthday",@"installed",@"user_about_me",@"public_profile",@"user_location",@"user_likes",@"user_status",@"publish_stream",@"publish_actions"] defaultAudience:(FBSessionDefaultAudienceEveryone)  allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        
        if ((status != FBSessionStateClosed) || (status != FBSessionStateClosedLoginFailed)) {
            NSLog(@"is login!!!!!!!!!!!!!!!!!!!!!!!");
            
        }
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
