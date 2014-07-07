#import "NewLog2ViewController.h"
#import "DataLoader.h"
#import "AppDelegate.h"
#import "LogDetailViewController.h"
#import "UIViewController+LoaderCategory.h"
#import "NorthernPikeCell.h"
#import "Activity.h"
#import "ActivityDetails.h"
#import "Location.h"
#import "MapViewController.h"



#define TAG 12345
#define HiegthView 130

#define startHiegth 66
#define constHiegth 40


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
    NSArray * questionsList;
    UITextField * callKeyBoard;
    int count;
    }
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constrainsADD;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constrainsNorthempike;
@property (strong, nonatomic) IBOutlet UIView *footer;
@property (strong, nonatomic) IBOutlet UIView *pickerView;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIView *datePickerView;
@property (strong, nonatomic) IBOutlet CustomButton *btnNorthempike;
@property (strong, nonatomic) IBOutlet UIView *header;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint * removeConstrain;

@property (strong, nonatomic) Species * species;

- (void) pressedDatePickerView:(id)sender;
- (void) pressedPickerView:(id)sender;
- (IBAction)actButtonBack:(id)sender;
- (IBAction)actDoneDatePicker:(id)sender;
- (IBAction)actSavePicker:(id)sender;
- (void)actDidOnToExitSeen:(UITextField *)sender;
- (void)actDidOnToExitHarvested:(UITextField *)sender;
- (void)actSelectStar:(UIButton *)sender;
- (void)keyboardDidShow: (NSNotification *) notif;
- (void)keyboardDidHide: (NSNotification *) notif;
- (BOOL) isiPad;
@end

@implementation NewLog2ViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andData:(NSDictionary *)dictionary
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.species = [dictionary objectForKey:@"species"];
        questionsList = [dictionary objectForKey:@"questions"];
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
    count = 0;
    
    listOfSpecies = [[NSMutableArray alloc]init];
    self.lbNavigationBar.text = self.species.name;
    //------------------------------------------------------------------------------
    
    self.selectedIthem = @"";
    self.btnNorthempike.delegate = self;
    
    UINib *cellNib = [UINib nibWithNibName:@"NorthernPikeCell" bundle:[NSBundle mainBundle]];
    [self.table registerNib:cellNib forCellReuseIdentifier:@"NorthernPikeCell"];
    
    
    
    
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
    
    [self.view removeConstraint:self.removeConstrain];
    
    UITapGestureRecognizer *datePickerViewRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedDatePickerView:)];
    [datePickerViewRecognizer setNumberOfTapsRequired:1];
    [datePickerViewRecognizer setDelegate:self];
    
    [self.datePickerView addGestureRecognizer:datePickerViewRecognizer];
    
    UITapGestureRecognizer * pickerViewRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedPickerView:)];
    [pickerViewRecognizer setNumberOfTapsRequired:1];
    [pickerViewRecognizer setDelegate:self];
    
    [self.pickerView addGestureRecognizer:pickerViewRecognizer];
    
    [self.datePickerView setBackgroundColor:[UIColor colorWithRed:0.99 green:0.99 blue:0.99 alpha:0.7]];
    
    
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
    
