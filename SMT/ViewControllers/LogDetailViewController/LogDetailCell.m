#import "LogDetailCell.h"

@implementation LogDetailCell

- (void)awakeFromNib
{
    // Initialization code
    _cellState = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
