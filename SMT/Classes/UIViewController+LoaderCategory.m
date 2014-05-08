//
//  UIViewController+LoaderCategory.m
//  HunterPredictor
//
//  Created by Vasya on 07.02.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import "UIViewController+LoaderCategory.h"

@implementation UIViewController (LoaderCategory)
@dynamic activityIndicat;

- (UIActivityIndicatorView*)activityIndicat{
    return [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

- (void)AddActivityIndicator:(UIColor *)_colorIndicatar forView:(UIView*)view{
    /*self.activityIndicat = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];*/
    
    UIActivityIndicatorView * a = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:a];
    
    CGRect screenRect = view.bounds; //[[UIScreen mainScreen] bounds];
    a.center = CGPointMake(screenRect.size.width/2,screenRect.size.height/2);
    
    a.color = _colorIndicatar;
    a.hidesWhenStopped = YES;
    a.tag = ActiveLOaderTag;
}

-(void) AddActivityIndicator:(UIColor *)_colorIndicatar forView:(UIView*)view withBackground: (UIColor*) bgColor{
    UIActivityIndicatorView * a = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:a];
    
    
    a.backgroundColor = bgColor;
    a.layer.cornerRadius = 18;
    
    CGRect screenRect = view.bounds; //[[UIScreen mainScreen] bounds];
    a.center = CGPointMake(screenRect.size.width/2,screenRect.size.height/2);
    
    a.color = _colorIndicatar;
    a.hidesWhenStopped = YES;
    a.tag = ActiveLOaderTag;
}

- (void)startLoader{
    UIActivityIndicatorView * a = (UIActivityIndicatorView* )[self.view viewWithTag:ActiveLOaderTag];
    [a startAnimating];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}

- (void)endLoader{
    if([[UIApplication sharedApplication] isIgnoringInteractionEvents])
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    UIActivityIndicatorView * a = (UIActivityIndicatorView* )[self.view viewWithTag:ActiveLOaderTag];
    [a stopAnimating];
}

- (void)startInternatIndicator{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}

- (void)stopInternatIndicator{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

- (void)replaceActivityIndicatorOnScreenRotate:(UIView*)view{
    UIActivityIndicatorView * a = (UIActivityIndicatorView* )[self.view viewWithTag:ActiveLOaderTag];
    CGRect screenRect = view.bounds; //[[UIScreen mainScreen] bounds];
    a.center = CGPointMake(screenRect.size.width/2,screenRect.size.height/2);
}

-(BOOL) getIsAnimating{
    UIActivityIndicatorView * a = (UIActivityIndicatorView* )[self.view viewWithTag:ActiveLOaderTag];
    return a.isAnimating;
}

@end
