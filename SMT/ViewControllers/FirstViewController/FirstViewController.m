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
#import "LocationListViewController.h"
#import "FlyoutMenuViewController.h"

#define USER_DATA @"userdata"

@interface FirstViewController ()
{
    BOOL isSettings;
    BOOL isiPad;
    int activeTag;
    UIViewController * currentController;
    NSArray * menuItems;
    NSDictionary *functionsDictionary;
    DataLoader * dataLoader;
    AppDelegate * appDelegate;
    MenuViewController * menuController;
}
@property (strong, nonatomic) IBOutlet UIImageView *imgUser;
@property (strong, nonatomic) IBOutlet UILabel *lbNameUser;
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftsSpace;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstr;


- (void)photoClick:(id)notification;
- (void)downloadSeasons;


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
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        self.topViewHeightConstr.constant -= 20;
    }
    isSettings = NO;
    dataLoader = [DataLoader instance];
    self.lbNameUser.text =  appDelegate.user.name;
    self.imgUser.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:appDelegate.user.avatarAdress]]];
    self.imgUser.layer.masksToBounds = YES;
    self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2;
    self.imgUser.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imgUser.layer.borderWidth = 1.0f;
//    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(newQueue, ^(){
//        //[dataLoader get];
//        dispatch_async(dispatch_get_main_queue(),^(){
//            
//        });
//    });
    
//-------------------------------------------------------------------------------------------------------------------------
    menuItems = [[NSArray alloc]initWithObjects:@"Home", @"Map Locations", @"Log an Activity", @"Log History", @"Camera/Photos", @"Prediction", @"Weather", @"Buddies", @"Settings", @"Log out", nil];
    
    NSArray *functionsArrayIdentifiers = [[NSArray alloc] initWithObjects:@"openHome", @"openMap", @"openLoagAnActivity", @"openLogHistory", @"openCameraAndPhotos", @"openPrediction", @"openWeather", @"openBuddies", @"openSettings", @"logout", nil];
    
    NSArray *iconsArray = [NSArray arrayWithObjects:@"home_icon", @"global_icon", @"note_icon", @"calendar", @"camera", @"prediction", @"weather", @"buddies", @"settings", @"logout", nil];
    
    functionsDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:functionsArrayIdentifiers, @"identifiers", menuItems, @"strings", iconsArray, @"icons", nil];
//----------------------------------------------------------------------------------------------------------------
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoClick:)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setDelegate:self];
    [self.imgUser addGestureRecognizer:recognizer];
    
    [self AddActivityIndicator:[UIColor grayColor] forView:self.table];
    
    //[dataLoader getLocationsAssociatedWithUser];
    //[dataLoader getPublicLocationWithID:nil name:nil page:0 limit:0 state_fips:0 county_fips:0];
    isiPad = NO;
    menuController = self.revealViewController;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    if (self.view.frame.size.width > 320.0) {
//        isiPad = YES;
//        self.leftsSpace.constant = self.view.frame.size.width * 0.38;
//        [self.view updateConstraintsIfNeeded];
//    }

//    //[self downloadSeasons];

}

+ (FirstViewController *)instance
{
    static FirstViewController * _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    });
    return _instance;
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
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.imageView.image = [UIImage imageNamed:[[functionsDictionary objectForKey:@"icons"] objectAtIndex:indexPath.row]];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSelector:NSSelectorFromString([[functionsDictionary objectForKey:@"identifiers"] objectAtIndex:indexPath.row])];
}

//------------------------------------------------------------------------------------------------------------------------

- (void) openHome
{
    [self startLoader];
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        FlyoutMenuViewController * flyputVC = [[FlyoutMenuViewController alloc]initWithNibName:@"FlyoutMenuViewController" bundle:nil];
        dispatch_async(dispatch_get_main_queue(), ^(){
            [menuController setFrontViewController:flyputVC animated:YES];    //sf
            [menuController setFrontViewPosition:FrontViewPositionLeft animated:YES];
            [self endLoader];
        });
    });
}

