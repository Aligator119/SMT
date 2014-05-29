//
//  LogHistoryViewController.m
//  SMT
//
//  Created by Mac on 5/8/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "LogHistoryViewController.h"
#import "FlyoutMenuViewController.h"
#import "Species.h"

@interface LogHistoryViewController ()
{
    DataLoader * dataLoader;
    NSArray * logHistory;
    NSArray * allKey;
    
    NSMutableDictionary * dict;
    NSDateFormatter * dateFormatter;
    NSDateFormatter * compareFormatter;
    NSDateFormatter * displayFormatter;
    NSCalendar * calendar;
}
@property (strong, nonatomic) IBOutlet UITableView *table;

- (IBAction)actButtonBack:(id)sender;
@end

@implementation LogHistoryViewController

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
    
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    compareFormatter = [[NSDateFormatter alloc]init];
    [compareFormatter setDateFormat:@"yyyy-MM"];
    displayFormatter = [[NSDateFormatter alloc]init];
    [displayFormatter setDateFormat:@"MMMM yyyy"];
    
    UINib *cellNib = [UINib nibWithNibName:@"HistoryCell" bundle:[NSBundle mainBundle]];
    [self.table registerNib:cellNib forCellReuseIdentifier:@"HistoryCell"];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        self.navigationBarHeightConstr.constant -= 20;
        self.navigationBarVerticalConstr.constant -=20;
    }
    calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    dataLoader = [DataLoader instance];
    dict = [[NSMutableDictionary alloc]init];
//----------------------------------------------------------------------------------------------------
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        
        logHistory = [dataLoader getActivityList];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            if(!dataLoader.isCorrectRezult) {
                NSLog(@"Error download log history");
            } else {

                for (id obj in logHistory) {

                    if ([[dict allKeys] containsObject:[compareFormatter stringFromDate:[dateFormatter dateFromString:[obj objectForKey:@"date"]]]]) {
                        NSMutableArray * buf = [[NSMutableArray alloc]initWithArray:[dict objectForKey:[compareFormatter stringFromDate:[dateFormatter dateFromString:[obj objectForKey:@"date"]]]]];
                        [buf addObject:[obj objectForKey:@"species_id"]];
                        [dict setValue:buf forKey:[compareFormatter stringFromDate:[dateFormatter dateFromString:[obj objectForKey:@"date"]]]];
                    } else {
                        NSMutableArray * b = [[NSMutableArray alloc]initWithObjects:[obj objectForKey:@"species_id"], nil];
                        [dict setValue:b forKey:[compareFormatter stringFromDate:[dateFormatter dateFromString:[obj objectForKey:@"date"]]]];
                    }
                }
                allKey = [dict allKeys];
                [self.table reloadData];
            }
        });
    });
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [allKey count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * item = [[NSArray alloc]initWithArray:[dict objectForKey:[allKey objectAtIndex:section]]];
    return item.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell"];
    
    NSArray * item = [[NSArray alloc]initWithArray:[dict objectForKey:[allKey objectAtIndex:indexPath.section]]];
    
    [cell setCellFromSpecies:[item objectAtIndex:indexPath.row]];
    
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [displayFormatter stringFromDate:[compareFormatter dateFromString:[allKey objectAtIndex:section]]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actButtonBack:(id)sender {
    FlyoutMenuViewController * fmvc = [[FlyoutMenuViewController alloc]initWithNibName:@"FlyoutMenuViewController" bundle:nil];
    [self.navigationController pushViewController:fmvc animated:YES];
}
@end
