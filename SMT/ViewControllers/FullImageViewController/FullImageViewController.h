#import <UIKit/UIKit.h>
#import "Photo.h"

@interface FullImageViewController : UIViewController <UIGestureRecognizerDelegate, UIScrollViewDelegate>

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andImage:(Photo *)photo;
@end