//-------------------------------------------------------------
    int btn_tag = 1000;
    int tf_tag  = 10000;
    self.header.autoresizesSubviews = NO;
    for (NSDictionary * dict in questionsList) {
        if ([[dict objectForKey:@"inputType"] isEqualToString:@"menu"]) {
            CGPoint point = self.header.frame.origin;
            if ([self isiPad]) {
                point.y += startHiegth + (constHiegth * count);
            } else {
                point.y += self.header.frame.size.height;
                point.x += self.header.frame.size.width;
            }
            CustomButton * btn = [[CustomButton alloc]initWithFrame:CGRectMake(30.0, point.y, 260.0, 30.0)];
            btn.backgroundColor= [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
            btn.delegate = self;
            btn.tag = btn_tag;
            btn_tag++;
            [self.header addSubview:btn];
            
            [btn setWithInputDictionary:dict];
            count++;
            if (![self isiPad]) {
            [self.header setFrame:CGRectMake(self.header.frame.origin.x, self.header.frame.origin.y, self.header.frame.size.width, self.header.frame.size.height + 40.0)];
            }
        } else {
            CGPoint point = self.header.frame.origin;
            if ([self isiPad]) {
                point.y += startHiegth + (constHiegth * count);
            } else {
                point.y += self.header.frame.size.height;
                point.x += self.header.frame.size.width;
            }
            CustomTextField * tf = [[CustomTextField alloc]initWithFrame:CGRectMake(30.0, point.y, 260.0, 30.0)];
            tf.backgroundColor= [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
            [tf setWithInputDictionary:dict];
            tf.delegate = self;
            tf.tag = tf_tag;
            tf_tag++;
            [self.header addSubview:tf];
            count++;
            if ([self isiPad]) {
            CGRect bounds = self.header.frame;
            bounds.size.height += 40.0;
            self.header.frame = bounds;
            }
        }
    
    }
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//set first location
    [dataLoader getLocationsAssociatedWithUser];
    if (!appDelegate.listLocations.count) {
        [[[UIAlertView alloc]initWithTitle:@"Warning" message:@"No added location" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Add location", nil] show ];
    } else {
        self.location = [appDelegate.listLocations objectAtIndex:0];
        [self.btnLocation setTitle:self.location.locName forState:UIControlStateNormal];
    }
//set current date
    self.huntDate = [NSDate date];
    [self.btnDate setTitle:[btnDateFormatter stringFromDate:self.huntDate] forState:UIControlStateNormal];
//set start time with current date
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents * components = [gregorianCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
    components.hour -= 3;
    self.huntStartTime = [gregorianCalendar dateFromComponents:components];
    [self.btnStartTime setTitle:[btnTimeFormatter stringFromDate:self.huntStartTime] forState:UIControlStateNormal];
//set end time with current date
    self.huntEndTime = self.huntDate;
    [self.btnEndTime setTitle:[btnTimeFormatter stringFromDate:self.huntEndTime] forState:UIControlStateNormal];

    
}

- (void) viewWillAppear:(BOOL)animated
{   if ([self.northernPikeList firstObject] == nil && [listOfSpecies count] == 0) {
    [self startLoader];
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        
        self.northernPikeList = [[NSMutableArray alloc]initWithArray:[dataLoader getSubSpecies:[self.species.specId intValue]]];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            if(!dataLoader.isCorrectRezult) {
                NSLog(@"Error download sybSpecie");
            } else {
                for (Species * s in self.northernPikeList) {
                    if ([s.required intValue] == 1) {
                        [listOfSpecies addObject:s];
                        ActivityDetails * details = [[ActivityDetails alloc]init];
                        details.subspecies_id = [s.specId intValue];
                        [activityDetails addObject:details];
                    }
                }
                for (Species * rem in listOfSpecies) {
                    [self.northernPikeList removeObject:rem];
                }
                [self.btnNorthempike setInputArray:self.northernPikeList];
                //set northem pike first object
                self.northernPike = [self.northernPikeList firstObject];
                [self.btnNorthempike setSelectedSpecies:self.northernPike];
                [self.table reloadData];
                [self endLoader];
            }
        });
    });
    
    [self.view layoutIfNeeded];
    for (UIView * obj in self.header.subviews) {
        if ([obj isKindOfClass:[CustomTextField class]] || [obj isKindOfClass:[CustomButton class]]) {
            CGRect bounds = obj.frame;
            bounds.size.width = self.btnDate.frame.size.width;
            obj.frame = bounds;
        }
    }
    self.constrainsADD.constant = self.footer.frame.size.width * 0.25;
    self.constrainsNorthempike.constant = self.footer.frame.size.width * 0.55;
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
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
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
        [self.btnNorthempike addSpecie:buf];
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


#pragma mark picker metods delegate

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return questionsList.count;
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * str = @"";
    if ([[questionsList objectAtIndex:row] isKindOfClass:[Species class]]) {
        Species * spec = [questionsList objectAtIndex:row];
        str = spec.name;
    } else {
        str = [questionsList objectAtIndex:row];
    }
    return str;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.picker.tag == 55) {
        self.northernPike = [questionsList objectAtIndex:row];
    } else {
        self.selectedIthem = [questionsList objectAtIndex:row];
    }
}

