#import <UIKit/UIKit.h>
#import "Photo.h"

@interface CommentHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (void)initWithPhoto:(Photo *)photo;

@end
