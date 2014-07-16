#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface MapViewController : GAITrackedViewController <GMSMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic) NSInteger mapType;

@property (nonatomic, copy) NSString * screenName;

- (void) moveToLocation: (CLLocationCoordinate2D) loc;


@end
