#import "FirstViewController.h"
#import "DataLoader.h"
#import "SettingsViewController.h"
#import "PhotoVideoViewController.h"
#import "PredictionViewController.h"
#import "BuddyListViewController.h"
#import "WeatherViewController.h"
#import "UIViewController+LoaderCategory.h"
#import "Photo.h"
#import "LogHistoryViewController.h"

#define USER_DATA @"userdata"

@interface FirstViewController ()
{
    BOOL isSettings;
    FlyoutMenuViewController * fmVC;
    MapViewController * mapVC;
    CameraViewController * cVC;
    NewLog1ViewController * nl1VC;
    int activeTag;
    UIViewController * currentController;
    NSArray * menuItems;
    NSDictionary *functionsDictionary;
    DataLoader * dataLoader;
    AppDelegate * appDelegate;
}
@property (strong, nonatomic) IBOutlet UIImageView *imgUser;
@property (strong, nonatomic) IBOutlet UILabel *lbNameUser;
@property (strong, nonatomic) IBOutlet UILabel *lbNameLocation;
@property (strong, nonatomic) IBOutlet UILabel *lbStatus;
@property (strong, nonatomic) IBOutlet UITableView *table;
- (IBAction)actCloseSetting:(id)sender;
- (void)deselectSettingButton;
- (void)selectSettingButton;
- (NSString *) getImageName:(int)tag;
- (void)photoClick:(id)notification;
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
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    isSettings = NO;
    dataLoader = [DataLoader instance];
    self.lbNameUser.text = [NSString stringWithFormat:@"%@ %@", appDelegate.user.userFirstName, appDelegate.user.userSecondName];
    self.lbNameLocation.text = @"";
    self.lbStatus.text = @"";
    self.imgUser.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:appDelegate.user.avatarAdress]]];
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        //[dataLoader get];
        dispatch_async(dispatch_get_main_queue(),^(){
            
        });
    });
    
//-------------------------------------------------------------------------------------------------------------------------
    menuItems = [[NSArray alloc]initWithObjects:@"Log History", @"Prediction", @"Weather", @"Buddies", @"Camera/Photos", /*@"Messages",*/ @"Settings", nil];
    
    NSArray *functionsArrayIdentifiers = [[NSArray alloc] initWithObjects:@"openLogHistory", @"openPrediction", @"openWeather", @"openBuddies", @"openCameraAndPhotos", /*@"openMessages",*/ @"openSettings", nil];
    
    NSArray *iconsArray = [NSArray arrayWithObjects:@"calendar", @"prediction", @"weather", @"buddies", @"camera", /*@"messages",*/ @"settings", nil];
    
    functionsDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:functionsArrayIdentifiers, @"identifiers", menuItems, @"strings", iconsArray, @"icons", nil];
//----------------------------------------------------------------------------------------------------------------
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoClick:)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setDelegate:self];
    [self.imgUser addGestureRecognizer:recognizer];
    
    [self AddActivityIndicator:[UIColor redColor] forView:self.view];
}

- (void) viewWillAppear:(BOOL)animated
{
    fmVC = [FlyoutMenuViewController new];
    fmVC.view.frame = self.view.frame;
    fmVC.tabBar.delegate = self;
    [fmVC viewWillAppear:YES];
    [fmVC viewDidAppear:YES];
    
    
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
    
    if (!currentController) {
        [self.view addSubview:fmVC.view];
        currentController = fmVC;
        _current = fmVC.view;
        activeTag = 1;
    }

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"newCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newCell"];
    }
    cell.textLabel.text = [[functionsDictionary objectForKey:@"strings"] objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[[functionsDictionary objectForKey:@"icons"] objectAtIndex:indexPath.row]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSelector:NSSelectorFromString([[functionsDictionary objectForKey:@"identifiers"] objectAtIndex:indexPath.row])];
}

//------------------------------------------------------------------------------------------------------------------------
-(void)openSettings
{
    [self.navigationController pushViewController:[SettingsViewController new] animated:YES];
}

- (void)openCameraAndPhotos
{
    PhotoVideoViewController * pvvc = [[PhotoVideoViewController alloc]initWithNibName:@"PhotoVideoViewController" bundle:nil];
    [self.navigationController pushViewController:pvvc animated:YES];
}

- (void)openBuddies
{
    [self.navigationController pushViewController:[[BuddyListViewController alloc]init] animated:YES];
}

- (void)openPrediction
{
    [self.navigationController pushViewController:[[PredictionViewController alloc]init] animated:YES];
}

- (void)openWeather
{
    [self.navigationController pushViewController:[[WeatherViewController alloc]init] animated:YES];
}


- (void)openLogHistory
{
LogHistoryViewController * lhvc = [[LogHistoryViewController alloc]initWithNibName:@"LogHistoryViewController" bundle:nil];
[self.navigationController pushViewController:lhvc animated:YES];
}

- (void)openMessages
{
    //message
}


