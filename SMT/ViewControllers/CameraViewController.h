#import <UIKit/UIKit.h>
#import "NewLog1ViewController.h"
#import "FlyoutMenuViewController.h"
#import "CustomTabBar.h"


@protocol CameraControllerDelegate <NSObject>

@required

- (void)newUserAvatar:(UIImage *)avatar;

@end


@interface CameraViewController : GAITrackedViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>
{
    BOOL isPresent;
}
@property (weak, nonatomic) id<CameraControllerDelegate> delegate;
@property (nonatomic) BOOL isCamera;
@property (strong, nonatomic) IBOutlet CustomTabBar *tabBar;

@property (nonatomic, copy) NSString * screenName;

-(void) setIsPresent:(BOOL)present;


@end
