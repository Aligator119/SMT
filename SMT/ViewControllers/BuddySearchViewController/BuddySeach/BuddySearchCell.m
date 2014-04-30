//
//  HPBuddySearchCell.m
//  HunterPredictor
//
//  Created by Vasya on 06.02.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import "BuddySearchCell.h"

@implementation BuddySearchCell

- (void)setSizeToFit{
    [self.lblBuddyUserName sizeToFit];
    [self.lblBuddySecondName sizeToFit];
    
    [self setLblWidth:self.lblBuddySecondName];
    [self setLblWidth:self.lblBuddyUserName];
}

- (void)setLblWidth:(UILabel*)_lbl{
    CGRect newFrame = _lbl.frame;
    newFrame.size.width = 180;
    _lbl.frame = newFrame;
}

- (void)addDelegate:(id)delegate{
    [self.btnAddBuddy addTarget:delegate action:@selector(AddBuddy:) forControlEvents:UIControlEventTouchUpInside];
}

@end
