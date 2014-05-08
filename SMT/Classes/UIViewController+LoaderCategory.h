//
//  UIViewController+LoaderCategory.h
//  HunterPredictor
//
//  Created by Vasya on 07.02.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ActiveLOaderTag 102

@interface UIViewController (LoaderCategory)

@property(strong, nonatomic) UIActivityIndicatorView  * activityIndicat;

- (void)AddActivityIndicator:(UIColor*)_colorIndicatar forView:(UIView*)view;
- (void)startLoader;
- (void)endLoader;
- (void)startInternatIndicator;
- (void)stopInternatIndicator;
- (void)replaceActivityIndicatorOnScreenRotate:(UIView*)view;
- (BOOL) getIsAnimating;
-(void) AddActivityIndicator:(UIColor *)_colorIndicatar forView:(UIView*)view withBackground: (UIColor*) bgColor;

@end
