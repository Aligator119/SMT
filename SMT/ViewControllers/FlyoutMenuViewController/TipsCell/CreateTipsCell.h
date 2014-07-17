#import <UIKit/UIKit.h>
#import "Species.h"

@interface CreateTipsCell : UICollectionViewCell //<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *tfText;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectSpecie;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectSubSpecie;
@property (weak, nonatomic) IBOutlet UIButton *btnCreateTIPS;


@property (weak, nonatomic) Species * specie;
@property (weak, nonatomic) Species * subSpecie;

@end
