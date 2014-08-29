#import <UIKit/UIKit.h>
//#import "UIViewController+LoaderCategory.h"

#define MAX_STRING_LENGTH 32

@interface RegisterViewController : GAITrackedViewController <UITextFieldDelegate, MenuViewControllerDelegate>
{
    NSString * userFirstName;
    NSString * userSecondName;
    NSString * userName;
    NSString * userSex;
    int userBirthYear;
    NSString * userFid;
}

@property (nonatomic) BOOL isSignWithFacebook;
@property (strong, nonatomic) IBOutlet UIView *logoView;
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) IBOutlet UIButton *btnRegister;

@property (nonatomic, copy) NSString * screenName;

-(void) fillRegistrationInfo: (NSString*) firstName :(NSString*) lastName :(NSString*) email :(int) birthYear : (NSString*) sex andUserFid:(NSString*)userFID;

@end
