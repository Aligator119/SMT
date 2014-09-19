#import <UIKit/UIKit.h>


@interface ImageShow : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbDescriptions;
@property (weak, nonatomic) IBOutlet UIButton *btnComment;

- (void)setImageWithURL:(NSURL *) url andImageID:(NSString *) photoID descriptions:(NSString *)str andUserName:(NSString *)name;
- (void)setPhotoDescriptions:(NSString *)str andUserName:(NSString *)name andImage:(UIImage *)image photoID:(NSString *)photo_id;
- (void)setPhotoDescriptions:(NSString *)str andUserName:(NSString *)name andTime:(NSDate*)time andImage:(UIImage *)image photoID:(NSString *)photo_id;
- (void)setPhotoDescriptions:(NSString *)str andUserName:(NSString *)name andTime:(NSDate*)time photoID:(NSString *)photo_id;
- (void)startLaderInCell;
- (void)stopLoaderInCell;
@end
