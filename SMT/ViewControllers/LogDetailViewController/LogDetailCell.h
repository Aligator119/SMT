//
//  LogDetailCellTableViewCell.h
//  SMT
//
//  Created by Mac on 5/13/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum cellStateTypes
{
    Add_Detail   = 0,
    Detail_Saved = 1
} CellState;

@interface LogDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbText;
@property (weak, nonatomic) IBOutlet UILabel *lbDetailText;
@property (nonatomic) CellState cellState;

@end
