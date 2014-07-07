#import <UIKit/UIKit.h>
#import "Species.h"

@interface CreateTipsCell : UICollectionViewCell //<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *tfText;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectSpecie;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectSubSpecie;
@property (strong, nonatomic) IBOutlet UIButton *btnCreateTIPS;


@property (strong, nonatomic) Species * specie;
@property (strong, nonatomic) Species * subSpecie;

@end
