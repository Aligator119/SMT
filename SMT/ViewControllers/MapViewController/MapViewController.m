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
#import "AppDelegate.h"
#import "DataLoader.h"
#import "LocationListViewController.h"
#import "SMTMarker.h"
#import "Location.h"

@interface MapViewController()
{
    GMSMapView *mapView_;
    CLLocationManager * locationManager;
    BOOL firstLocationUpdate_;
    AppDelegate * appDel;
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
    
    appDel = (AppDelegate*) [UIApplication sharedApplication].delegate;
    
    [self showMap];
    [self createLocationManager];
}

- (void) viewDidLayoutSubviews{
    mapView_.frame = self.mapContainerView.bounds;
}

- (void) showMap{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    [mapView_ addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:NULL];
    
    mapView_.myLocationEnabled = YES;
    [self.mapContainerView addSubview:mapView_];
    
    // Show compass
    //[self showCompass];
    
    [self setAllLocationMarkers];

}

- (void) dealloc{
    [mapView_ removeObserver:self forKeyPath:@"myLocation" context:NULL];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (!firstLocationUpdate_){
        firstLocationUpdate_ = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        mapView_.camera = [GMSCameraPosition cameraWithTarget:location.coordinate zoom:6];
    }
}

- (void) showCompass{
    self.compassView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    self.compassView.image = [UIImage imageNamed:@"compass"];
    
    [mapView_ addSubview:self.compassView];
}

- (void) setAllLocationMarkers{
    [mapView_ clear];
    
    for (Location* loc in appDel.listLocations){
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(loc.locLatitude, loc.locLongitude);
        SMTMarker * marker = [SMTMarker markerWithPosition:coord];
        marker.title = loc.locName;
        marker.location = loc;
        marker.map = mapView_;
    }
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

- (IBAction)goToLocationSearch:(id)sender{
    LocationSearchViewController * locationSearchVC = [LocationSearchViewController new];
    locationSearchVC.parent = self;
    [self.navigationController pushViewController:locationSearchVC animated:YES];
}

- (IBAction)goToLocationList:(id)sender{
    if(appDel.listLocations == nil || appDel.listLocations.count == 0){
        
        DataLoader * dataLoader = [DataLoader instance];
        
        dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(newQueue, ^(){
            [dataLoader getLocationsAssociatedWithUser];
            
            dispatch_async(dispatch_get_main_queue(),^(){
                
                if(dataLoader.isCorrectRezult){
                    LocationListViewController * locationListVC = [LocationListViewController new];
                    [self.navigationController pushViewController:locationListVC animated:YES];
                }
            });
        });
    } else {
        LocationListViewController * locationListVC = [LocationListViewController new];
        [self.navigationController pushViewController:locationListVC animated:YES];
       
    }

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
