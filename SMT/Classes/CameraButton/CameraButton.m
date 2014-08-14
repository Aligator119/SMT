#import "CameraButton.h"

#define FONE       @"takePic_BTN.png"
#define FONE_PRESS @"takePic_BTN_press.png"
#define bwidth  68
#define bheigth 50

@implementation CameraButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
    }
    return self;
}

- (id) init
{
    CGRect frame = [UIScreen mainScreen].bounds;
    CGRect bounds = CGRectMake((frame.size.width - bwidth)/2, frame.size.height - bheigth, bwidth, bheigth);
    self = [super initWithFrame:bounds];
    if (self) {
        [self setBackgroundImage:[UIImage imageNamed:FONE] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:FONE_PRESS] forState:UIControlStateHighlighted];
    }
    return self;
}
@end
