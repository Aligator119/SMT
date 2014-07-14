#import "LogDetailViewController.h"
#import "NewLog1ViewController.h"
#import "LogDetail2ViewController.h"
#import "Species.h"
#import "UIViewController+LoaderCategory.h"
#import "FirstViewController.h"

@interface LogDetailViewController ()
{
    NSDictionary * enteredData;
    Activity * activity;
    NSArray * activityDetails;
    NSMutableArray * displayedCell;
    NSString * logID;
    DataLoader * dataLoader;
    NSDictionary * harvestrows;
    NSDictionary * sightings;
    NSDictionary * settingsDict;
    NSMutableDictionary * data;
    int subSpecieID;
    NSArray * killingQuestion;
    NSMutableDictionary * selectedCell;
}



- (void) addNewCell:(UIButton *) sender;
- (void) addKillingQuestions;
@end

@implementation LogDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andProperty:(NSDictionary *)dict
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        enteredData = dict;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.list = [enteredData objectForKey:@"specie"];
    activity = [enteredData objectForKey:@"activity"];
    activityDetails = [enteredData objectForKey:@"activityDetails"];
    logID = [enteredData objectForKey:@"id"];
    displayedCell = [[NSMutableArray alloc]init];
    for (int i=0;i<[self.list count];i++) {
        if (((ActivityDetails *)[activityDetails objectAtIndex:i]).seen >=3) {
        [displayedCell addObject:@(4)];
        } else {
           [displayedCell addObject:@(((ActivityDetails *)[activityDetails objectAtIndex:i]).seen +1)];
        }
    }
    selectedCell = [[NSMutableDictionary alloc]init];
    for (int i = 0; i< self.list.count; i++) {
        NSMutableArray * buf = [[NSMutableArray alloc]init];
        for (int k=0; k<((ActivityDetails *)[activityDetails objectAtIndex:i]).seen; k++) {
            [buf addObject:@"Add Detail"];
        }
        [selectedCell setValue:buf forKey:[NSString stringWithFormat:@"%d",i]];
    }
    // Do any additional setup after loading the view from its nib.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        self.navigationBarHeightConstr.constant -= 20;
        self.navigationBarVerticalConstr.constant -=20;
    }
    UINib *cellNib1 = [UINib nibWithNibName:@"LogDetailCell" bundle:[NSBundle mainBundle]];
    [self.table registerNib:cellNib1 forCellReuseIdentifier:@"LogDetailCell"];
    UINib *cellNib2 = [UINib nibWithNibName:@"AddCell" bundle:[NSBundle mainBundle]];
    [self.table registerNib:cellNib2 forCellReuseIdentifier:@"AddCell"];
    
    dataLoader = [DataLoader instance];
    
    [self AddActivityIndicator:[UIColor grayColor] forView:self.table];
    self.screenName = @"LogDetail Screen";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (self.index) {
        NSMutableArray * array = [[NSMutableArray alloc]init];
        NSArray * buf = [selectedCell objectForKey:[NSString stringWithFormat:@"%d",self.index.section]];
        for (int i = 0; i<buf.count; i++) {
            if (i == self.index.row) {
                [array addObject:@"Detail Saved"];
            } else {
                [array addObject:[buf objectAtIndex:i]];
            }
        }
        [selectedCell removeObjectForKey:[NSString stringWithFormat:@"%d",self.index.section]];
        [selectedCell setValue:array forKey:[NSString stringWithFormat:@"%d",self.index.section]];
        [self.table reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[displayedCell objectAtIndex:section] integerValue] > ((ActivityDetails *)[activityDetails objectAtIndex:section]).seen ? ((ActivityDetails *)[activityDetails objectAtIndex:section]).seen : [[displayedCell objectAtIndex:section] integerValue];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    NSInteger numberOfCell = [[displayedCell objectAtIndex:indexPath.section] integerValue];
    ActivityDetails * details = [activityDetails objectAtIndex:indexPath.section];
    NSArray * save = [selectedCell objectForKey:[NSString stringWithFormat:@"%d",indexPath.section]];
    if (numberOfCell <= details.seen && numberOfCell-1 == indexPath.row) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AddCell"];
        ((AddCell *)cell).btnAdd.tag = indexPath.section;
        [((AddCell *)cell).btnAdd addTarget:self action:@selector(addNewCell:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        
        if (numberOfCell > details.harvested && indexPath.row >= details.harvested)   {
            cell = [tableView dequeueReusableCellWithIdentifier:@"LogDetailCell"];
            
            NSString * str = [[@"Seen(" stringByAppendingString:[NSString stringWithFormat:@"%d",indexPath.row + 1]] stringByAppendingString:@")"];
            ((LogDetailCell *)cell).lbText.text = str;
            ((LogDetailCell *)cell).lbDetailText.text = [save objectAtIndex:indexPath.row];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"LogDetailCell"];
        
        NSString * str = [[@"Harvested(" stringByAppendingString:[NSString stringWithFormat:@"%d",indexPath.row + 1]] stringByAppendingString:@")"];
            ((LogDetailCell *)cell).lbText.text = str;
        ((LogDetailCell *)cell).lbDetailText.text = [save objectAtIndex:indexPath.row];
        }
    }
    
    
    return cell;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [@"    " stringByAppendingString:((Species *)[self.list objectAtIndex:section]).name];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.table deselectRowAtIndexPath:indexPath animated:YES];
    if ([[self.table cellForRowAtIndexPath:indexPath] isKindOfClass:[LogDetailCell class]]) {
        [self startLoader];
        NSString * str = ((LogDetailCell *)[self.table cellForRowAtIndexPath:indexPath]).lbText.text;
        dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(newQueue, ^(){
            
            settingsDict = [dataLoader getActivityWithId:[logID intValue]];
            
            dispatch_async(dispatch_get_main_queue(), ^(){
                
                if(!dataLoader.isCorrectRezult) {
                    NSLog(@"Error download harvester");
                    [self endLoader];
                } else {
                    int numSightings = 0;
                    harvestrows = [[settingsDict objectForKey:@"harvestrows"] objectAtIndex:indexPath.section];
                    for (int i = 0; i<=indexPath.section; i++) {
                        if (i == indexPath.section) {
                            numSightings += indexPath.row;
                        } else {
                            numSightings += [[((NSDictionary *)[[settingsDict objectForKey:@"harvestrows"] objectAtIndex:i]) objectForKey:@"seen"] intValue];
                        }
                    }
                    
                    sightings   = [[settingsDict objectForKey:@"sightings"] objectAtIndex:numSightings];
                    data = [[NSMutableDictionary alloc]initWithObjectsAndKeys:str, @"name", indexPath, @"index", harvestrows, @"harvestrows", sightings, @"sightings", nil];
                    [self addKillingQuestions];
                    [self endLoader];
                }
            });
        });
    }
}


