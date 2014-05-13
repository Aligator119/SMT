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


#define TAG 12345

#define COMPLETE_DATE_UNITS   NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond

@interface NewLog2ViewController ()
{
    NSMutableArray * listOfSpecies;
    int pickerType;
    NSDateFormatter * dateFormatter;
    NSDateFormatter * timeFormatter;
    AppDelegate * appDelegate;
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
    [listOfSpecies addObject:@"header"];
    [listOfSpecies addObject:@"footer"];
//------------------------------------------------------------------------------
    self.huntType =     @"";
    self.weapon =       @"";
    
    self.huntTypeList = [[NSArray alloc]initWithObjects:@"Drive", @"Stalking", nil];
    self.weaponList = [[NSArray alloc]initWithObjects:@"Rifle", nil];
    self.northernPikeList = [[NSMutableArray alloc]init];
    for (int i = 0; i<10; i++) {
        Species * buf = [[Species alloc]init];
        buf.name = [@"Nothern list" stringByAppendingString:[NSString stringWithFormat:@"%d",i]];
        [self.northernPikeList addObject:buf];
    }
    
    
    
    self.picker.delegate = self;
    
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMMM dd yyyy"];
    timeFormatter = [[NSDateFormatter alloc]init];
    [timeFormatter setDateFormat:@"h:mm:a"];

    
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
}



#pragma mark Table delegate metods
//------------------------------------------------
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listOfSpecies.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if ([[listOfSpecies objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]) {
        
        if ([[listOfSpecies objectAtIndex:indexPath.row] isEqualToString:@"header"]) {
            [cell.contentView addSubview:self.headerView];
        } else if ([[listOfSpecies objectAtIndex:indexPath.row] isEqualToString:@"footer"])
        {
            [cell.contentView addSubview:self.footer];
        }
    } else {
    cell.textLabel.text = ((Species *)[listOfSpecies objectAtIndex:indexPath.row]).name;
    }
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[listOfSpecies objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]) {
        if ([[listOfSpecies objectAtIndex:indexPath.row] isEqualToString:@"header"]) {
            return self.headerView.frame.size.height;
        } else if ([[listOfSpecies objectAtIndex:indexPath.row] isEqualToString:@"footer"])
       {
           return self.footer.frame.size.height;
       }
    }
    return 44;
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
    int num = 5;
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
    NSString * str = @"asdfghjkl;";
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
            if ([[[NSDate date] laterDate:self.datePicker.date] isEqualToDate:self.datePicker.date]) {
                self.huntDate = self.datePicker.date;
                [self.btnDate setTitle:[dateFormatter stringFromDate:self.huntDate] forState:UIControlStateNormal];
            } else {
                self.huntDate = [NSDate date];
                [self.btnDate setTitle:[dateFormatter stringFromDate:self.huntDate] forState:UIControlStateNormal];
            }
            break;
            
        case 2:
            if ([[[NSDate date] laterDate:self.datePicker.date] isEqualToDate:self.datePicker.date]) {
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

- (void) pressedPickerView:(id)sender
{
    [self.pickerView removeFromSuperview];
    if (pickerType == 1) {
        self.btnHuntType.titleLabel.text = self.huntType;
    } else if (pickerType == 2) {
        self.btnWeapon.titleLabel.text = self.weapon;
    } else if (pickerType == 3) {
        self.btnNorthernPike.titleLabel.text = self.northernPike.name ;
    }
}

- (IBAction)actDoneDatePicker:(id)sender {
    switch (self.datePicker.tag) {
        case 1:
            if ([[[NSDate date] laterDate:self.datePicker.date] isEqualToDate:self.datePicker.date]) {
            self.huntDate = self.datePicker.date;
            [self.btnDate setTitle:[dateFormatter stringFromDate:self.huntDate] forState:UIControlStateNormal];
            } else {
                self.huntDate = [NSDate date];
                [self.btnDate setTitle:[dateFormatter stringFromDate:self.huntDate] forState:UIControlStateNormal];
            }
            break;
            
        case 2:
            if ([[[NSDate date] laterDate:self.datePicker.date] isEqualToDate:self.datePicker.date]) {
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
    }
}


- (IBAction)actFinalizeLog:(id)sender {
    NSMutableArray * array = listOfSpecies.mutableCopy;
    [array removeObjectAtIndex:0];
    [array removeLastObject];
    NSDictionary * dict = [[NSDictionary alloc]initWithObjectsAndKeys:array, @"specie", self.huntStartTime, @"startTime", self.huntEndTime, @"endTime", nil];
    LogDetailViewController * ldvc = [[LogDetailViewController alloc]initWithNibName:@"LogDetailViewController" bundle:nil andProperty:dict];
    [self.navigationController pushViewController:ldvc animated:YES];
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
    [self.view addSubview:self.datePickerView];
}

- (IBAction)actStartTime:(id)sender {
    self.datePicker.tag = 2;
    self.datePicker.datePickerMode = UIDatePickerModeTime;
    self.datePicker.date = [NSDate date];
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
    pickerType = 3;
    [self.view addSubview:self.pickerView];
    [self.picker reloadAllComponents];
    self.northernPike = [self.northernPikeList firstObject];
}

- (IBAction)actAdd:(id)sender {
    if (self.northernPike) {
        [listOfSpecies removeObject:@"footer"];
        [self.northernPikeList removeObject:self.northernPike];
        self.btnNorthernPike.enabled = NO;
        [self.btnNorthernPike setTitle:@"Nothern Pike" forState:UIControlStateNormal];
        self.btnNorthernPike.enabled = YES;
        self.northernPike.seen = 1;
        self.northernPike.harvested = 3;
        [listOfSpecies addObject:self.northernPike];
        self.northernPike = nil;
        [listOfSpecies addObject:@"footer"];
        [self.table reloadData];
    }
}

#pragma mark metods location delegate

- (void)selectLocation:(Location*)location
{
    self.location = location;
    [self.btnLocation setTitle:self.location.locName forState:UIControlStateNormal];
}


@end
