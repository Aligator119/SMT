#import <UIKit/UIKit.h>
#import "LogDetailCell.h"
#import "Activity.h"
#import "ActivityDetails.h"
#import "AddCell.h"

@interface LogDetailViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray * list;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarHeightConstr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarVerticalConstr;
@property (weak, nonatomic) IBOutlet UITableView *table;

@property (strong, nonatomic) NSIndexPath * index;

@property (strong, nonatomic) NSMutableDictionary * settingsDict;

@property (nonatomic, copy) NSString * screenName;

- (IBAction)actClose:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andProperty:(NSDictionary *)dict;
@end
