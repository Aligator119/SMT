#import <UIKit/UIKit.h>
#import "SpeciesCell.h"
#import "CustomTabBar.h"

@interface NewLog1ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    BOOL isPresent;
}

@property (strong, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarVerticalConstr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarHeightConstr;
@property (strong, nonatomic) IBOutlet CustomTabBar *tabBar;


-(void) setIsPresent:(BOOL)present;

@end
