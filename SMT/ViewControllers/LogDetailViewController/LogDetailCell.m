//
//  LogDetailCellTableViewCell.m
//  SMT
//
//  Created by Mac on 5/13/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

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
