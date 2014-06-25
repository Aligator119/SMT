//
//  MapViewController.h
//  SMT
//
//  Created by Mac on 4/30/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "NewLog1ViewController.h"
#import "CameraViewController.h"
#import "FlyoutMenuViewController.h"
#import "CustomTabBar.h"

@interface MapViewController : UIViewController <GMSMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate>
{
    BOOL isPresent;
}
@property (nonatomic) BOOL isTabBar;
@property (nonatomic) NSInteger mapType;
@property (strong, nonatomic) IBOutlet CustomTabBar *tabBar;
- (void) moveToLocation: (CLLocationCoordinate2D) loc;
-(void) setIsPresent:(BOOL)present;

@end
