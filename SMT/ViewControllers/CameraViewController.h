#import <UIKit/UIKit.h>
#import "NewLog1ViewController.h"
#import "FlyoutMenuViewController.h"
#import "CustomTabBar.h"


@protocol CameraControllerDelegate <NSObject>

@required

- (void)newUserAvatar:(UIImage *)avatar;

@end


@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    BOOL isPresent;
}
@property (weak, nonatomic) id<CameraControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet CustomTabBar *tabBar;

-(void) setIsPresent:(BOOL)present;


@end
