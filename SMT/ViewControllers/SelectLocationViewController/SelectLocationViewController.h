//
//  SelectLocationViewController.h
//  SMT
//
//  Created by Mac on 5/16/14.
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

- (IBAction)cancelButtonTap:(id)sender;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *navigationBarHeightConstr;


@end
