#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "LocationListViewController.h"
#import "NewLog1ViewController.h"
#import "UIViewController+LoaderCategory.h"
#import "CameraViewController.h"
#import "PhotoVideoViewController.h"


@interface FirstViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, /*CameraControllerDelegate, PhotoViewControllerDelegate,*/ UIImagePickerControllerDelegate, UINavigationControllerDelegate>


+ (FirstViewController *)instance;

@end
