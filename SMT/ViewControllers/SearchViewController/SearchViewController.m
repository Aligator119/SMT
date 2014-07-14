#import "SearchViewController.h"
#import "DataLoader.h"
#import "UIViewController+LoaderCategory.h"
#import "BuddySearchCell.h"
#import "SearchingBuddy.h"
#import "Location.h"
#import "LocationListCell.h"
#import "BaseLocationViewController.h"

@interface SearchViewController ()
{
    DataLoader * dataLoader;
    NSMutableArray * searchResult;
}
@property (strong, nonatomic) IBOutlet UISegmentedControl *segment;
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstr;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btnCancelWidth;
@property (strong, nonatomic) IBOutlet UITextField *tfSearch;

- (void)searchUserWithName:(NSString *)str;
- (void)searchLocationWithName:(NSString *)str;
- (void)searchOutfitterWithName:(NSString *)str;
- (IBAction)actSearchCancel:(id)sender;
- (IBAction)actSegmentChangeValue:(id)sender;
@end

@implementation SearchViewController

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
    // Do any additional setup after loading the view from its nib.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        self.topViewHeightConstr.constant -= 20;
    }
    [self.tfSearch.layer setMasksToBounds:YES];
    self.tfSearch.layer.cornerRadius = 5.0f;
    self.btnCancelWidth.constant = 0;
    [self updateViewConstraints];
    dataLoader = [DataLoader instance];
    [self AddActivityIndicator:[UIColor grayColor] forView:self.table];
    UINib *cellNib = [UINib nibWithNibName:@"BuddySearchCell" bundle:[NSBundle mainBundle]];
    [self.table registerNib:cellNib forCellReuseIdentifier:@"BuddySearchCell"];
    UINib *cellNib1 = [UINib nibWithNibName:@"LocationListCell" bundle:[NSBundle mainBundle]];
    [self.table registerNib:cellNib1 forCellReuseIdentifier:@"LocationListCell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveToLocationDetails:) name:@"LocationListInfoButtonPressed" object:nil];
    self.screenName = @"Search screen";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.tfSearch becomeFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return searchResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    switch (self.segment.selectedSegmentIndex) {
        case 0:
        {
            SearchingBuddy * buddy = [[SearchingBuddy alloc]init];
            buddy = [searchResult objectAtIndex:indexPath.row];
            cell = [tableView dequeueReusableCellWithIdentifier:@"BuddySearchCell"];
            ((BuddySearchCell *)cell).lblBuddySecondName.text = buddy.userName;
            ((BuddySearchCell *)cell).lblBuddyUserName.text = buddy.userEmail;
            [((BuddySearchCell *)cell) setSizeToFit];
            [((BuddySearchCell *)cell) addDelegate:self];
            ((BuddySearchCell *)cell).btnAddBuddy.tag = indexPath.row;
        }
            break;
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"LocationListCell"];
            [((LocationListCell *)cell) processCellInfo:[searchResult objectAtIndex:indexPath.row]];
        }
            break;
        case 2:
        {
            
        }
            break;
    }
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.segment.selectedSegmentIndex) {
        case 0:
        {
            return 54.0f;
        }
            break;
        case 1:
        {
            return 44.0f;
        }
            break;
        case 2:
        {
            return 44.0f;
        }
            break;
    }

    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void) moveToLocationDetails: (NSNotification*) notification{
    Location * loc = (Location*) [notification object];
    BaseLocationViewController *updateLocationVC = [BaseLocationViewController new];
    updateLocationVC.location = loc;
    [self.navigationController pushViewController:updateLocationVC animated:YES];
}



- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.tfSearch setBackgroundColor:[UIColor whiteColor]];
    self.btnCancelWidth.constant = 60.0f;
    [self updateViewConstraints];
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        switch (self.segment.selectedSegmentIndex) {
            case 0:
            {
                [self searchUserWithName:textField.text];
            }
                break;
            case 1:
            {
                [self searchLocationWithName:textField.text];
            }
                break;
            case 2:
            {
                [self searchOutfitterWithName:textField.text];
            }
                break;
        }
        return NO;
    }
    return YES;
}

- (void)searchUserWithName:(NSString *)str
{
    [self startLoader];
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        searchResult = [[NSMutableArray alloc]initWithArray:[dataLoader buddySearchByLastName:str]];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            if(!dataLoader.isCorrectRezult) {
                NSLog(@"Error searche people");
                [self endLoader];
            } else {
                [self.table reloadData];
                [self endLoader];
            }
        });
    });
}


- (void)searchLocationWithName:(NSString *)str
{
    [self startLoader];
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        searchResult = [[NSMutableArray alloc]initWithArray:[dataLoader getPublicLocationWithName:str]];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            if(!dataLoader.isCorrectRezult) {
                NSLog(@"Error searche people");
                [self endLoader];
            } else {
                [self.table reloadData];
                [self endLoader];
            }
        });
    });

}


- (void)searchOutfitterWithName:(NSString *)str
{
    [self startLoader];
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        searchResult = [[NSMutableArray alloc]initWithArray:[dataLoader getTips]];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            if(!dataLoader.isCorrectRezult) {
                NSLog(@"Error searche people");
                [self endLoader];
            } else {
                [self.table reloadData];
                [self endLoader];
            }
        });
    });

}

- (IBAction)actSearchCancel:(id)sender {
    self.btnCancelWidth.constant = 0;
    [self updateViewConstraints];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (IBAction)actSegmentChangeValue:(id)sender {
    [searchResult removeAllObjects];
    self.tfSearch.text = @"";
    [self.table reloadData];
}

- (IBAction)AddBuddy:(id)sender{
   // NSLog(@"Buddy was added");
    
    //NSIndexPath * numberAddUser = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    //NSLog(@"Sec : %i Row : %i",numberAddUser.section,numberAddUser.row);
    [self startLoader];
    
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        
        [dataLoader buddyAddWithName:[(SearchingBuddy* )[searchResult objectAtIndex:[sender tag]] userEmail]];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            [self endLoader];
            if(dataLoader.isCorrectRezult){
                NSLog(@"buddy added");
                SearchingBuddy * friend = (SearchingBuddy* )[searchResult objectAtIndex:[sender tag]];
                [searchResult removeObject:friend];
                
                [self.table reloadData];
            };
            [self endLoader];
        });
    });
    
    // - - - - - - - - - - - - - - - - -
}



@end
