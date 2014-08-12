#import <UIKit/UIKit.h>
#import "SpeciesCell.h"

@interface NewLog1ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarVerticalConstr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarHeightConstr;


@end
