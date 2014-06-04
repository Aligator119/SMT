#import <UIKit/UIKit.h>

@interface CustomTextField : UITextField <UITextFieldDelegate>

- (void) setWithInputDictionary:(NSDictionary *)dict;
- (NSString *) getText;
- (NSString *) getQuestionID;

@end
