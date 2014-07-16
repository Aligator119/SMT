//
//  SearchOutfitterCellTableViewCell.h
//  SMT
//
//  Created by Mac on 16.07.14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchOutfitterCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet UILabel *lbName;
@property (strong, nonatomic) IBOutlet UILabel *lbAddres;
@property (strong, nonatomic) IBOutlet UILabel *lbDetail;
@property (strong, nonatomic) IBOutlet UILabel *lbDistance;

@end
