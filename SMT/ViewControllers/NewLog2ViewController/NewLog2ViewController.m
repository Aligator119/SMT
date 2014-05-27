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
    NSArray * header;
    NSArray * footer;
    int pickerType;
    NSDateFormatter * dateFormatter;
    NSDateFormatter * timeFormatter;
    AppDelegate * appDelegate;
    DataLoader * dataLoader;
    NSMutableArray * activityDetails;
    Activity * activity;
    NSDate * dates;
    }
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) IBOutlet UIView *datePickerView;
@property (strong, nonatomic) IBOutlet UIView *pickerView;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footer;
@property (strong, nonatomic) Species * species;

- (void) pressedDatePickerView:(id)sender;
- (void) pressedPickerView:(id)sender;
- (IBAction)actButtonBack:(id)sender;
- (IBAction)actDoneDatePicker:(id)sender;
- (IBAction)actDonePicker:(id)sender;
- (void)actDidOnToExitSeen:(UITextField *)sender;
- (void)actDidOnToExitHarvested:(UITextField *)sender;
- (void)actSelectStar:(UIButton *)sender;
@end

@implementation NewLog2ViewController
@synthesize footer = _footer;


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
    header = [[NSArray alloc]initWithObjects:@"header", nil];
    footer = [[NSArray alloc]initWithObjects:@"footer", nil];

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
    timeFormatter = [[NSDateFormatter alloc]init];
    [timeFormatter setDateFormat:@"hh:mm:ss"];
    
    
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
    activityDetails = [[NSMutableArray alloc]init];
    activity = [[Activity alloc]init];
    dates = [NSDate date];
}


#pragma mark Table delegate metods
//------------------------------------------------
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = 0;
    switch (section) {
        case 0:
            count = 1;
            break;
        case 1:
            count = [listOfSpecies count];
            break;
        case 2:
            count = 1;
            break;
    }
    return count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NorthernPikeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NorthernPikeCell"];
    if (indexPath.section == 0 && indexPath.row == 0) {
            [cell.contentView addSubview:self.headerView];
        } else if (indexPath.section == 2 && indexPath.row == 0)
        {
            [cell.contentView addSubview:self.footer];
        } else if (indexPath.section == INDEX_SPECIES_LIST) {
        [cell.tfSeen addTarget:self action:@selector(actDidOnToExitSeen:) forControlEvents:UIControlEventEditingDidEndOnExit];
        cell.tfSeen.tag = indexPath.row;
        [cell.tfHarvested addTarget:self action:@selector(actDidOnToExitHarvested:) forControlEvents:UIControlEventEditingDidEndOnExit];
        cell.tfHarvested.tag = indexPath.row;
        cell.img.image = ((Species *)[listOfSpecies objectAtIndex:indexPath.row]).photo;
        [cell.btnLevel addTarget:self action:@selector(actSelectStar:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnLevel.tag = indexPath.row;
    }
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        if (indexPath.section == 0) {
            return self.headerView.frame.size.height;
        } else if (indexPath.section == 2)
            {
                return self.footer.frame.size.height;
            }
    
    return 70;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == INDEX_SPECIES_LIST)  {
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
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1 && [listOfSpecies firstObject] != nil) {
        return self.infoView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1 && [listOfSpecies firstObject] != nil) {
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
                [self.btnDate setTitle:[dateFormatter stringFromDate:self.huntDate] forState:UIControlStateNormal];
            }
            break;
            
        case 2:
             {
                self.huntStartTime = self.datePicker.date;
                [self.btnStartTime setTitle:[timeFormatter stringFromDate:self.huntStartTime] forState:UIControlStateNormal];
            }
            break;
            
        case 3:
            if ([[self.huntStartTime laterDate:self.datePicker.date] isEqualToDate:self.datePicker.date]) {
                self.huntEndTime = self.datePicker.date;
                [self.btnEndTime setTitle:[timeFormatter stringFromDate:self.huntEndTime] forState:UIControlStateNormal];
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
                [self.btnDate setTitle:[dateFormatter stringFromDate:self.huntDate] forState:UIControlStateNormal];
            } else {
                self.huntDate = [NSDate date];
                [self.btnDate setTitle:[dateFormatter stringFromDate:self.huntDate] forState:UIControlStateNormal];
            }
            break;
            
        case 2:
            if ([[dates laterDate:self.datePicker.date] isEqualToDate:self.datePicker.date]) {
                self.huntStartTime = self.datePicker.date;
                [self.btnStartTime setTitle:[timeFormatter stringFromDate:self.huntStartTime] forState:UIControlStateNormal];
            }
            break;
            
        case 3:
            if ([[[NSDate date] laterDate:self.datePicker.date] isEqualToDate:self.datePicker.date] && [[self.huntStartTime laterDate:self.datePicker.date] isEqualToDate:self.datePicker.date]) {
                self.huntEndTime = self.datePicker.date;
                [self.btnEndTime setTitle:[timeFormatter stringFromDate:self.huntEndTime] forState:UIControlStateNormal];
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
    NSMutableArray * array = listOfSpecies.mutableCopy;
    [array removeObjectAtIndex:0];
    [array removeLastObject];
    activity.startTime = [timeFormatter stringFromDate:self.huntStartTime];
    activity.endTime = [timeFormatter stringFromDate:self.huntEndTime];
    activity.date = [dateFormatter stringFromDate:self.huntDate];
    activity.location_id = self.location.locID;
//----------------------------------------------------------------------------------------------------
        dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(newQueue, ^(){
            
            [dataLoader createActivityWithActivityObject:activity andActivityDetails:activityDetails andSpeciesId:[self.species.specId integerValue]];
            
            dispatch_async(dispatch_get_main_queue(), ^(){
                
                if(!dataLoader.isCorrectRezult) {
                    NSLog(@"Error download sybSpecie");
                } else {
                    
                    NSDictionary * dict = [[NSDictionary alloc]initWithObjectsAndKeys:array, @"specie", self.huntStartTime, @"startTime", self.huntEndTime, @"endTime", nil];
                    LogDetailViewController * ldvc = [[LogDetailViewController alloc]initWithNibName:@"LogDetailViewController" bundle:nil andProperty:dict];
                    [self.navigationController pushViewController:ldvc animated:YES];

                }
            });
        });
//---------------------------------------------------------------------------------------
        }
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
    self.datePicker.minimumDate = [NSDate date];
    [self.view addSubview:self.datePickerView];
}

