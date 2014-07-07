#import <UIKit/UIKit.h>
#import "LogDetailCell.h"
#import "LogDetailViewController.h"
#import "DataLoader.h"
#import "PhotoVideoViewController.h"
#import "CustomButton.h"
#import "CustomTextField.h"

@interface LogDetail2ViewController : UIViewController <UIGestureRecognizerDelegate, PhotoViewControllerDelegate, ButtonControllerDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarHeightConstr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarVerticalConstr;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UIView * viewTrophy;
@property (strong, nonatomic) IBOutlet UIView *pickerView;
@property (strong, nonatomic) IBOutlet UIImageView *trophyImg;


- (IBAction)actBack:(id)sender;
- (IBAction)actSaveDetail:(id)sender;
- (IBAction)actCancel:(id)sender;
- (IBAction)actDonePicker:(id)sender;
- (IBAction)actCancelPicker:(id)sender;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andData:(NSDictionary *)dict;

@end
