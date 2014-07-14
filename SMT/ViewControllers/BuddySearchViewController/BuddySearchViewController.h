#import <UIKit/UIKit.h>
#import "AddBuddyProtocol.h"
@class Buddy;

@interface BuddySearchViewController : GAITrackedViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, HPAddBuddyProtocol>

@property (strong, nonatomic) IBOutlet UITableView * tblListOfFindedUsers;
@property (strong, nonatomic) IBOutlet UISearchBar * searchBuddy;
@property (nonatomic, copy) NSString * screenName;

- (void)addFindingUsers:(NSMutableArray*)_list;
- (void)addFindingUserToBuddies:(Buddy*)_buddy;

@end
