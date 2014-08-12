#import "NewLog1ViewController.h"
#import "LogHistoryViewController.h"
#import "DataLoader.h"
#import "AppDelegate.h"
#import "Species.h"
#import "NewLog2ViewController.h"
#import "UIViewController+LoaderCategory.h"
#import "LogAnActivityViewController.h"

@interface NewLog1ViewController ()
{
    AppDelegate * appDelegate;
    DataLoader *loader;
    NSArray * array;
    Species * spec;
    NSMutableDictionary * cashedPpoto;
}
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tabBarWidth;
@property (weak, nonatomic) IBOutlet UIButton * menuButton;

- (void)actDownloadData;
@end

@implementation NewLog1ViewController

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
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        self.navigationBarHeightConstr.constant -= 20;
        self.navigationBarVerticalConstr.constant -=20;
    }

    self.navigationController.navigationBar.hidden = YES;
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    loader = [[DataLoader alloc]init];
    [self AddActivityIndicator:[UIColor grayColor] forView:self.view];
    
    UINib *cellNib = [UINib nibWithNibName:@"SpeciesCell" bundle:[NSBundle mainBundle]];
    [self.table registerNib:cellNib forCellReuseIdentifier:@"SpeciesCell"];
    
    cashedPpoto = [[NSMutableDictionary alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cashedImageFromCell:)
                                                 name:@"cashed species photo"
                                               object:nil];
    
    MenuViewController * menuController = self.revealViewController;
    
    [self.view addGestureRecognizer:menuController.panGestureRecognizer];
    [_menuButton addTarget:menuController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];

}

-(void) viewWillAppear:(BOOL)animated
{
    self.tabBarWidth.constant = self.view.frame.size.width;
    [self.view updateConstraintsIfNeeded];
    [self actDownloadData];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return appDelegate.speciesList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SpeciesCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SpeciesCell"];
    Species * specie = [appDelegate.speciesList objectAtIndex:indexPath.row];
    if ([[cashedPpoto allKeys] containsObject:specie.specId]) {
        [cell setSpecie:specie andImage:[cashedPpoto objectForKey:specie.specId]];
    } else {
        [cell setSpecie:specie andImage:[cashedPpoto objectForKey:nil]];
    }
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"  Select Species";
    }
    return @"";
}

//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    
//    //1. Setup the CATransform3D structure
//    CATransform3D rotation;
//    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
//    rotation.m34 = 1.0/ -600;
//    
//    
//    //2. Define the initial state (Before the animation)
//    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
//    cell.layer.shadowOffset = CGSizeMake(10, 10);
//    cell.alpha = 0;
//    
//    cell.layer.transform = rotation;
//    cell.layer.anchorPoint = CGPointMake(0, 0.5);
//    
//    
//    //3. Define the final state (After the animation) and commit the animation
//    [UIView beginAnimations:@"rotation" context:NULL];
//    [UIView setAnimationDuration:0.8];
//    cell.layer.transform = CATransform3DIdentity;
//    cell.alpha = 1;
//    cell.layer.shadowOffset = CGSizeMake(0, 0);
//    [UIView commitAnimations];
//    
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self startLoader];
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        spec = [appDelegate.speciesList objectAtIndex:indexPath.row];
        array = [[NSArray alloc]initWithArray:[loader getQuestionsWithSubSpecieId:[spec.specId intValue]]] ;
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            if(!loader.isCorrectRezult) {
                NSLog(@"Error download sybSpecie");
                [self endLoader];
            } else {
                NSDictionary * dict = [[NSDictionary alloc]initWithObjectsAndKeys:spec, @"species", array, @"questions", nil];
                NewLog2ViewController * nlvc = [[NewLog2ViewController alloc]initWithNibName:@"NewLog2ViewController" bundle:nil andData:dict];
                [self.navigationController pushViewController:nlvc animated:YES];
                [self endLoader];
            }
        });
    });
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) actDownloadData
{
    if ([appDelegate.speciesList firstObject] == nil) {
    [self startLoader];
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        
       [loader getAllSpecies];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            if(!loader.isCorrectRezult) {
                NSLog(@"Error download sybSpecie");
                [self endLoader];
            } else {
                [self.table reloadData];
                [self endLoader];
            }
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            {
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            }
        });
    });
    }
}


- (void)cashedImageFromCell:(NSNotification *)info
{
    NSDictionary * userImage = [info userInfo];
    [cashedPpoto addEntriesFromDictionary:userImage];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
