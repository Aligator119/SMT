#import <UIKit/UIKit.h>

typedef enum cellStateTypes
{
    Add_Detail   = 0,
    Detail_Saved = 1
} CellState;

@interface LogDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbText;
@property (weak, nonatomic) IBOutlet UILabel *lbDetailText;
@property (nonatomic) CellState cellState;

@end
