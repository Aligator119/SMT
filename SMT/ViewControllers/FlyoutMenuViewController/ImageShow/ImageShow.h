#import <UIKit/UIKit.h>


@interface ImageShow : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heigthImage;
@property (weak, nonatomic) IBOutlet UILabel *lbDescriptions;

- (void)setImageWithURL:(NSURL *) url andImageID:(NSString *) photoID descriptions:(NSString *)str andUserName:(NSString *)name;
- (void)setPhotoDescriptions:(NSString *)str andUserName:(NSString *)name andImage:(UIImage *)image;
- (void)setImage:(UIImage *)image;
- (void)startLaderInCell;
- (void)stopLoaderInCell;
@end
