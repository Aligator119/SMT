//
//  LocationsListViewController.h
//  SMT
//
//  Created by Alexander on 06.05.14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

@protocol LocationListViewControllerDelegate;

@protocol LocationListViewControllerDelegate <NSObject>

@required

- (void)selectLocation:(Location*)location;

@end

@interface SelectLocationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id<LocationListViewControllerDelegate> delegate;

@end
