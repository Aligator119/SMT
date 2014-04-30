//
//  HPAddBuddyProtocol.h
//  HunterPredictor
//
//  Created by Vasya on 06.02.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HPAddBuddyProtocol <NSObject>

@optional
    - (IBAction)AddBuddy:(id)sender;
    - (IBAction)HideBuddy:(id)sender;
    - (IBAction)changeStateOfBuddy:(id)sender andCell:(UITableViewCell*)_cell;

@end
