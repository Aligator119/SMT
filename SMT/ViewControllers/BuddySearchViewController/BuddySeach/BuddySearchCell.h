#import <UIKit/UIKit.h>
#import "AddBuddyProtocol.h"
@class BuddySearchViewController;

@interface BuddySearchCell : UITableViewCell <HPAddBuddyProtocol>

@property (weak, nonatomic) IBOutlet UILabel * lblBuddySecondName;
@property (weak, nonatomic) IBOutlet UILabel * lblBuddyUserName;
@property (weak, nonatomic) IBOutlet UIButton * btnAddBuddy;
@property (weak, nonatomic) UIViewController * delegateController;

- (void)setSizeToFit;
- (void)addDelegate:(UIViewController*)delegate;

@end
