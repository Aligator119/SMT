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
#import "UIViewController+LoaderCategory.h"
#import "BaseLocationViewController.h"

@interface MapViewController()
{
    GMSMapView *mapView_;
    CLLocationManager * locationManager;
    BOOL firstLocationUpdate_;
    AppDelegate * appDel;
    DataLoader *loader;
    NSArray * listLocations;
}

@property (nonatomic, weak) IBOutlet NSLayoutConstraint * navigationBarHeightConstr;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * navigationBarVerticalConstr;

@property (nonatomic, weak) IBOutlet UIView * mapContainerView;

@property (nonatomic, strong) UIImageView * compassView;
@property (nonatomic, strong) CLGeocoder *geocoder;


@end


@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self AddActivityIndicator:[UIColor whiteColor] forView:self.view];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        self.navigationBarHeightConstr.constant -= 20;
        self.navigationBarVerticalConstr.constant -=20;
    }
    
    appDel = (AppDelegate*) [UIApplication sharedApplication].delegate;
    loader = [DataLoader instance];
    
    [self showMap];
    [self createLocationManager];
    
}

- (void) viewDidLayoutSubviews{
    mapView_.frame = self.mapContainerView.bounds;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.mapType == typeFishing){
        listLocations = [NSArray arrayWithArray:appDel.listFishLocations];
    } else if (self.mapType == typeHunting){
        listLocations = [NSArray arrayWithArray:appDel.listHuntLocations];
    }
    [self setAllLocationMarkers];
}

- (void) showMap{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    [mapView_ addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:NULL];
    
    mapView_.myLocationEnabled = YES;
    mapView_.delegate = self;
    mapView_.mapType = kGMSTypeHybrid;
    [self.mapContainerView addSubview:mapView_];
    
    // Show compass
    //[self showCompass];
    
    

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
    
    for (Location* loc in listLocations){
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
                    locationListVC.mapType = self.mapType;
                    [self.navigationController pushViewController:locationListVC animated:YES];
                }
            });
        });
    } else {
        LocationListViewController * locationListVC = [LocationListViewController new];
        locationListVC.mapType = self.mapType;
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

-(void) mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate{
    if (CLLocationCoordinate2DIsValid(coordinate)){
        SMTMarker * marker = [SMTMarker markerWithPosition:coordinate];
        
        if (! self.geocoder)
            self.geocoder = [[CLGeocoder alloc] init];
        
        
        CLLocation * locForGeocoder = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        [self.geocoder reverseGeocodeLocation:locForGeocoder completionHandler:^(NSArray* placemarks, NSError* error){
            if (placemarks.count > 0 ){
                CLPlacemark * placemark = [placemarks objectAtIndex:0];
                marker.title = placemark.name;
            }
            else{
                marker.title = @"Unknown Location";
            }
            [self startLoader];
            dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(newQueue, ^(){
                [loader createLocationWithName:marker.title Latitude:coordinate.latitude Longitude:coordinate.longitude locationType:self.mapType];
                
                
                dispatch_async(dispatch_get_main_queue(), ^(){
                    [self endLoader];
                    if(loader.isCorrectRezult){
                        Location * loc = [listLocations lastObject];
                        marker.location = loc;
                        marker.icon = [UIImage imageNamed:@"map_marker"];
                        marker.map = mapView_;
                        [self beginMarkerAnimation:marker];
                        
                    }
                });
                
            });
        }];
    }
}

-(void) beginMarkerAnimation: (GMSMarker *) marker{
    CGPoint point1 = [mapView_.projection pointForCoordinate:marker.position];
    CGPoint point2 = CGPointMake(point1.x, 0);
    CLLocationCoordinate2D bounceCoord = [mapView_.projection coordinateForPoint:CGPointMake(point1.x, point1.y - 20)];
    CLLocationCoordinate2D coord = [mapView_.projection coordinateForPoint: point2 ];
    
    [CATransaction begin];{
        [CATransaction setCompletionBlock:^{
            [CATransaction setCompletionBlock:^{
                CABasicAnimation * animation3lat = [CABasicAnimation animationWithKeyPath:@"latitude"];
                animation3lat.fromValue = @(bounceCoord.latitude);
                animation3lat.toValue = @(marker.layer.latitude);
                
                CABasicAnimation * animation3Long = [CABasicAnimation animationWithKeyPath:@"longitude"];
                animation3Long.fromValue = @(bounceCoord.longitude);
                animation3Long.toValue = @(marker.layer.longitude);
                
                CAAnimationGroup * group3 = [CAAnimationGroup animation];
                group3.duration = 0.1f;
                group3.timingFunction =[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
                group3.animations = [NSArray arrayWithObjects:animation3lat, animation3Long, nil];
                
                [marker.layer addAnimation:group3 forKey:@"MyAnimationGroup3"];
                
            }];
            CABasicAnimation *animation2lat = [CABasicAnimation animationWithKeyPath:@"latitude"];
            animation2lat.fromValue = @(marker.layer.latitude);
            animation2lat.toValue = @(bounceCoord.latitude);
            
            CABasicAnimation * animation2Long = [CABasicAnimation animationWithKeyPath:@"longitude"];
            animation2Long.fromValue = @(marker.layer.longitude);
            animation2Long.toValue = @(bounceCoord.longitude);
            
            CAAnimationGroup * group2 = [CAAnimationGroup animation];
            group2.duration = 0.1;
            group2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            group2.animations = [NSArray arrayWithObjects:animation2lat, animation2Long, nil];
            
            [marker.layer addAnimation:group2 forKey:@"MyAnimationGroup2"];
            
        }];
        CABasicAnimation *animationLat = [CABasicAnimation animationWithKeyPath:@"latitude"];
        animationLat.fromValue = @(coord.latitude);
        animationLat.toValue = @(marker.layer.latitude);
        
        CABasicAnimation * animationLong = [CABasicAnimation animationWithKeyPath:@"longitude"];
        animationLong.fromValue = @(coord.longitude);
        animationLong.toValue = @(marker.layer.longitude);
        
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.duration = 0.1f;
        group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        group.animations = [NSArray arrayWithObjects:animationLat, animationLong, nil];
        
        [marker.layer addAnimation:group forKey:@"MyAnimationGroup"];
        
    }
    [CATransaction commit];
    
    [mapView_ setSelectedMarker:marker];
}

- (void) mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{
    if (![marker isKindOfClass:[SMTMarker class]]) return;
    BaseLocationViewController * locUpdateVC = [BaseLocationViewController new];
    locUpdateVC.location = ((SMTMarker*) marker).location;
    [self.navigationController pushViewController:locUpdateVC animated:YES];
    return;
}






@end
