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
    NSMutableArray * speciesHistory;
    NSDateFormatter * dateFormatter;
    NSDateFormatter * compareFormatter;
    NSDateComponents * components;
    NSDateComponents * components2;
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
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        self.navigationBarHeightConstr.constant -= 20;
        self.navigationBarVerticalConstr.constant -=20;
    }
    calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    dataLoader = [DataLoader instance];
    speciesHistory = [[NSMutableArray alloc]init];

//----------------------------------------------------------------------------------------------------
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        
        logHistory = [dataLoader getActivityList];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            if(!dataLoader.isCorrectRezult) {
                NSLog(@"Error download log history");
            } else {
                NSMutableArray * buffer = [[NSMutableArray alloc]init];
                components2 = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                         fromDate:[dateFormatter dateFromString:[[logHistory firstObject] objectForKey:@"date"]]];
                for (id ID in logHistory) {
                    components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                             fromDate:[dateFormatter dateFromString:[ID objectForKey:@"date"]]];
                    if (components.year != components2.year || components.month != components2.month) {
                        components2 = components;
                        [speciesHistory addObject:buffer];
                        buffer = [NSMutableArray new];
                    }
                dispatch_queue_t nQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                 dispatch_async(nQueue, ^(){
                    
                    [buffer addObject:[dataLoader getSpecieWithId:[[ID objectForKey:@"species_id"] intValue]]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^(){
                        
                        if(!dataLoader.isCorrectRezult) {
                            NSLog(@"Error download log history");
                        } else {
                            [self.table reloadData];
                        }
                    });
                });
                }
            }
        });
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [speciesHistory count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    Species * specie = [speciesHistory objectAtIndex:indexPath.row];
    cell.textLabel.text = specie.name;
    
    
    return cell;
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
