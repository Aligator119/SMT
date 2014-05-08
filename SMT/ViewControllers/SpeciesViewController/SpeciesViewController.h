//
//  SpeciesViewController.h
//  SMT
//
//  Created by Alexander on 06.05.14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Species.h"
@protocol SpeciesViewControllerDelegate;

@protocol SpeciesViewControllerDelegate <NSObject>

@required

- (void)selectSpecies:(Species*)species;

@end

@interface SpeciesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id<SpeciesViewControllerDelegate> delegate;

@end
