//
//  NorthernPikeCell.m
//  SMT
//
//  Created by Mac on 5/26/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "NorthernPikeCell.h"

@implementation NorthernPikeCell

- (void)awakeFromNib
{
    // Initialization code
    self.tfHarvested.text = @"0";
    self.tfSeen.text = @"0";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setImageForCell:(NSString *)str
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.img.image = [UIImage imageWithData:imageData];
        });
    });

}

@end
