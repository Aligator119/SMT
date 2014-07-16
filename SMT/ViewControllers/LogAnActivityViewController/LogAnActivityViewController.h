#import <UIKit/UIKit.h>

@interface LogAnActivityViewController : GAITrackedViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarVerticalConstr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarHeightConstr;

@property (nonatomic, copy) NSString * screenName;

- (IBAction)actPhotoLog:(id)sender;
- (IBAction)actTraditionalLog:(id)sender;
@end
