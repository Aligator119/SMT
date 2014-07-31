#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "PopUpMenu.h"

@interface MapViewController : GAITrackedViewController <GMSMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate, SearchInMapDelegate>

@property (nonatomic) int isPresentView;

@property (nonatomic) NSInteger mapType;

@property (nonatomic, copy) NSString * screenName;

- (void) moveToLocation: (CLLocationCoordinate2D) loc;

@end
