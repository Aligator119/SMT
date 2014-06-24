#import <UIKit/UIKit.h>
#import "FlyoutMenuViewController.h"
#import "AppDelegate.h"
#import "MapViewController.h"
#import "NewLog1ViewController.h"
#import "UIViewController+LoaderCategory.h"
#import "CameraViewController.h"
#import "CustomTabBar.h"


@interface FirstViewController : UIViewController <MyNewCustomTabBarDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView * current;

- (void)showSettings;

- (void)goToViewController:(UIViewController *)viewController;

@end
