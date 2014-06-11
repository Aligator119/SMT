#import "LogDetail2ViewController.h"

#define Origin_Y 140.0
#define LeftPointsTAG   1313
#define RigthPointsTAG  1212
#define SumTAG          666

@interface LogDetail2ViewController ()
{
    NSDictionary * dictionary;
    NSDateFormatter * dateFormatter;
    NSDateFormatter * displayFormatter;
    NSIndexPath * index;
    DataLoader * dataLoader;
    BOOL addTrophy;
    NSString * photo_id;
    NSString * details;
    NSString * hurvester;
    NSDictionary * harvestrows;
    NSDictionary * sightings;
    NSArray * killingQuestion;
    NSArray * bufArray;
    NSString * selectedIthem;
    NSArray * killingID;
    NSMutableArray * result;
}
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *hiegth;
- (void) setImageView:(id)sender;
- (void) actChangeValue:(CustomTextField *)sender;
@end

@implementation LogDetail2ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andData:(NSDictionary *)dict
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dictionary = dict;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    photo_id = nil;
    details = @"";
    self.lbName.text = [dictionary objectForKey:@"name"];
    index = [[NSIndexPath alloc]init];
    index = [dictionary objectForKey:@"index"];
    harvestrows = [dictionary objectForKey:@"harvestrows"];
    sightings = [dictionary objectForKey:@"sightings"];
    killingQuestion = [dictionary objectForKey:@"killingQuestion"];
    // Do any additional setup after loading the view from its nib.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        self.navigationBarHeightConstr.constant -= 20;
        self.navigationBarVerticalConstr.constant -=20;
    }
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"h:mm a"];
    displayFormatter = [[NSDateFormatter alloc]init];
    [displayFormatter setDateFormat:@"hh:mm"];
    
    //self.btnSelectTime.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //self.imgUser.backgroundColor = [UIColor greenColor];
    
    UITapGestureRecognizer * imageRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setImageView:)];
    [imageRecognizer setNumberOfTapsRequired:1];
    [imageRecognizer setDelegate:self];
    
    [self.imgUser addGestureRecognizer:imageRecognizer];
    
    dataLoader = [DataLoader instance];
    addTrophy = NO;
    killingID = [sightings objectForKey:@"killing"];
