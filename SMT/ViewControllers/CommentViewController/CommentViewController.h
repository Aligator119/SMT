#import <UIKit/UIKit.h>

@class Photo;
@interface CommentViewController : UIViewController
@property (strong, nonatomic) Photo *photo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forImageID:(NSString *)photo_id;
@end
