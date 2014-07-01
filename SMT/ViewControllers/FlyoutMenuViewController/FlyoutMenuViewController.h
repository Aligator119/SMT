#import <UIKit/UIKit.h>
#import "PhotoVideoViewController.h"
#import "CustomTabBar.h"

@interface FlyoutMenuViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate>
{
    BOOL isPresent;
}
@property (strong, nonatomic) IBOutlet CustomTabBar *tabBar;

-(void) setIsPresent:(BOOL)present;
@end
