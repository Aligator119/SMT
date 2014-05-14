#import "LogDetail2ViewController.h"
#import "PhotoVideoViewController.h"

@interface LogDetail2ViewController ()
{
    NSDictionary * dictionary;
    NSDateFormatter * dateFormatter;
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
    self.picker.minimumDate = [dictionary objectForKey:@"startTime"];
    self.picker.maximumDate = [dictionary objectForKey:@"endTime"];
    self.lbName.text = [dictionary objectForKey:@"name"];
    // Do any additional setup after loading the view from its nib.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        self.navigationBarHeightConstr.constant -= 20;
        self.navigationBarVerticalConstr.constant -=20;
    }
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"h:mm a"];
    
    self.btnSelectTime.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //self.imgUser.backgroundColor = [UIColor greenColor];
    
    UITapGestureRecognizer * imageRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setImageView:)];
    [imageRecognizer setNumberOfTapsRequired:1];
    [imageRecognizer setDelegate:self];
    
    [self.imgUser addGestureRecognizer:imageRecognizer];


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
}
- (IBAction)actCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actDonePicker:(id)sender {
    [self.pickerView removeFromSuperview];
    [self.btnSelectTime setTitle:[dateFormatter stringFromDate:self.picker.date] forState:UIControlStateNormal];
    //[self.btnSelectTime setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void) setImageView:(id)sender
{
    PhotoVideoViewController * pvvc = [[PhotoVideoViewController alloc]initWithNibName:@"PhotoVideoViewController" bundle:nil];
    [self.navigationController pushViewController:pvvc animated:YES];
}

@end
