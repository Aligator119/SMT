#import <UIKit/UIKit.h>
#import "Species.h"

@protocol ButtonControllerDelegate <NSObject>

@required

- (void)openPickerWithData:(NSArray *)array andTag:(int)tag;

@end

@interface CustomButton : UIButton 

@property (weak, nonatomic) id<ButtonControllerDelegate> delegate;

- (void) setInputArray:(NSArray *)array;
- (void) setWithInputDictionary:(NSDictionary *)dict;
- (NSString *) getSelectedIthem;
- (Species *)  getSelectedSpecie;
- (void) removeSelectIthem;
- (void) addSpecie:(Species *)spec;
- (void) setSelectedIthem:(NSString *)str;
- (void) setSelectedSpecies:(Species *)spec;
- (NSString *) getQuestion;
- (void) setButtonWithKillingDictionary:(NSDictionary *) dict;

@end
