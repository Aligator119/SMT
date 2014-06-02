//
//  NewLog2ViewController.m
//  SMT
//
//  Created by Mac on 5/8/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "NewLog2ViewController.h"
#import "DataLoader.h"
#import "AppDelegate.h"
#import "LogDetailViewController.h"
#import "UIViewController+LoaderCategory.h"
#import "NorthernPikeCell.h"
#import "Activity.h"
#import "ActivityDetails.h"
#import "Location.h"


#define TAG 12345
#define INDEX_SPECIES_LIST 1

#define COMPLETE_DATE_UNITS   NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond

@interface NewLog2ViewController ()
{
    NSMutableArray * listOfSpecies;
    int pickerType;
    NSDateFormatter * dateFormatter;
    NSDateFormatter * btnDateFormatter;
    NSDateFormatter * timeFormatter;
    NSDateFormatter * btnTimeFormatter;
    AppDelegate * appDelegate;
    DataLoader * dataLoader;
    NSMutableArray * activityDetails;
    Activity * activity;
    NSDate * dates;
    NSIndexPath * path;
    NSString * logID;
    }
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) IBOutlet UIView *datePickerView;
@property (strong, nonatomic) IBOutlet UIView *pickerView;

@property (strong, nonatomic) Species * species;

- (void) pressedDatePickerView:(id)sender;
- (void) pressedPickerView:(id)sender;
- (IBAction)actButtonBack:(id)sender;
- (IBAction)actDoneDatePicker:(id)sender;
- (IBAction)actDonePicker:(id)sender;
//- (void)actDidOnToExit:(UITextField *)sender;
- (void)actDidOnToExitSeen:(UITextField *)sender;
- (void)actDidOnToExitHarvested:(UITextField *)sender;
- (void)actSelectStar:(UIButton *)sender;
- (void)keyboardDidShow: (NSNotification *) notif;
- (void)keyboardDidHide: (NSNotification *) notif;
@end

@implementation NewLog2ViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andSpecies:(Species *)species
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.species = species;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        self.navigationBarHeightConstr.constant -= 20;
        self.navigationBarVerticalConstr.constant -=20;
    }
    
    listOfSpecies = [[NSMutableArray alloc]init];

    //------------------------------------------------------------------------------
    self.huntType =     @"";
    self.weapon =       @"";
    
    self.huntTypeList = [[NSArray alloc]initWithObjects:@"Drive", @"Stalking", nil];
    self.weaponList = [[NSArray alloc]initWithObjects:@"Rifle", nil];
    
    UINib *cellNib = [UINib nibWithNibName:@"NorthernPikeCell" bundle:[NSBundle mainBundle]];
    [self.table registerNib:cellNib forCellReuseIdentifier:@"NorthernPikeCell"];
    
    
    self.picker.delegate = self;
    
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    btnDateFormatter = [[NSDateFormatter alloc]init];
    [btnDateFormatter setDateFormat:@"MMMM dd yyyy"];
    timeFormatter = [[NSDateFormatter alloc]init];
    [timeFormatter setDateFormat:@"hh:mm:ss"];
    btnTimeFormatter = [[NSDateFormatter alloc]init];
    [btnTimeFormatter setDateFormat:@"h:mm a"];
    
    activityDetails = [[NSMutableArray alloc]init];
    activity = [[Activity alloc]init];
    dates = [NSDate date];
    
    
    UITapGestureRecognizer *datePickerViewRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedDatePickerView:)];
    [datePickerViewRecognizer setNumberOfTapsRequired:1];
    [datePickerViewRecognizer setDelegate:self];
    
    [self.datePickerView addGestureRecognizer:datePickerViewRecognizer];
    
    UITapGestureRecognizer * pickerViewRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedPickerView:)];
    [pickerViewRecognizer setNumberOfTapsRequired:1];
    [pickerViewRecognizer setDelegate:self];
    
    [self.pickerView addGestureRecognizer:pickerViewRecognizer];
    
    [self.datePickerView setBackgroundColor:[UIColor colorWithRed:0.99 green:0.99 blue:0.99 alpha:0.7]];
    [self.pickerView setBackgroundColor:[UIColor colorWithRed:0.99 green:0.99 blue:0.99 alpha:0.7]];
    
    [self AddActivityIndicator:[UIColor grayColor] forView:self.view];
    dataLoader = [DataLoader instance];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    
}

