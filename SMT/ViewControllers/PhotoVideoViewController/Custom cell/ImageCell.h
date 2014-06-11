#import <UIKit/UIKit.h>


@interface ImageCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *foneImage;
@property (strong, nonatomic) UIImage * img;

- (void) setImage:(NSString *)url;

@end
