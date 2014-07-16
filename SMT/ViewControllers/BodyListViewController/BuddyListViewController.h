#import <UIKit/UIKit.h>
#import "Cell.h"
#import "IncomingFriendCell.h"
#import "InviteFriendCell.h"

@interface BuddyListViewController : GAITrackedViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarHeightConstr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarVerticalConstr;

@property (nonatomic, copy) NSString * screenName;

@end
