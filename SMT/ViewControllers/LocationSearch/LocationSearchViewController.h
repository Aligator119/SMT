//
//  LocationSearchViewController.h
//  SMT
//
//  Created by Admin on 5/5/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationSearchViewController : UIViewController<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIViewController * parent;

@end
