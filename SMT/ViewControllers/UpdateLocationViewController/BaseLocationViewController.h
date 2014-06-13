#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@class Location;
@interface BaseLocationViewController : UIViewController <UITextFieldDelegate, GMSMapViewDelegate>

@property (nonatomic, strong) Location * location;

@end
