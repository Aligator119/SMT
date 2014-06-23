#import <UIKit/UIKit.h>
#import "PhotoVideoViewController.h"
#import "CustomTabBar.h"

@interface FlyoutMenuViewController : UIViewController <MyNewCustomTabBarDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet CustomTabBar *tabBar;

@end
