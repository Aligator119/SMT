//
//  NorthernPikeCell.h
//  SMT
//
//  Created by Mac on 5/26/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NorthernPikeCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet UITextField *tfSeen;
@property (strong, nonatomic) IBOutlet UITextField *tfHarvested;
@property (strong, nonatomic) IBOutlet UIButton *btnLevel;

- (void) setImageForCell:(NSString *)str;

@end
