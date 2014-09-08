#import <UIKit/UIKit.h>
#import "Photo.h"


@class Photo;
@interface CommentViewController : UIViewController
@property (strong, nonatomic) Photo *photo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forPhoto:(Photo *)photo;
@end
