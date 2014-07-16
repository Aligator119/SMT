#import <UIKit/UIKit.h>

@interface LocationSearchViewController : GAITrackedViewController<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIViewController * parent;

@property (nonatomic, copy) NSString * screenName;

@end
