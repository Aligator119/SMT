#import "LogDetail2ViewController.h"


@interface LogDetail2ViewController ()
{
    NSDictionary * dictionary;
    NSDateFormatter * dateFormatter;
    NSDateFormatter * displayFormatter;
    NSIndexPath * index;
    DataLoader * dataLoader;
    NSString * logID;
    BOOL addTrophy;
    NSString * photo_id;
    NSString * details;
    NSString * hurvester;
    NSDictionary * harvestrows;
    NSDictionary * sightings;
    NSDictionary * settingsDict;
}
- (void) setImageView:(id)sender;
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
    //self.picker.minimumDate = [dictionary objectForKey:@"startTime"];
    //self.picker.maximumDate = [dictionary objectForKey:@"endTime"];
    self.lbName.text = [dictionary objectForKey:@"name"];
    index = [[NSIndexPath alloc]init];
    index = [dictionary objectForKey:@"index"];
    logID = [dictionary objectForKey:@"id"];
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
    
    
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        
        settingsDict = [dataLoader getActivityWithId:[logID intValue]];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            if(!dataLoader.isCorrectRezult) {
                NSLog(@"Error download harvester");
            } else {
                int numSightings = 0;
                harvestrows = [[settingsDict objectForKey:@"harvestrows"] objectAtIndex:index.section];
                for (int i = 0; i<=index.section; i++) {
                    if (i == index.section) {
                        numSightings += index.row;
                    } else {
                        numSightings += [[((NSDictionary *)[[settingsDict objectForKey:@"harvestrows"] objectAtIndex:i]) objectForKey:@"seen"] intValue];
                    }
                }
                
                sightings   = [[settingsDict objectForKey:@"sightings"] objectAtIndex:numSightings];
            }
        });
    });

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSDictionary * dict = [[NSDictionary alloc]initWithObjectsAndKeys:[sightings objectForKey:@"id"], @"id",[displayFormatter stringFromDate:self.picker.date], @"time", trophy, @"trophy", nil, @"harvested", photo_id, @"photo_id", details, @"details", nil];
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
    [self.pickerView removeFromSuperview];
    [self.btnSelectTime setTitle:[dateFormatter stringFromDate:self.picker.date] forState:UIControlStateNormal];
    //[self.btnSelectTime setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (IBAction)actCancelPicker:(id)sender {
    [self.pickerView removeFromSuperview];
}

- (void) setImageView:(id)sender
{
    PhotoVideoViewController * pvvc = [[PhotoVideoViewController alloc]initWithNibName:@"PhotoVideoViewController" bundle:nil];
    pvvc.delegate = self;
    [self.navigationController pushViewController:pvvc animated:YES];
}

- (void)selectPhoto:(UIImage *)image
{
    self.imgUser.image = image;
}

@end
