#import <UIKit/UIKit.h>

@interface InviteFriendViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, copy) NSString * screenName;

@end
