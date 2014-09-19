#import "LocationListViewController.h"
#import "Location.h"
#import "LocationListCell.h"
#import "AppDelegate.h"
#import "BaseLocationViewController.h"
#import "DataLoader.h"
#import "UIViewController+LoaderCategory.h"
#import "LocationSearchViewController.h"
#import "CameraButton.h"

@interface LocationListViewController (){
    AppDelegate * appDel;
    NSArray *listLocations;
    BOOL isUpdate;
    int limit;
    DataLoader * dataLoader;
}
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tabBarWidth;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;

@property (weak, nonatomic) IBOutlet UIView *fly_up;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *locationChangeSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segment;
- (IBAction) actNewLocation:(id)sender;
- (IBAction) actAddLocationWithMap:(id)sender;
- (IBAction) actAddLocationWithAddres:(id)sender;
- (IBAction) actAddLocationWithLatLong:(id)sender;

- (void)clickNotPopUpMenu;
- (void)actSelectLocationType;
@end

@implementation LocationListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"LocationListCell" bundle:nil] forCellReuseIdentifier:@"LocationListCell"];
    
    appDel = (AppDelegate*) [UIApplication sharedApplication].delegate;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        self.navigationBarHeightConstr.constant -= 20;
        self.navigationBarVerticalConstr.constant -=20;
        UIFont *font = [UIFont boldSystemFontOfSize:10.0f];
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                               forKey:NSFontAttributeName];
        [self.segment setTitleTextAttributes:attributes
                                        forState:UIControlStateNormal];
    }

    UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [self.segment setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    isUpdate = NO;
    limit = 10;
    dataLoader = [DataLoader instance];
    self.screenName = @"Location list screen";
    [self AddActivityIndicator:[UIColor grayColor] forView:self.tableView];
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickNotPopUpMenu)];
    recognizer.delegate =self;
    [self.fly_up addGestureRecognizer:recognizer];
    
    MenuViewController * menuController = self.revealViewController;
    
    [self.view addGestureRecognizer:menuController.panGestureRecognizer];
    [_menuButton addTarget:menuController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
//-------------------------------------------------------------------------------------
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        [dataLoader getLocationsAssociatedWithUser];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            if(!dataLoader.isCorrectRezult) {
                NSLog(@"Error download location");
            } else {
                [self actSelectLocationType];
            }
            [self endLoader];
        });
    });
}


- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self actSelectLocationType];

    self.tabBarWidth.constant = self.view.frame.size.width;
    
    [self.view updateConstraintsIfNeeded];
    
}

- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return listLocations.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LocationListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LocationListCell" forIndexPath:indexPath];
    [cell processCellInfo:[listLocations objectAtIndex:indexPath.row]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // go to BaseLocationViewController
    if (![[listLocations objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]) {
        Location * loc = (Location*) [listLocations objectAtIndex:indexPath.row];
        BaseLocationViewController *updateLocationVC = [BaseLocationViewController new];
        updateLocationVC.location = loc;
        [self.navigationController pushViewController:updateLocationVC animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(self.tableView.contentOffset.y<0){
        //it means table view is pulled down like refresh
        return;
    }
    else if(self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height)) {
        if (self.segment.selectedSegmentIndex == 2) {
            
            if (isUpdate) {
                return;
            } else {
                [self startLoader];
                isUpdate = YES;
                limit += 10;
                NSLog(@"bottom!!!! is update");
                dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(newQueue, ^(){
                    [dataLoader getPublicLocationWithID:nil name:nil page:0 limit:limit state_fips:0 county_fips:0];
                
                    dispatch_async(dispatch_get_main_queue(), ^(){
                    
                        if(!dataLoader.isCorrectRezult) {
                            NSLog(@"Error download Public location");
                        } else {
                            isUpdate = NO;
                            listLocations = appDel.publicLocations;
                            [self.tableView reloadData];
                        }
                        [self endLoader];
                    });
                });

            }
        }
    }
}


-(IBAction) locationTypeChange:(id)sender{
    int selected = self.locationChangeSegmentControl.selectedSegmentIndex;
    switch (selected) {
        case 0:
        {
            NSMutableArray * buf =[[NSMutableArray alloc]initWithArray:appDel.listFishLocations];
            [buf addObjectsFromArray:appDel.listHuntLocations];
            listLocations = [NSArray arrayWithArray:buf];
            [self.tableView reloadData];
        }
            break;
            
        case 1:
        {
            NSMutableArray * buf =[[NSMutableArray alloc]initWithArray:appDel.listSharedFishLocations];
            [buf addObjectsFromArray:appDel.listSharedHuntLocations];
            listLocations = [NSArray arrayWithArray:buf];
            [self.tableView reloadData];
        }
            break;
        case 2:
            if (self.mapType == typeFishing){
                listLocations = [NSArray arrayWithArray:appDel.publicLocations];
            } else if (self.mapType == typeHunting){
                listLocations = [NSArray arrayWithArray:appDel.publicLocations];
            }
            [self.tableView reloadData];
            break;
            
        default:
            break;
    }
}


-(void) setIsPresent:(BOOL)present
{
    isPresent = present;
    if (isPresent) {
        [((UIButton *)[self.tabBar viewWithTag:1]) setBackgroundImage:[UIImage imageNamed:@"home_icon.png"] forState:UIControlStateNormal];
        [((UIButton *)[self.tabBar viewWithTag:2]) setBackgroundImage:[UIImage imageNamed:@"global_icon_press.png"] forState:UIControlStateNormal];
        [((UIButton *)[self.tabBar viewWithTag:3]) setBackgroundImage:[UIImage imageNamed:@"camera_icon.png"] forState:UIControlStateNormal];
        [((UIButton *)[self.tabBar viewWithTag:4]) setBackgroundImage:[UIImage imageNamed:@"note_icon.png"] forState:UIControlStateNormal];
        [((UIButton *)[self.tabBar viewWithTag:5]) setBackgroundImage:[UIImage imageNamed:@"st_icon.png"] forState:UIControlStateNormal];
    } else {
        [((UIButton *)[self.tabBar viewWithTag:2]) setBackgroundImage:[UIImage imageNamed:@"global_icon.png"] forState:UIControlStateNormal];
    }
}


- (IBAction) actNewLocation:(id)sender
{
    self.fly_up.hidden = NO;
}

- (void) actAddLocationWithMap:(id)sender
{
    self.fly_up.hidden = YES;
    MapViewController * map = [[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
    [self.navigationController pushViewController:map animated:YES];
}

- (void) actAddLocationWithAddres:(id)sender
{
    self.fly_up.hidden = YES;
    LocationSearchViewController * locationSearchVC = [LocationSearchViewController new];
    locationSearchVC.parent = self;
    [self.navigationController pushViewController:locationSearchVC animated:YES];
}

- (IBAction) actAddLocationWithLatLong:(id)sender
{
    self.fly_up.hidden = YES;
    MapViewController * map = [[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
    map.isPresentView = 2;
    [self.navigationController pushViewController:map animated:YES];
}


- (void)actSelectLocationType
{
    switch (self.locationChangeSegmentControl.selectedSegmentIndex) {
        case 0:
        {
            NSMutableArray * buf =[[NSMutableArray alloc]initWithArray:appDel.listFishLocations];
            [buf addObjectsFromArray:appDel.listHuntLocations];
            listLocations = [NSArray arrayWithArray:buf];
            [self.tableView reloadData];
        }
            break;
        case 1:
        {
            NSMutableArray * buf =[[NSMutableArray alloc]initWithArray:appDel.listSharedFishLocations];
            [buf addObjectsFromArray:appDel.listSharedHuntLocations];
            listLocations = [NSArray arrayWithArray:buf];
            [self.tableView reloadData];
        }
            break;
        case 2:
        {
            NSMutableArray * buf =[[NSMutableArray alloc]initWithArray:appDel.publicLocations];
            listLocations = [NSArray arrayWithArray:buf];
            [self.tableView reloadData];
        }
            break;
            
        default:
            break;
    }
}

- (void)clickNotPopUpMenu
{
    self.fly_up.hidden = YES;
}

@end
