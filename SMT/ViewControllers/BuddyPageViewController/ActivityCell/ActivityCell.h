//
//  ActivityCell.h
//  SMT
//
//  Created by Mac on 6/11/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet UILabel *lbName;
@property (strong, nonatomic) IBOutlet UILabel *lbLocation;
@property (strong, nonatomic) IBOutlet UILabel *lbDate;

@end
