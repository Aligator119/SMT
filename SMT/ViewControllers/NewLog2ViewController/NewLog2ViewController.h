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
#import "CustomButton.h"
#import "CustomTextField.h"

@interface NewLog2ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, LocationListViewControllerDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, ButtonControllerDelegate>

@property (strong, nonatomic) NSMutableArray * northernPikeList;
@property (strong, nonatomic) Location * location;
@property (strong, nonatomic) NSDate * huntDate;
@property (strong, nonatomic) NSDate * huntStartTime;
@property (strong, nonatomic) NSDate * huntEndTime;
@property (strong, nonatomic) NSString * selectedIthem;
@property (strong, nonatomic) Species * northernPike;
@property (strong, nonatomic) IBOutlet UIView *backraundView1;
@property (strong, nonatomic) IBOutlet UIView *backraundView2;

@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarHeightConstr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarVerticalConstr;
@property (strong, nonatomic) IBOutlet UIView *viewStars;

- (IBAction)actNumberSelectStar:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UILabel *lbNavigationBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andData:(NSDictionary *)dictionary;
@property (weak, nonatomic) IBOutlet UIButton *btnLocation;
@property (weak, nonatomic) IBOutlet UIButton *btnDate;

@property (weak, nonatomic) IBOutlet UIButton *btnStartTime;
@property (weak, nonatomic) IBOutlet UIButton *btnEndTime;


@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UIButton *btnFinalizeLog;

- (IBAction)actLocation:(id)sender;
- (IBAction)actDate:(id)sender;
- (IBAction)actEndTime:(id)sender;
- (IBAction)actStartTime:(id)sender;
- (IBAction)actAdd:(id)sender;
- (IBAction)actFinalizeLog:(id)sender;



@end
