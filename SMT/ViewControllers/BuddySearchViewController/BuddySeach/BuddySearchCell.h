#import <UIKit/UIKit.h>
#import "AddBuddyProtocol.h"
@class BuddySearchViewController;

@interface BuddySearchCell : UITableViewCell <HPAddBuddyProtocol>

@property (strong, nonatomic) IBOutlet UILabel * lblBuddySecondName;
@property (strong, nonatomic) IBOutlet UILabel * lblBuddyUserName;
@property (strong, nonatomic) IBOutlet UIButton * btnAddBuddy;
@property (strong, nonatomic) UIViewController * delegateController;

- (void)setSizeToFit;
- (void)addDelegate:(UIViewController*)delegate;

@end
