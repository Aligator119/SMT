//
//  LogHistoryViewController.h
//  SMT
//
//  Created by Mac on 5/8/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataLoader.h"
#import "HistoryCell.h"

@interface LogHistoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarHeightConstr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarVerticalConstr;

@end
