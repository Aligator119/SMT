#import <UIKit/UIKit.h>

@interface PredictionViewController : GAITrackedViewController <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarHeightConstr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarVerticalConstr;
@property (weak, nonatomic) IBOutlet UIView *huntPredictor;
@property (weak, nonatomic) IBOutlet UIView *fishPredictor;

@property (nonatomic, copy) NSString * screenName;

- (IBAction)actBack:(id)sender;
@end