- (void) openMap
{
    [self startLoader];
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        LocationListViewController * mapVC = [[LocationListViewController alloc]initWithNibName:@"LocationListViewController" bundle:nil];
        dispatch_async(dispatch_get_main_queue(), ^(){
            [menuController setFrontViewController:mapVC animated:YES];    //sf
            [menuController setFrontViewPosition:FrontViewPositionLeft animated:YES];
            [self endLoader];
        });
    });
}

- (void) openLoagAnActivity
{
    [self startLoader];
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        NewLog1ViewController * nlvc = [[NewLog1ViewController alloc]initWithNibName:@"NewLog1ViewController" bundle:nil];
        dispatch_async(dispatch_get_main_queue(), ^(){
            [menuController setFrontViewController:nlvc animated:YES];    //sf
            [menuController setFrontViewPosition:FrontViewPositionLeft animated:YES];
            [self endLoader];
        });
    });
}

- (void)openLogHistory
{
    [self startLoader];
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        LogHistoryViewController * lhvc = [[LogHistoryViewController alloc]initWithNibName:@"LogHistoryViewController" bundle:nil];
        dispatch_async(dispatch_get_main_queue(), ^(){
            [menuController setFrontViewController:lhvc animated:YES];    //sf
            [menuController setFrontViewPosition:FrontViewPositionLeft animated:YES];
            [self endLoader];
        });
    });
}

- (void)openCameraAndPhotos
{
    [self startLoader];
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        PhotoVideoViewController * pvvc = [[PhotoVideoViewController alloc]initWithNibName:@"PhotoVideoViewController" bundle:nil];
        dispatch_async(dispatch_get_main_queue(), ^(){
            [menuController setFrontViewController:pvvc animated:YES];    //sf
            [menuController setFrontViewPosition:FrontViewPositionLeft animated:YES];
            [self endLoader];
        });
    });

}


- (void)openPrediction
{
    [self startLoader];
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        PredictionViewController * wVC = [PredictionViewController new];
        dispatch_async(dispatch_get_main_queue(), ^(){
            [menuController setFrontViewController:wVC animated:YES];    //sf
            [menuController setFrontViewPosition:FrontViewPositionLeft animated:YES];
            [self endLoader];
        });
    });
}

- (void)openWeather
{
    [self startLoader];
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        WeatherViewController * wVC = [[WeatherViewController alloc]initWithNibName:@"WeatherViewController" bundle:nil];
        dispatch_async(dispatch_get_main_queue(), ^(){
            [menuController setFrontViewController:wVC animated:YES];    //sf
            [menuController setFrontViewPosition:FrontViewPositionLeft animated:YES];
            [self endLoader];
        });
    });

}

- (void)openBuddies
{
    [self startLoader];
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        BuddyListViewController * blVC = [[BuddyListViewController alloc]initWithNibName:@"BuddyListViewController" bundle:nil];
        dispatch_async(dispatch_get_main_queue(), ^(){
            [menuController setFrontViewController:blVC animated:YES];    //sf
            [menuController setFrontViewPosition:FrontViewPositionLeft animated:YES];
            
            [self endLoader];
        });
    });
    
}


-(void)openSettings
{
    [menuController setFrontViewController:[SettingsViewController new] animated:YES];    //sf
    [menuController setFrontViewPosition:FrontViewPositionLeft animated:YES];
}

- (void)logout
{
    //logout
    NSLog(@"No added category \"logout\" on this project");
    //[self.navigationController pushViewController:[LocationListViewController new] animated:YES];
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


- (void) newUserAvatar:(UIImage *)avatar
{
    self.imgUser.image =avatar;
}

- (void)downloadSeasons
{
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        NSArray * buf = [[NSArray alloc]initWithArray:[dataLoader getSeasonWithRegionID:1]];
        
        dispatch_async(dispatch_get_main_queue(),^(){
            
            if(!dataLoader.isCorrectRezult) {
                NSLog(@"Error download seasons");
            } else {
                appDelegate.seasons = buf;
            }
            
        });
    });
}

@end
