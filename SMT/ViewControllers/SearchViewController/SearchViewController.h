#import <UIKit/UIKit.h>
#import "AddBuddyProtocol.h"

@interface SearchViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, HPAddBuddyProtocol>

@property (nonatomic, copy) NSString * screenName;

@end
