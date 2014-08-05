#import <UIKit/UIKit.h>

@protocol CameraControllerDelegate <NSObject>

@required

- (void)newUserAvatar:(UIImage *)avatar;

@end


@interface CameraViewController : GAITrackedViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) id<CameraControllerDelegate> delegate;


@property (nonatomic, copy) NSString * screenName;

@end
