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
#import "UIViewController+LoaderCategory.h"

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
    
    [self AddActivityIndicator:[UIColor grayColor] forView:self.table];
//----------------------------------------------------------------------------------------------------
    
        
    logHistory = [dataLoader getActivityListFrom:0 to:-1];
        
    
    for (id obj in logHistory) {

        if ([[dict allKeys] containsObject:[compareFormatter stringFromDate:[dateFormatter dateFromString:[obj objectForKey:@"date"]]]]) {
            NSMutableArray * buf = [[NSMutableArray alloc]initWithArray:[dict objectForKey:[compareFormatter stringFromDate:[dateFormatter dateFromString:[obj objectForKey:@"date"]]]]];
            [buf addObject:[obj objectForKey:@"data"]];
            [dict setValue:buf forKey:[compareFormatter stringFromDate:[dateFormatter dateFromString:[obj objectForKey:@"date"]]]];
        } else {
            NSMutableArray * b = [[NSMutableArray alloc]initWithObjects:[obj objectForKey:@"data"], nil];
            [dict setValue:b forKey:[compareFormatter stringFromDate:[dateFormatter dateFromString:[obj objectForKey:@"date"]]]];
        }
    }
    
    allKey = [dict allKeys];
    [self.table reloadData];
    self.screenName = @"LogHistory screen";
               
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
    NSMutableDictionary * specie = [item objectAtIndex:indexPath.row];
    [cell setCellFromSpecies:specie];
    
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [displayFormatter stringFromDate:[compareFormatter dateFromString:[allKey objectAtIndex:section]]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actButtonBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
