#import <UIKit/UIKit.h>

@protocol CameraControllerDelegate <NSObject>

@optional
- (void)returnImage:(UIImage *)image;

- (void)newUserAvatar:(UIImage *)image;

@end


@interface CameraViewController : GAITrackedViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) id<CameraControllerDelegate> delegate;

@property (nonatomic) BOOL isReturnImage;

@property (nonatomic, copy) NSString * screenName;

@end
