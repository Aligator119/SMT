//
//  LogDetail2ViewController.h
//  SMT
//
//  Created by Mac on 5/13/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogDetail2ViewController : UIViewController <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarHeightConstr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarVerticalConstr;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectTime;
@property (weak, nonatomic) IBOutlet UITextField *tfLeftSide;
@property (weak, nonatomic) IBOutlet UITextField *tfRigthSide;
@property (weak, nonatomic) IBOutlet UITextField *tfWeigth;
@property (weak, nonatomic) IBOutlet UIButton *btnTrophy;
@property (strong, nonatomic) IBOutlet UIView *pickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *picker;

- (IBAction)actBack:(id)sender;
- (IBAction)actSelectTime:(id)sender;
- (IBAction)actDidEndOnExit:(id)sender;
- (IBAction)actSaveDetail:(id)sender;
- (IBAction)actCancel:(id)sender;
- (IBAction)actDonePicker:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andData:(NSDictionary *)dict;

@end
