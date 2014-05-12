//
//  NewLog2ViewController.h
//  SMT
//
//  Created by Mac on 5/8/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Species.h"
#import "Location.h"
#import "SelectLocationViewController.h"

@interface NewLog2ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate, LocationListViewControllerDelegate>

@property (strong, nonatomic) NSArray * huntTypeList;
@property (strong, nonatomic) NSArray * weaponList;
@property (strong, nonatomic) NSArray * northernPikeList;

@property (strong, nonatomic) Location * location;
@property (strong, nonatomic) NSDate * huntDate;
@property (strong, nonatomic) NSString  * huntType;
@property (strong, nonatomic) NSString * weapon;
@property (strong, nonatomic) NSString * northernPike;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarHeightConstr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarVerticalConstr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andSpecies:(Species *)species;

@property (weak, nonatomic) IBOutlet UIButton *btnDate;
@property (weak, nonatomic) IBOutlet UIButton *btnStartTime;
@property (weak, nonatomic) IBOutlet UIButton *btnEndTime;
@property (weak, nonatomic) IBOutlet UIButton *btnHuntType;
@property (weak, nonatomic) IBOutlet UIButton *btnWeapon;
@property (weak, nonatomic) IBOutlet UIButton *btnNorthernPike;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UIButton *btnFinalizeLog;

- (IBAction)actLocation:(id)sender;
- (IBAction)actDate:(id)sender;
- (IBAction)actEndTime:(id)sender;
- (IBAction)actStartTime:(id)sender;
- (IBAction)actHuntType:(id)sender;
- (IBAction)actWeapon:(id)sender;
- (IBAction)actNorthernPike:(id)sender;
- (IBAction)actAdd:(id)sender;
- (IBAction)actFinalizeLog:(id)sender;


@end
