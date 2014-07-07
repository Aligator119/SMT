#import <UIKit/UIKit.h>

@interface ImageShow : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *image;

- (void)setImageWithURL:(NSURL *) url andImageID:(NSString *) photoID;

@end
