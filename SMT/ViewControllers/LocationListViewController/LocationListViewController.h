//
//  LocationListViewController.h
//  SMT
//
//  Created by Admin on 5/6/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *navigationBarHeightConstr;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *navigationBarVerticalConstr;
- (IBAction)actBack:(id)sender;

- (IBAction)actGroups:(id)sender;

@end
