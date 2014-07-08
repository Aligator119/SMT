#import <UIKit/UIKit.h>


@interface ImageShow : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heigthImage;
@property (strong, nonatomic) IBOutlet UILabel *lbDescriptions;

- (void)setImageWithURL:(NSURL *) url andImageID:(NSString *) photoID andDescriptions:(NSString *)str;
- (void)setPhotoDescriptions:(NSString *)str;
- (void)setImage:(UIImage *)image;
- (void)startLaderInCell;
@end
