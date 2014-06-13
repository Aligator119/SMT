//
//  ShareLocationViewController.h
//  SMT
//
//  Created by Mac on 6/12/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

@interface ShareLocationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andLocation:(Location *)location;

@end
