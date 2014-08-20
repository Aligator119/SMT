#import <UIKit/UIKit.h>
#import "MenuViewController.h"

@interface LoginViewController : GAITrackedViewController <UITextFieldDelegate, MenuViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton * btnFb;
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) IBOutlet UIButton *btnRegister;
@property (strong, nonatomic) IBOutlet UIView *logoView;

@property (nonatomic, copy) NSString * screenName;

- (void)fbUserLogin:(NSString*)uName password:(NSString*)uPassword;
- (void)fbUserFirstLogin:(NSString*)_name fbID:(NSString*)_fbID;
- (void)sessionIsActive;

@end