- (void) viewWillAppear:(BOOL)animated
{   if ([self.northernPikeList firstObject] == nil) {
    [self startLoader];
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        
        self.northernPikeList = [[NSMutableArray alloc]initWithArray:[dataLoader getSubSpecies:[self.species.specId intValue]]];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            if(!dataLoader.isCorrectRezult) {
                NSLog(@"Error download sybSpecie");
            } else {
                [self.table reloadData];
                [self endLoader];
            }
        });
    });
}
    
}


#pragma mark Table delegate metods
//------------------------------------------------
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listOfSpecies count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NorthernPikeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NorthernPikeCell"];
    
        [cell.tfSeen addTarget:self action:@selector(actDidOnToExitSeen:) forControlEvents:UIControlEventEditingChanged];
    cell.tfSeen.delegate = self;
        cell.tfSeen.tag = indexPath.row;
        [cell.tfHarvested addTarget:self action:@selector(actDidOnToExitHarvested:) forControlEvents:UIControlEventEditingChanged];
    cell.tfHarvested.delegate = self;
        cell.tfHarvested.tag = indexPath.row;
        [cell setImageForCell:((Species *)[listOfSpecies objectAtIndex:indexPath.row]).photo];
        [cell.btnLevel addTarget:self action:@selector(actSelectStar:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnLevel.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Species * buf = [listOfSpecies objectAtIndex:indexPath.row];
        [self.northernPikeList addObject:buf];
        [activityDetails removeObjectAtIndex:indexPath.row];
        [listOfSpecies removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        }
        if (![listOfSpecies count]) {
            [tableView reloadData];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0 && [listOfSpecies firstObject] != nil) {
        return self.infoView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 && [listOfSpecies firstObject] != nil) {
        return self.infoView.frame.size.height;
    }
    return 0.0f;
}
//---------------------------------------------------------------------------------------------------------------

#pragma mark Picker delegate metods

//------------------------------------------------------
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger num = 5;
    if (pickerType == 1) {
        num = self.huntTypeList.count;
    } else if (pickerType == 2) {
        num = self.weaponList.count;
    } else if (pickerType == 3) {
        num = self.northernPikeList.count;
    }
    return num;
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * str = @"";
    if (pickerType == 1) {
        str = [self.huntTypeList objectAtIndex:row];
    } else if (pickerType == 2) {
        str = [self.weaponList objectAtIndex:row];
    } else if (pickerType == 3) {
        str = ((Species *)[self.northernPikeList objectAtIndex:row]).name;
    }
    NSMutableAttributedString * aStr = [[NSMutableAttributedString alloc]initWithString:str];
    [aStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, str.length)];
    return str;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerType == 1) {
        self.huntType = [self.huntTypeList objectAtIndex:row];
    } else if (pickerType == 2) {
        self.weapon = [self.weaponList objectAtIndex:row];
    } else if (pickerType == 3) {
        self.northernPike = [self.northernPikeList objectAtIndex:row];
    }
    
}
//----------------------------------------------------------


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) pressedDatePickerView:(id)sender
{
    switch (self.datePicker.tag) {
        case 1:
        {
                self.huntDate = self.datePicker.date;
                [self.btnDate setTitle:[btnDateFormatter stringFromDate:self.huntDate] forState:UIControlStateNormal];
            }
            break;
            
        case 2:
             {
                self.huntStartTime = self.datePicker.date;
                [self.btnStartTime setTitle:[btnTimeFormatter stringFromDate:self.huntStartTime] forState:UIControlStateNormal];
            }
            break;
            
        case 3:
            if ([[self.huntStartTime laterDate:self.datePicker.date] isEqualToDate:self.datePicker.date]) {
                self.huntEndTime = self.datePicker.date;
                [self.btnEndTime setTitle:[btnTimeFormatter stringFromDate:self.huntEndTime] forState:UIControlStateNormal];
            }
            break;
    }
    [self.datePickerView removeFromSuperview];
}

- (void) pressedPickerView:(id)sender
{
    [self.pickerView removeFromSuperview];
    if (pickerType == 1) {
        self.btnHuntType.titleLabel.text = self.huntType;
    } else if (pickerType == 2) {
        self.btnWeapon.titleLabel.text = self.weapon;
    } else if (pickerType == 3) {
        self.btnNorthernPike.titleLabel.text = self.northernPike.name ;
        //[self.btnNorthernPike.titleLabel sizeToFit];
    }
}

