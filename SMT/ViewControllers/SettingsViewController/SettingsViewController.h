#import <UIKit/UIKit.h>
#import "SpeciesViewController.h"
#import "SelectLocationViewController.h"
#import "Location.h"
#import "Species.h"

@interface SettingsViewController : GAITrackedViewController <LocationListViewControllerDelegate, SpeciesViewControllerDelegate, UITextFieldDelegate>

@property (nonatomic, copy) NSString * screenName;

@end
