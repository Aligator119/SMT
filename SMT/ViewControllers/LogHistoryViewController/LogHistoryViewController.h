#import <UIKit/UIKit.h>
#import "DataLoader.h"
#import "HistoryCell.h"

@interface LogHistoryViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarHeightConstr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarVerticalConstr;

@property (nonatomic, copy) NSString * screenName;

@end
