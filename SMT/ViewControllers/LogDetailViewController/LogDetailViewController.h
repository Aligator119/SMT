//
//  LogDetailViewController.h
//  SMT
//
//  Created by Mac on 5/13/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarHeightConstr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarVerticalConstr;
@property (weak, nonatomic) IBOutlet UITableView *table;

- (IBAction)actClose:(id)sender;
@end
