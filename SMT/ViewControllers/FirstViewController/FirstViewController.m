#import "FirstViewController.h"

@interface FirstViewController ()
{
    BOOL isSettings;
    UIView * current;
    FlyoutMenuViewController * fmVC;
    MapViewController * mapVC;
    CameraViewController * cVC;
    NewLog1ViewController * nl1VC;
}
@end

@implementation FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isSettings = NO;
    
    
}

- (void) viewWillAppear:(BOOL)animated
{
    fmVC = [FlyoutMenuViewController new];
    fmVC.view.frame = self.view.frame;
    fmVC.tabBar.delegate = self;
    [fmVC viewWillAppear:YES];
    [fmVC viewDidAppear:YES];
    [self.view addSubview:fmVC.view];
    current = fmVC.view;
    
    mapVC = [MapViewController new];
    mapVC.view.frame = self.view.frame;
    mapVC.tabBar.delegate = self;
    [mapVC viewWillAppear:YES];
    [mapVC viewDidAppear:YES];
    
    cVC = [CameraViewController new];
    cVC.view.frame = self.view.frame;
    cVC.tabBar.delegate = self;
    [cVC viewDidAppear:YES];
    
    nl1VC = [NewLog1ViewController new];
    nl1VC.view.frame = self.view.frame;
    nl1VC.tabBar.delegate = self;
    [nl1VC viewWillAppear:YES];
    [nl1VC viewDidAppear:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectController:(int)tag
{
    switch (tag) {
        case 1:
        {
            [current removeFromSuperview];
            [self.view addSubview:fmVC.view];
            current = fmVC.view;
            
        }
            break;
        case 2:
        {
            [current removeFromSuperview];
            [self.view addSubview:mapVC.view];
            current = mapVC.view;
        }
            break;
        case 3:
        {
            [current removeFromSuperview];
            [self.view addSubview:cVC.view];
            current = cVC.view;
        }
            break;
        case 4:
        {
            [current removeFromSuperview];
            [self.view addSubview:nl1VC.view];
            current = nl1VC.view;
        }
            break;
        case 5:
        {
            [self showSettings];
            
        }
            break;
    }
}


- (void)showSettings
{
    if (!isSettings) {
        [UIView animateWithDuration:0.5f animations:^{
            CGRect bounds = current.frame;
            bounds.origin.x -= 250.0;
           current.frame = bounds;
        }];
        isSettings = !isSettings;
    } else {
        [UIView animateWithDuration:1.0f animations:^{
            CGRect bounds = current.frame;
            bounds.origin.x += 250.0;
            current.frame = bounds;
        }];
        isSettings = !isSettings;
    }
}


@end
