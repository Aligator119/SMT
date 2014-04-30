//
//  HPBuddySearchCell.h
//  HunterPredictor
//
//  Created by Vasya on 06.02.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddBuddyProtocol.h"
@class HPBuddySearchViewController;

@interface BuddySearchCell : UITableViewCell <HPAddBuddyProtocol>

@property (strong, nonatomic) IBOutlet UILabel * lblBuddySecondName;
@property (strong, nonatomic) IBOutlet UILabel * lblBuddyUserName;
@property (strong, nonatomic) IBOutlet UIButton * btnAddBuddy;
@property (strong, nonatomic) UIViewController * delegateController;

- (void)setSizeToFit;
- (void)addDelegate:(HPBuddySearchViewController*)delegate;

@end
