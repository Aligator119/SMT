#import <UIKit/UIKit.h>

@class Location;
@interface BaseLocationViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) Location * location;

@end
