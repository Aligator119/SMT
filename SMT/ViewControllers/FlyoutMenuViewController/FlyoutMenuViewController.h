#import <UIKit/UIKit.h>
#import "PhotoVideoViewController.h"
#import "CustomTabBar.h"

@interface FlyoutMenuViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate, UIScrollViewDelegate>
{
    BOOL isPresent;
}
@property (strong, nonatomic) IBOutlet CustomTabBar *tabBar;

-(void) setIsPresent:(BOOL)present;
@end