//-----------------------------------------------------------------------------------------------------------------------
    int tf_tag  = 100;
    int btn_tag = 1000;
    int numberOfView = 0;
    result = [[NSMutableArray alloc] init];
    for (NSDictionary * dict in killingQuestion) {
        if ([[dict objectForKey:@"type"] isEqualToString: @"text"]) {
            float y = Origin_Y + (numberOfView * 40.0);
            CustomTextField * tf = [[CustomTextField alloc]initWithFrame:CGRectMake(30.0, y, 260.0, 30.0)];
            tf.backgroundColor= [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
            [tf setWithKillingDictionary:dict];
            tf.delegate = self;
            tf.tag = tf_tag;
            tf_tag++;
            if ([[dict objectForKey:@"killingquestion"] isEqualToString:@"Left Points"]) {
                tf.tag = LeftPointsTAG;
                [tf addTarget:self action:@selector(actChangeValue:) forControlEvents:UIControlEventEditingChanged];
            }
            if ([[dict objectForKey:@"killingquestion"] isEqualToString:@"Right Points"]) {
                [tf addTarget:self action:@selector(actChangeValue:) forControlEvents:UIControlEventEditingChanged];
                tf.tag = RigthPointsTAG;
            }

            numberOfView++;
            [result addObject:tf];
            [self.view addSubview:tf];
        }
        if ([[dict objectForKey:@"type"] isEqualToString: @"menu"]) {
            float y = Origin_Y + (numberOfView * 40.0);
            CustomButton * btn = [[CustomButton alloc]initWithFrame:CGRectMake(30.0, y, 260.0, 30.0)];
            btn.backgroundColor= [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
            btn.delegate = self;
            btn.tag = btn_tag;
            btn_tag++;
            numberOfView++;
            [self.view addSubview:btn];
            [result addObject:btn];
            [btn setButtonWithKillingDictionary:dict];
        }
        if ([[dict objectForKey:@"type"] isEqualToString: @"sum"]) {
            float y = Origin_Y + (numberOfView * 40.0);
            CustomTextField * tf = [[CustomTextField alloc]initWithFrame:CGRectMake(30.0, y, 260.0, 30.0)];
            tf.backgroundColor= [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
            tf.userInteractionEnabled = NO;
            tf.delegate = self;
            tf.tag = 666;
            tf_tag++;
            numberOfView++;
            [result addObject:tf];
            [self.view addSubview:tf];
        }

    }
    self.hiegth.constant += (numberOfView * 40.0);
}


#pragma mark picker metods delegate

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return bufArray.count;
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [bufArray objectAtIndex:row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedIthem = [bufArray objectAtIndex:row];
}

//---------------------------------------------------------------------------------------------------------------


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) actChangeValue:(CustomTextField *)sender
{
    NSString * str1 = ((CustomTextField *)[self.view viewWithTag:LeftPointsTAG]).text;
    NSString * str2 = ((CustomTextField *)[self.view viewWithTag:RigthPointsTAG]).text;
    ((CustomTextField *)[self.view viewWithTag:SumTAG]).text = [NSString stringWithFormat:@"%d",((str1 ?[str1 intValue] : 0) + (str2 ?[str2 intValue] : 0))];
}

- (IBAction)actBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actSelectTime:(id)sender {
    [self.view addSubview:self.pickerView];
}

- (IBAction)actDidEndOnExit:(id)sender {
    [self resignFirstResponder];
}

- (IBAction)actSaveDetail:(id)sender {
    NSString * trophy = [NSString stringWithFormat:@"%i",addTrophy];
    int numberKilling = 0;
    NSMutableArray * killObject = [[NSMutableArray alloc]init];
    for (id obj in result) {
        if ([obj isKindOfClass:[CustomButton class]]) {
            [killObject addObject:@{@"id": [[killingID objectAtIndex:numberKilling] objectForKey:@"id"],
                                    @"killingText" : [((CustomButton *)obj) getSelectedIthem] ? [((CustomButton *)obj) getSelectedIthem] : @""}];
        } else {
            [killObject addObject:@{@"id": [[killingID objectAtIndex:numberKilling] objectForKey:@"id"],
                                    @"killingText" : [((CustomTextField *)obj) getText] ? [((CustomTextField *)obj) getText] : @"" }];
        }
        numberKilling++;
    }
    NSDictionary * dict = [[NSDictionary alloc]initWithObjectsAndKeys:[sightings objectForKey:@"id"], @"id", details, @"details", killObject, @"killing", trophy, @"trophy", 0, @"harvested", photo_id, @"photo_id", nil];
//----------------------------------------------------------------------------------------------------
        dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(newQueue, ^(){

            [dataLoader updateLogDetailWithId:[NSString stringWithFormat:@"%@",[harvestrows objectForKey:@"id"]] andSighting:dict];

           dispatch_async(dispatch_get_main_queue(), ^(){

                if(!dataLoader.isCorrectRezult) {
                    NSLog(@"Error saved detail log");
                } else {
                    
    for (id controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[LogDetailViewController class]]) {
            ((LogDetailViewController *)controller).index = index;
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
                }
            });
        });
}

- (IBAction)actCancel:(id)sender {
    for (id controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[LogDetailViewController class]]) {
            ((LogDetailViewController *)controller).index = nil;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actDonePicker:(id)sender {
    if ([[self.view viewWithTag:self.picker.tag] isKindOfClass:[CustomButton class]]) {
        [((CustomButton *)[self.view viewWithTag:self.picker.tag]) setSelectedIthem:selectedIthem];
        [self.pickerView removeFromSuperview];
    }
}

- (IBAction)actCancelPicker:(id)sender {
    [self.pickerView removeFromSuperview];
}

- (void)openPickerWithData:(NSArray *)array andTag:(int)tag
{
    bufArray = [[NSArray alloc]initWithArray:array];
    selectedIthem = [bufArray firstObject];
    self.picker.tag = tag;
    [self.picker selectRow:0 inComponent:0 animated:YES];
    [self.picker reloadAllComponents];
    [self.view addSubview:self.pickerView];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (void) setImageView:(id)sender
{
    PhotoVideoViewController * pvvc = [[PhotoVideoViewController alloc]initWithNibName:@"PhotoVideoViewController" bundle:nil];
    pvvc.delegate = self;
    [self.navigationController pushViewController:pvvc animated:YES];
}

- (void)selectPhoto:(Photo *)photo
{
    self.imgUser.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photo.thumbnail]]];
    photo_id = photo.photoID;
}

@end
