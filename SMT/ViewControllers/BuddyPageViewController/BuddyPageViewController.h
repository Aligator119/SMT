#import <UIKit/UIKit.h>
#import "Buddy.h"
#import "CustomHeader.h"

@interface BuddyPageViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarHeightConstr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarVerticalConstr;
@property (weak, nonatomic) IBOutlet UILabel *lbNavigationBarTitle;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (strong, nonatomic) Buddy * buddy;

@property (nonatomic, copy) NSString * screenName;

- (IBAction)actBack:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withBuddy:(Buddy *) buddy;

@end
