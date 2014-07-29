#import <UIKit/UIKit.h>


@interface CommentViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forImageID:(NSString *)photo_id;
@end
