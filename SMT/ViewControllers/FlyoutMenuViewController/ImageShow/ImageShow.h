#import <UIKit/UIKit.h>


@interface ImageShow : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet UILabel *lbName;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heigthImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstrains;
@property (strong, nonatomic) IBOutlet UILabel *lbDescriptions;

- (void)setImageWithURL:(NSURL *) url andImageID:(NSString *) photoID descriptions:(NSString *)str andUserName:(NSString *)name;
- (void)setPhotoDescriptions:(NSString *)str andUserName:(NSString *)name andImage:(UIImage *)image;
- (void)setImage:(UIImage *)image;
- (void)startLaderInCell;
- (void)stopLoaderInCell;
@end