- (IBAction)actStartTime:(id)sender {
    self.datePicker.tag = 2;
    self.datePicker.datePickerMode = UIDatePickerModeTime;
    self.datePicker.date = [NSDate date];
    self.datePicker.minimumDate = [NSDate date];
    [self.view addSubview:self.datePickerView];
}

- (IBAction)actEndTime:(id)sender {
    self.datePicker.tag = 3;
    self.datePicker.datePickerMode = UIDatePickerModeTime;
    self.datePicker.date = [NSDate date];
    self.datePicker.minimumDate = self.huntStartTime;
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
        self.northernPike = nil;
        [self.table reloadData];
        ActivityDetails * details = [[ActivityDetails alloc]init];
        details.subspecies_id = [self.northernPike.specId intValue];
        [activityDetails addObject:details];
    }
}

#pragma mark metods location delegate

- (void)selectLocation:(Location*)location
{
    self.location = location;
    [self.btnLocation setTitle:self.location.locName forState:UIControlStateNormal];
}

- (void)actDidOnToExitSeen:(UITextField *)sender
{
    [self resignFirstResponder];
    ((ActivityDetails *)[activityDetails objectAtIndex:sender.tag]).seen = [sender.text intValue];
}

- (void)actDidOnToExitHarvested:(UITextField *)sender
{
    [self resignFirstResponder];
    ((ActivityDetails *)[activityDetails objectAtIndex:sender.tag]).harvested = [sender.text intValue];
}

- (void)actSelectStar:(UIButton *)sender
{
    CGRect  bounds = self.viewStars.frame;
    bounds.origin.y = self.view.center.y;
    self.viewStars.frame = bounds;
    self.viewStars.tag = sender.tag;
    for (UIButton * btn in self.viewStars.subviews) {
        if (btn.tag <= ((ActivityDetails *)[activityDetails objectAtIndex:sender.tag]).activitylevel) {
            btn.backgroundColor = [UIColor yellowColor];
        } else {
            btn.backgroundColor = [UIColor clearColor];
        }
    }
    self.viewStars.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.viewStars];
    
    
}

- (IBAction)actNumberSelectStar:(UIButton *)sender
{
    ((ActivityDetails *)[activityDetails objectAtIndex:self.viewStars.tag]).activitylevel = sender.tag;
    for (UIButton * btn in self.viewStars.subviews) {
        if (btn.tag<=sender.tag) {
            btn.backgroundColor = [UIColor yellowColor];
        } else {
            btn.backgroundColor = [UIColor clearColor];
        }
    }
    [UIView animateWithDuration:1.0f animations:^{
        self.viewStars.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.viewStars removeFromSuperview];
    }];
    self.viewStars.alpha = 1.0f;
}

@end
