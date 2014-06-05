#import <UIKit/UIKit.h>

@interface CustomTextField : UITextField <UITextFieldDelegate>


@property (strong, nonatomic) NSString * typeTF;

- (void) setWithInputDictionary:(NSDictionary *)dict;
- (void) setWithKillingDictionary:(NSDictionary *)dict;
- (NSString *) getText;
- (NSString *) getQuestionID;

@end
