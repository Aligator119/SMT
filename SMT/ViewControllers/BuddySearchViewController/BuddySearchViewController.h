//
//  HPBuddySearchViewController.h
//  HunterPredictor
//
//  Created by Vasya on 06.02.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddBuddyProtocol.h"
@class Buddy;

@interface BuddySearchViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, HPAddBuddyProtocol>

@property (strong, nonatomic) IBOutlet UITableView * tblListOfFindedUsers;
@property (strong, nonatomic) IBOutlet UISearchBar * searchBuddy;

- (void)addFindingUsers:(NSMutableArray*)_list;
- (void)addFindingUserToBuddies:(Buddy*)_buddy;

@end