- (IBAction)actDoneDatePicker:(id)sender {
    switch (self.datePicker.tag) {
        case 1:
            {
                self.huntDate = self.datePicker.date;
                [self.btnDate setTitle:[btnDateFormatter stringFromDate:self.huntDate] forState:UIControlStateNormal];
            }
            break;
            
        case 2:
             {
                self.huntStartTime = self.datePicker.date;
                [self.btnStartTime setTitle:[btnTimeFormatter stringFromDate:self.huntStartTime] forState:UIControlStateNormal];
            }
            break;
            
        case 3:
            if ([[self.huntStartTime laterDate:self.datePicker.date] isEqualToDate:self.datePicker.date]) {
                self.huntEndTime = self.datePicker.date;
                [self.btnEndTime setTitle:[btnTimeFormatter stringFromDate:self.huntEndTime] forState:UIControlStateNormal];
            }
            break;
    }
    [self.datePickerView removeFromSuperview];
}

- (IBAction)actDonePicker:(id)sender {
    [self.pickerView removeFromSuperview];
    if (pickerType == 1) {
        self.btnHuntType.titleLabel.text = self.huntType;
    } else if (pickerType == 2) {
        self.btnWeapon.titleLabel.text = self.weapon;
    } else if (pickerType == 3) {
        self.btnNorthernPike.titleLabel.text = self.northernPike.name ;
        //[self.btnNorthernPike.titleLabel sizeToFit];
    }
}


