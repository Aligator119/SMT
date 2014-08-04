#import "PopUpMenu.h"

#define constraintHeigth 200

@interface PopUpMenu ()

@property (weak, nonatomic) IBOutlet UIView *popUp;

@property (weak, nonatomic) IBOutlet UITextField *tf1;
@property (weak, nonatomic) IBOutlet UITextField *tf2;
@property (weak, nonatomic) IBOutlet UIButton *btn;

- (void) searcheForLatitudeAndLongityde:(id)sender;

- (IBAction)actCloseKeyBoard:(id)sender;

@end

@implementation PopUpMenu

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        
    [self.btn addTarget:self action:@selector(searcheForLatitudeAndLongityde:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
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
- (IBAction)actCloseKeyBoard:(id)sender
{
    [self resignFirstResponder];
}


-(void) keyboardWasShown: (NSNotification*) notification{
    NSDictionary * info = [notification userInfo];
    CGSize keyboardSize = [self.view convertRect:[[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue] fromView:self.view.window].size;
    float emptyLocationToKey = self.view.frame.size.height - (constraintHeigth + self.popUp.frame.size.height);
    if (emptyLocationToKey < keyboardSize.height) {
        [UIView animateWithDuration:0.6 animations:^{
            CGRect bounds = self.popUp.frame;
            bounds.origin.y -= (keyboardSize.height - emptyLocationToKey);
            self.popUp.frame = bounds;
        }];
    }
}

-(void) keyboardWillBeHidden: (NSNotification*) notification{
    [UIView animateWithDuration:0.6 animations:^{
        CGRect bounds = self.popUp.frame;
        bounds.origin.y = constraintHeigth;
        self.popUp.frame = bounds;
    }];    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
