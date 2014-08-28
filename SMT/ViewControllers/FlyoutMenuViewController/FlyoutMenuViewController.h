#import <UIKit/UIKit.h>
#import "PhotoVideoViewController.h"
#import "CustomTabBar.h"
#import "AddTips.h"
#import "CommentViewController.h"
#import "FullImageViewController.h"

@interface FlyoutMenuViewController : GAITrackedViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate, UIScrollViewDelegate>


@property (nonatomic, copy) NSString * screenName;
@end