- (IBAction)actFinalizeLog:(id)sender {
    if (self.location && self.huntDate && self.huntEndTime && self.huntStartTime) {
    activity.startTime = [timeFormatter stringFromDate:self.huntStartTime];
    activity.endTime = [timeFormatter stringFromDate:self.huntEndTime];
    activity.date = [dateFormatter stringFromDate:self.huntDate];
    activity.location_id = self.location.locID;
//----------------------------------------------------------------------------------------------------
        dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(newQueue, ^(){
            
            logID = [dataLoader createActivityWithActivityObject:activity andActivityDetails:activityDetails andSpeciesId:[self.species.specId integerValue]];
            
            dispatch_async(dispatch_get_main_queue(), ^(){
                
                if(!dataLoader.isCorrectRezult) {
                    NSLog(@"Error download sybSpecie");
                } else {
        
                    NSDictionary * dict = [[NSDictionary alloc]initWithObjectsAndKeys:listOfSpecies, @"specie", activity, @"activity", activityDetails, @"activityDetails", logID, @"id", nil];
                    LogDetailViewController * ldvc = [[LogDetailViewController alloc]initWithNibName:@"LogDetailViewController" bundle:nil andProperty:dict];
                    [self.navigationController pushViewController:ldvc animated:YES];

                }
            });
        });
//---------------------------------------------------------------------------------------
    } else {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Selected date or time or location" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)actCancel:(id)sender {
    [[((UIButton *) sender) superview] removeFromSuperview];
}

- (IBAction)actButtonBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actLocation:(id)sender {
    SelectLocationViewController * slvc = [[SelectLocationViewController alloc]initWithNibName:@"SelectLocationViewController" bundle:nil];
    slvc.delegate = self;
    [self.navigationController pushViewController:slvc animated:YES];
}

- (IBAction)actDate:(id)sender {
    self.datePicker.tag = 1;
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.date = [NSDate date];
    //self.datePicker.minimumDate = [NSDate date];
    [self.view addSubview:self.datePickerView];
}

- (IBAction)actStartTime:(id)sender {
    self.datePicker.tag = 2;
    //NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"NL"];
    //[self.datePicker setLocale:locale];
    self.datePicker.datePickerMode = UIDatePickerModeTime;
    self.datePicker.date = [NSDate date];
    //self.datePicker.minimumDate = [NSDate date];
    [self.view addSubview:self.datePickerView];
}

- (IBAction)actEndTime:(id)sender {
    self.datePicker.tag = 3;
    self.datePicker.datePickerMode = UIDatePickerModeTime;
    self.datePicker.date = [NSDate date];
    
    
    [self.view addSubview:self.datePickerView];
}


- (IBAction)actHuntType:(id)sender {
    pickerType = 1;
    [self.view addSubview:self.pickerView];
    [self.picker reloadAllComponents];
    self.huntType = [self.huntTypeList firstObject];
}

- (IBAction)actWeapon:(id)sender {
    pickerType = 2;
    [self.view addSubview:self.pickerView];
    [self.picker reloadAllComponents];
    self.weapon = [self.weaponList firstObject];
}

- (IBAction)actNorthernPike:(id)sender {
    if ([self.northernPikeList count]) {
        pickerType = 3;
        [self.view addSubview:self.pickerView];
        [self.picker reloadAllComponents];
        self.northernPike = [self.northernPikeList firstObject];
    }
}

- (IBAction)actAdd:(id)sender {
    if (self.northernPike) {
        [self.northernPikeList removeObject:self.northernPike];
        self.btnNorthernPike.enabled = NO;
        [self.btnNorthernPike setTitle:@"Nothern Pike" forState:UIControlStateNormal];
        self.btnNorthernPike.enabled = YES;
        [listOfSpecies addObject:self.northernPike];
        ActivityDetails * details = [[ActivityDetails alloc]init];
        details.subspecies_id = [self.northernPike.specId intValue];
        [activityDetails addObject:details];
        self.northernPike = nil;
        [self.table reloadData];
        
    }
}

#pragma mark metods location delegate

- (void)selectLocation:(Location*)location
{
    self.location = location;
    [self.btnLocation setTitle:self.location.locName forState:UIControlStateNormal];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (void)actDidOnToExitSeen:(UITextField *)sender
{
    ((ActivityDetails *)[activityDetails objectAtIndex:sender.tag]).seen = [sender.text intValue];
}

- (void)actDidOnToExitHarvested:(UITextField *)sender
{
    if ([sender.text integerValue] <= ((ActivityDetails *)[activityDetails objectAtIndex:sender.tag]).seen) {
    ((ActivityDetails *)[activityDetails objectAtIndex:sender.tag]).harvested = [sender.text intValue];
    } else {
        ((ActivityDetails *)[activityDetails objectAtIndex:sender.tag]).harvested = ((ActivityDetails *)[activityDetails objectAtIndex:sender.tag]).seen;
        sender.text = [NSString stringWithFormat:@"%d", ((ActivityDetails *)[activityDetails objectAtIndex:sender.tag]).seen];
    }
}

- (void)actSelectStar:(UIButton *)sender
{
    self.viewStars.tag = sender.tag;
    for (UIButton * btn in self.viewStars.subviews) {
        if (btn.tag <= ((ActivityDetails *)[activityDetails objectAtIndex:sender.tag]).activitylevel) {
            [btn setBackgroundImage:[UIImage imageNamed:@"star_orange.png"] forState:UIControlStateNormal];
        } else {
            [btn setBackgroundImage:[UIImage imageNamed:@"star_opasity_orange.png"] forState:UIControlStateNormal];
        }
    }
    self.viewStars.backgroundColor = [UIColor whiteColor];
    float  width = [sender superview].frame.size.width;
    [[sender superview] addSubview:self.viewStars];
    CGRect bounds = self.viewStars.frame;
    bounds.origin.x = width;
    self.viewStars.frame = bounds;
    [UIView animateWithDuration:0.5f animations:^{
        CGRect bounds = self.viewStars.frame;
        bounds.origin.x -= width;
        self.viewStars.frame = bounds;
    }];
}

- (IBAction)actNumberSelectStar:(UIButton *)sender
{
    ((ActivityDetails *)[activityDetails objectAtIndex:self.viewStars.tag]).activitylevel = sender.tag;
    for (UIButton * btn in self.viewStars.subviews) {
        if (btn.tag<=sender.tag) {
            [btn setBackgroundImage:[UIImage imageNamed:@"star_orange.png"] forState:UIControlStateNormal];
        } else {
            [btn setBackgroundImage:[UIImage imageNamed:@"star_opasity_orange.png"] forState:UIControlStateNormal];
        }
    }
    [UIView animateWithDuration:0.5f animations:^{
        float  width = self.viewStars.frame.size.width;
        CGRect bounds = self.viewStars.frame;
        bounds.origin.x += width;
        self.viewStars.frame = bounds;
    } completion:^(BOOL finished) {
        [self.viewStars removeFromSuperview];
    }];
   
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    path = [NSIndexPath indexPathForItem:textField.tag inSection:0];
}

- (void)keyboardDidShow: (NSNotification *) notif{
    NSDictionary * info = [notif userInfo];
    CGSize keyboardSize = [self.view convertRect:[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:self.view.window].size;
    self.table.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
    [self.table scrollRectToVisible:[self.table rectForRowAtIndexPath:path] animated:YES];
}

- (void)keyboardDidHide: (NSNotification *) notif{
    self.table.contentInset = UIEdgeInsetsZero;
}

@end