//---------------------------------------------------------------------------------------------------------------

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
    if (self.picker.tag == 55) {
        [self.btnNorthempike setSelectedSpecies:self.northernPike];
    } else  {
        [((CustomButton *)[self.header viewWithTag:self.picker.tag]) setSelectedIthem:self.selectedIthem];
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

- (IBAction)actSavePicker:(id)sender {
    [self.pickerView removeFromSuperview];
    if (self.picker.tag == 55) {
        [self.btnNorthempike setSelectedSpecies:self.northernPike];
    } else {
        if ([[self.header viewWithTag:self.picker.tag] isKindOfClass:[CustomButton class]]) {
            [((CustomButton *)[self.header viewWithTag:self.picker.tag]) setSelectedIthem:self.selectedIthem];
        }
    }
}



- (IBAction)actFinalizeLog:(id)sender {
    if (self.location && self.huntDate && self.huntEndTime && self.huntStartTime) {
    activity.startTime = [timeFormatter stringFromDate:self.huntStartTime];
    activity.endTime = [timeFormatter stringFromDate:self.huntEndTime];
    activity.date = [dateFormatter stringFromDate:self.huntDate];
    activity.location_id = self.location.locID;
        NSMutableArray * speciesanswers = [[NSMutableArray alloc]init];
        for (id obj in self.header.subviews) {
            if ([obj isKindOfClass:[CustomButton class]]) {
                [speciesanswers addObject:@{@"￼speciesquestion_id" : [((CustomButton *)obj) getQuestion],
                                            @"answer"              : [((CustomButton *)obj) getSelectedIthem]}];
            } else if ([obj isKindOfClass:[CustomTextField class]]) {
                [speciesanswers addObject:@{@"￼speciesquestion_id" : [((CustomTextField *)obj) getQuestionID],
                                            @"answer"              : [((CustomTextField *)obj) getText]}];
            }
        }
//----------------------------------------------------------------------------------------------------
        dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(newQueue, ^(){
            
            logID = [dataLoader createActivityWithActivityObject:activity andActivityDetails:activityDetails andSpeciesId:[self.species.specId integerValue]];
            
            dispatch_async(dispatch_get_main_queue(), ^(){
                
                if(!dataLoader.isCorrectRezult) {
                    NSLog(@"Error download sybSpecie");
                } else {
        
                    NSDictionary * dict = [[NSDictionary alloc]initWithObjectsAndKeys:listOfSpecies, @"specie", activity, @"activity", activityDetails, @"activityDetails", logID, @"id", speciesanswers, @"speciesanswers", nil];
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
    [[[[((UIButton *) sender) superview] superview] superview] removeFromSuperview];
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


- (IBAction)actAdd:(id)sender {
    if (self.northernPike) {
        [self.btnNorthempike removeSelectIthem];
        [listOfSpecies addObject:self.northernPike];
        ActivityDetails * details = [[ActivityDetails alloc]init];
        details.subspecies_id = [self.northernPike.specId intValue];
        [activityDetails addObject:details];
        self.northernPike = [self.btnNorthempike getSelectedSpecie];
        [self.table reloadData];
        
    } else {
        [self.btnNorthempike setTitle:@"" forState:UIControlStateNormal];
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
    if (![sender isKindOfClass:[CustomTextField class]]) {
    ((ActivityDetails *)[activityDetails objectAtIndex:sender.tag]).seen = [sender.text intValue];
    }
}

- (void)actDidOnToExitHarvested:(UITextField *)sender
{
    if (![sender isKindOfClass:[CustomTextField class]]){
    if ([sender.text integerValue] <= ((ActivityDetails *)[activityDetails objectAtIndex:sender.tag]).seen) {
    ((ActivityDetails *)[activityDetails objectAtIndex:sender.tag]).harvested = [sender.text intValue];
    } else {
        ((ActivityDetails *)[activityDetails objectAtIndex:sender.tag]).harvested = ((ActivityDetails *)[activityDetails objectAtIndex:sender.tag]).seen;
        sender.text = [NSString stringWithFormat:@"%d", ((ActivityDetails *)[activityDetails objectAtIndex:sender.tag]).seen];
    }
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
    [textField selectAll:nil];
    callKeyBoard = textField;
}

- (void)keyboardDidShow: (NSNotification *) notif{
    NSDictionary * info = [notif userInfo];
    CGSize keyboardSize = [self.view convertRect:[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:self.view.window].size;
    if (![callKeyBoard isKindOfClass:[CustomTextField class]]) {
        self.table.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
        [self.table scrollRectToVisible:[self.table rectForRowAtIndexPath:path] animated:YES];
    } else {
        self.table.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
        [self.table scrollRectToVisible:self.header.frame  animated:YES];
    }
}

- (void)keyboardDidHide: (NSNotification *) notif{
    self.table.contentInset = UIEdgeInsetsZero;
}

- (void) openPickerWithData:(NSArray *)array andTag:(int)tag
{
    if (array.count) {
        if ([self isiPad]) {
            self.pickerView.frame = self.header.frame;
        }
    [self.view endEditing:YES];
    questionsList = [NSArray arrayWithArray:array];
    if ([[array firstObject] isKindOfClass:[Species class]]) {
        self.northernPike = [array firstObject];
    } else {
        self.selectedIthem = [array firstObject];
    }
    self.picker.tag = tag;
    [self.picker selectedRowInComponent:0];
    [self.picker reloadAllComponents];
    [self.view addSubview:self.pickerView];
    }
}

- (BOOL) isiPad
{
    NSString * model = [UIDevice currentDevice].model;
    return [model isEqualToString:@"iPad Simulator"] ? YES : NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        MapViewController * mvc = [[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
        [self.navigationController pushViewController:mvc animated:YES];
    }
}

@end
