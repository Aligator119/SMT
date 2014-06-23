//
//  SettingsViewController.h
//  SMT
//
//  Created by Alexander on 06.05.14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpeciesViewController.h"
#import "SelectLocationViewController.h"
#import "Location.h"
#import "Species.h"

@interface SettingsViewController : UIViewController <LocationListViewControllerDelegate, SpeciesViewControllerDelegate>

@end
