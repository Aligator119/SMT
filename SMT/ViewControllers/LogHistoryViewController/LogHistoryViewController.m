//
//  LogHistoryViewController.m
//  SMT
//
//  Created by Mac on 5/8/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "LogHistoryViewController.h"
#import "FlyoutMenuViewController.h"

@interface LogHistoryViewController ()
{
    DataLoader * dataLoader;
    NSArray * logHistory;
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
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        self.navigationBarHeightConstr.constant -= 20;
        self.navigationBarVerticalConstr.constant -=20;
    }
    dataLoader = [DataLoader instance];

//----------------------------------------------------------------------------------------------------
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        
        [dataLoader getActivityList];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            if(!dataLoader.isCorrectRezult) {
                NSLog(@"Error download log history");
            } else {
                [self.table reloadData];
            }
        });
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [logHistory count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    
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
