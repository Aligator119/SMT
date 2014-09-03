#import "FirstViewController.h"
#import "DataLoader.h"
#import "SettingsViewController.h"
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
    UIImage * avatar;
}
@property (strong, nonatomic) IBOutlet UIImageView *imgUser;
@property (strong, nonatomic) IBOutlet UILabel *lbNameUser;
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftsSpace;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstr;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topSuperViewHeightConstr;


- (void)photoClick:(id)notification;
//- (void)downloadSeasons;


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
        self.topSuperViewHeightConstr.constant -= 20;
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
    
    NSArray *iconsArray = [NSArray arrayWithObjects:@"ic_home", @"ic_map", @"ic_note", @"ic_date", @"ic_camera", @"ic_prediction", @"ic_weather", @"ic_buddies", @"ic_config", @"ic_logout", nil];
    
    NSArray *selectedIconsArray = [NSArray arrayWithObjects:@"ic_home_press", @"ic_map_press", @"ic_note_press", @"ic_date_press", @"ic_camera_press", @"ic_prediction_press", @"ic_weather_press", @"ic_buddies_press", @"ic_config_press", @"ic_logout", nil];
    
    functionsDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:functionsArrayIdentifiers, @"identifiers", menuItems, @"strings", iconsArray, @"icons", selectedIconsArray, @"selectedIcons", nil];
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
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16];
    cell.imageView.image = [UIImage imageNamed:[[functionsDictionary objectForKey:@"icons"] objectAtIndex:indexPath.row]];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    UIView *selectionView = [UIView new];
    selectionView.backgroundColor = [UIColor colorWithRed:123/255.f green:171/255.f blue:72/255.f alpha:0.25];
    cell.selectedBackgroundView = selectionView;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:[[functionsDictionary objectForKey:@"selectedIcons"] objectAtIndex:indexPath.row]];
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSelector:NSSelectorFromString([[functionsDictionary objectForKey:@"identifiers"] objectAtIndex:indexPath.row])];
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:[[functionsDictionary objectForKey:@"icons"] objectAtIndex:indexPath.row]];
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
    [menuController setFrontViewController:[SettingsViewController new] animated:YES]; 
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
//    appDelegate.prevController = menuController.frontViewController;
//    PhotoVideoViewController * pvvc = [PhotoVideoViewController new];
//    [pvvc setDelegate:self];
//    [menuController setFrontViewController:pvvc animated:YES]; 
//    [menuController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    avatar = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self actSetAvatar];
    }];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}


- (void)actSetAvatar {
    
    [self startLoader];
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
            
        [dataLoader setUserAvatar:avatar];
            
        dispatch_async(dispatch_get_main_queue(),^(){
                
            if(!dataLoader.isCorrectRezult) {
                NSLog(@"Error upload avatar");
                [self endLoader];
            } else {
                self.imgUser.image = avatar;
                [self endLoader];
            }
                
        });
    });
    
}

//- (void)selectPhoto:(Photo *)photo
//{
//    [self startLoader];
//    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(newQueue, ^(){
//        //UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photo.fullPhoto]]];
//        [dataLoader setUserAvatar:avatar];
//        
//        dispatch_async(dispatch_get_main_queue(),^(){
//            
//            if(!dataLoader.isCorrectRezult) {
//                NSLog(@"Error upload avatar");
//                [self endLoader];
//            } else {
//                self.imgUser.image = image;
//                [self endLoader];
//            }
//            
//        });
//    });
//}


- (void) newUserAvatar:(UIImage *)image
{
    self.imgUser.image =image;
}

//- (void)downloadSeasons
//{
//    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(newQueue, ^(){
//        NSArray * buf = [[NSArray alloc]initWithArray:[dataLoader getSeasonWithRegion:1]];
//        
//        dispatch_async(dispatch_get_main_queue(),^(){
//            
//            if(!dataLoader.isCorrectRezult) {
//                NSLog(@"Error download seasons");
//            } else {
//                appDelegate.seasons = buf;
//            }
//            
//        });
//    });
//}

@end
