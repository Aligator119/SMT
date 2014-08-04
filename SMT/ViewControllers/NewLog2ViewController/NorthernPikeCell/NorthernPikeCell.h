#import <UIKit/UIKit.h>
#import "Species.h"

@interface NorthernPikeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet UITextField *tfSeen;
@property (strong, nonatomic) IBOutlet UITextField *tfHarvested;
@property (strong, nonatomic) IBOutlet UIButton *btnLevel;

- (void) setImageForCell:(Species *)spec;

@end
