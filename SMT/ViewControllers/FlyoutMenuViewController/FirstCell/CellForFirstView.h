#import <UIKit/UIKit.h>
#import "Season.h"

@interface CellForFirstView : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgShow;
@property (weak, nonatomic) IBOutlet UILabel *lbName;

- (void)initWithSeason:(Season *)season;

@end
