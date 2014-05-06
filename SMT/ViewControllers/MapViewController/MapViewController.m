//
//  MapViewController.m
//  SMT
//
//  Created by Mac on 4/30/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "MapViewController.h"
#import "LocationSearchViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface MapViewController()
{
    GMSMapView *mapView_;
    CLLocationManager * locationManager;
}

@property (nonatomic, weak) IBOutlet NSLayoutConstraint * navigationBarHeightConstr;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * navigationBarVerticalConstr;

@property (nonatomic, weak) IBOutlet UIView * mapContainerView;

@property (nonatomic, strong) UIImageView * compassView;

@end


@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        self.navigationBarHeightConstr.constant -= 20;
        self.navigationBarVerticalConstr.constant -=20;
    }
    
    [self showMap];
}

- (void) viewDidLayoutSubviews{
    mapView_.frame = self.mapContainerView.bounds;
}

- (void) showMap{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    [self.mapContainerView addSubview:mapView_];
    if (mapView_.myLocation){
        [mapView_ animateToLocation:mapView_.myLocation.coordinate];
    }
    
    
    // Show compass
    //[self showCompass];
    
    //
}

- (void) showCompass{
    self.compassView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    self.compassView.image = [UIImage imageNamed:@"compass"];
    
    [mapView_ addSubview:self.compassView];
}

- (void) createLocationManager{
    locationManager = [CLLocationManager new];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.headingFilter = 1;
    locationManager.delegate = self;
    [locationManager startUpdatingHeading];
}

- (IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)openMapTypeMenu:(id)sender{
    
}

- (IBAction)goToCurrentLocation:(id)sender{
    CLLocation * location = mapView_.myLocation;
    if (location){
        [mapView_ animateToLocation: location.coordinate ];
    }else{
        NSString *msg = @"Error obtaining location";
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

- (IBAction)goToLocationList:(id)sender{
    LocationSearchViewController * locationSearchVC = [LocationSearchViewController new];
    locationSearchVC.parent = self;
    [self.navigationController pushViewController:locationSearchVC animated:YES];
}

-(void) locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    float heading = newHeading.magneticHeading;
    float headingDegrees = heading * M_PI/180;
    self.compassView.transform = CGAffineTransformMakeRotation(headingDegrees);
}

- (void) moveToLocation: (CLLocationCoordinate2D) loc{
    [mapView_ animateToLocation:loc];
}




@end
