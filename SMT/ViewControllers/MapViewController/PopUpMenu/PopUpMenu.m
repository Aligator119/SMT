#import "PopUpMenu.h"

@interface PopUpMenu ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraintTF1;
@property (weak, nonatomic) IBOutlet UIView *popUp;

@property (weak, nonatomic) IBOutlet UITextField *tf1;
@property (weak, nonatomic) IBOutlet UITextField *tf2;
@property (weak, nonatomic) IBOutlet UIButton *btn;

- (void) searcheForLatitudeAndLongityde:(id)sender;
@end

@implementation PopUpMenu

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        
    [self.btn addTarget:self action:@selector(searcheForLatitudeAndLongityde:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void) searcheForLatitudeAndLongityde:(id)sender
{
    float lat = [self.tf1.text floatValue];
    float lon = [self.tf2.text floatValue];
    id<SearchInMapDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(searcheLatitude:andLongitude:)]) {
        [delegate searcheLatitude:lat andLongitude:lon];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
