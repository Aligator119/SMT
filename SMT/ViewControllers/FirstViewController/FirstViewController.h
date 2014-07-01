#import <UIKit/UIKit.h>
#import "FlyoutMenuViewController.h"
#import "AppDelegate.h"
#import "LocationListViewController.h"
#import "NewLog1ViewController.h"
#import "UIViewController+LoaderCategory.h"
#import "CameraViewController.h"
#import "CustomTabBar.h"


@interface FirstViewController : UIViewController <MyNewCustomTabBarDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, CameraControllerDelegate>

@property (strong, nonatomic) UIView * current;

- (void)showSettings;


@end