//-------------------------------------------------------------------------------------------------------------------------
- (void)selectController:(int)tag
{
    [fmVC setIsPresent:NO];
    [mapVC setIsPresent:NO];
    [nl1VC setIsPresent:NO];
    switch (tag) {
        case 1:
        {
            [_current removeFromSuperview];
            if (![self.childViewControllers containsObject:fmVC]) {
                [self addChildViewController:fmVC];
            }
            [self.view addSubview:fmVC.view];
            _current = fmVC.view;
            [fmVC setIsPresent:YES];
            activeTag = tag;
        }
            break;
        case 2:
        {
            [_current removeFromSuperview];
            if (![self.childViewControllers containsObject:mapVC]) {
                [self addChildViewController:mapVC];
            }
            [self.view addSubview:mapVC.view];
            _current = mapVC.view;
            [mapVC setIsPresent:YES];
            activeTag = tag;
        }
            break;
        case 3:
        {
            [_current removeFromSuperview];
            if (![self.childViewControllers containsObject:cVC]) {
                [self addChildViewController:cVC];
            }
            [self.view addSubview:cVC.view];
            _current = cVC.view;
            activeTag = tag;
        }
            break;
        case 4:
        {
            [_current removeFromSuperview];
            if (![self.childViewControllers containsObject:nl1VC]) {
                [self addChildViewController:nl1VC];
            }
            [self.view addSubview:nl1VC.view];
            _current = nl1VC.view;
            [nl1VC setIsPresent:YES];
            activeTag = tag;
        }
            break;
        case 5:
        {
            if (!isSettings) {
                [self selectSettingButton];
            } else{
                [self deselectSettingButton];            }
            [self showSettings];
            isSettings = !isSettings;
            
        }
            break;
    }
}


- (void)showSettings
{
    if (!isSettings) {
        [UIView animateWithDuration:0.5f animations:^{
            CGRect bounds = _current.frame;
            bounds.origin.x -= 250.0;
           _current.frame = bounds;
        }];
    } else {
        [UIView animateWithDuration:0.5f animations:^{
            CGRect bounds = _current.frame;
            bounds.origin.x += 250.0;
            _current.frame = bounds;
        }];
    }
    
}



- (IBAction)actCloseSetting:(id)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_DATA];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [((AppDelegate *)[UIApplication sharedApplication].delegate).listLocations removeAllObjects];
    [((AppDelegate *)[UIApplication sharedApplication].delegate).speciesList removeAllObjects];
    ((AppDelegate *)[UIApplication sharedApplication].delegate).defaultLocation = nil;
    [((AppDelegate *)[UIApplication sharedApplication].delegate).listUserBuddies removeAllObjects];
    ((AppDelegate *)[UIApplication sharedApplication].delegate).wheatherPredictList = nil;
    [((AppDelegate *)[UIApplication sharedApplication].delegate).pred removeAllObjects];
    NSString * nibName = [AppDelegate nibNameForBaseName:@"LoginViewController"];
    LoginViewController * lvc = [[LoginViewController alloc]initWithNibName:nibName bundle:nil];
    [self.navigationController pushViewController:lvc animated:YES];
}

- (void) selectSettingButton
{
    if (activeTag == 1) {
        for (UIView * obj in _current.subviews)
        {
            for (UIView * vie in obj.subviews) {
                if ([vie isKindOfClass:[CustomTabBar class]]) {
                    [((UIButton *)[obj viewWithTag:5]) setBackgroundImage:[UIImage imageNamed:@"st_icon_press.png"] forState:UIControlStateNormal];
                }
            }
        }
    } else {
        for (UIView * obj in _current.subviews)
        {
            if ([obj isKindOfClass:[CustomTabBar class]]) {
                [((UIButton *)[obj viewWithTag:5]) setBackgroundImage:[UIImage imageNamed:@"st_icon_press.png"] forState:UIControlStateNormal];
            }
        }
    }
}

- (void) deselectSettingButton
{
    if (activeTag == 1) {
        for (UIView * obj in _current.subviews)
        {
            for (UIView * vie in obj.subviews) {
                if ([vie isKindOfClass:[CustomTabBar class]]) {
                    [((UIButton *)[obj viewWithTag:5]) setBackgroundImage:[UIImage imageNamed:@"st_icon.png"] forState:UIControlStateNormal];
                    [((UIButton *)[obj viewWithTag:activeTag]) setBackgroundImage:[UIImage imageNamed:[self getImageName:activeTag]] forState:UIControlStateNormal];
                }
            }
        }
    } else {
        for (UIView * obj in _current.subviews)
        {
            if ([obj isKindOfClass:[CustomTabBar class]]) {
                [((UIButton *)[obj viewWithTag:5]) setBackgroundImage:[UIImage imageNamed:@"st_icon.png"] forState:UIControlStateNormal];
                [((UIButton *)[obj viewWithTag:activeTag]) setBackgroundImage:[UIImage imageNamed:[self getImageName:activeTag]] forState:UIControlStateNormal];
            }
        }
    }
}

- (NSString *)getImageName:(int)tag
{
    NSString * name;
    switch (tag) {
        case 1:
            name = @"home_icon_press.png";
            break;
        case 2:
            name = @"global_icon_press.png";
            break;
        case 3:
            name = @"Camera_icon_press.png";
            break;
        case 4:
            name = @"note_icon_press.png";
            break;
    }
    return name;
}

//--------- set photo-------------------------------------------------------------------------------------
- (void) photoClick:notification
{
    PhotoVideoViewController * pvvc = [PhotoVideoViewController new];
    pvvc.delegate = self;
    [self.navigationController pushViewController:pvvc animated:YES];
}


- (void)selectPhoto:(Photo *)photo
{
    [self startLoader];
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photo.fullPhoto]]];
        //NSString * str =
        [dataLoader setUserAvatar:image];
        
        dispatch_async(dispatch_get_main_queue(),^(){
            
            if(!dataLoader.isCorrectRezult) {
                NSLog(@"Error upload avatar");
                [self endLoader];
            } else {
                self.imgUser.image = image;
                [self endLoader];
            }
            
        });
    });
}


@end
