//
//  SpeciesCell.m
//  SMT
//
//  Created by Mac on 5/28/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "SpeciesCell.h"


@interface SpeciesCell ()
@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet UILabel *name;

@end

@implementation SpeciesCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setSpecie:(Species *)specie
{
    self.name.text = specie.name;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:specie.thumbnail]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.img.layer.masksToBounds = YES;
            self.img.layer.cornerRadius = self.img.frame.size.height / 2;
            self.img.layer.borderColor = [UIColor grayColor].CGColor;
            self.img.layer.borderWidth = 1.0f;
            
            self.img.image = [UIImage imageWithData:imageData];
        });
    });

}

@end
