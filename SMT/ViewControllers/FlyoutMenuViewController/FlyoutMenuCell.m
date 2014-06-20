//
//  FlyoutMenuCell.m
//  SMT
//
//  Created by Admin on 6/13/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "FlyoutMenuCell.h"

@interface FlyoutMenuCell ()

@property (nonatomic, weak) IBOutlet UIImageView *iconImage;
@property (nonatomic, weak) IBOutlet UILabel * titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *photoImage;
@property (strong, nonatomic) IBOutlet UITextView *tvText;

@end

@implementation FlyoutMenuCell

- (void) processCellWithImageName: (NSString*) _imageName andTitle: (NSString*) _title{
    self.iconImage.image = [UIImage imageNamed:_imageName];
    self.titleLabel.text = _title;
}



@end