- (void) addKillingQuestions
{
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        int sid = [[[data objectForKey:@"harvestrows"] objectForKey:@"subspecies_id"] intValue];
        killingQuestion = [dataLoader getSubSpecieKillingQuestionsWithId:sid];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            if(!dataLoader.isCorrectRezult) {
                NSLog(@"Error download harvester");
            } else {
                [data setValue:killingQuestion forKey:@"killingQuestion"];
                LogDetail2ViewController * ld2vc = [[LogDetail2ViewController alloc]initWithNibName:@"LogDetail2ViewController" bundle:nil andData:data];
                [self.navigationController pushViewController:ld2vc animated:YES];
            }
        });
    });

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addNewCell:(UIButton *)sender
{
    NSInteger num = [[displayedCell objectAtIndex:sender.tag] integerValue];
    //if (num<((ActivityDetails *)[activityDetails objectAtIndex:sender.tag]).seen) {
        num++;
    //}
    [displayedCell replaceObjectAtIndex:sender.tag withObject:@(num)];
    [self.table reloadData];
}

- (IBAction)actClose:(id)sender {
//    for (id obj in self.navigationController.viewControllers) {
//        if ([obj isKindOfClass:[FirstViewController class]]) {
//            [self.navigationController popToViewController:obj animated:YES];
//        }
//    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
