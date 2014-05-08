//
//  NewLog2ViewController.m
//  SMT
//
//  Created by Mac on 5/8/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "NewLog2ViewController.h"


@interface NewLog2ViewController ()
{
    NSMutableArray * listOfSpecies;
}
@property (weak, nonatomic) IBOutlet UITableView *table;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footer;
@property (strong, nonatomic) Species * species;
- (IBAction)actButtonBack:(id)sender;
@end

@implementation NewLog2ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andSpecies:(Species *)species
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.species = species;
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
    
    listOfSpecies = [[NSMutableArray alloc]init];
    [listOfSpecies addObject:@"header"];
    [listOfSpecies addObject:@"footer"];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listOfSpecies.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if ([[listOfSpecies objectAtIndex:indexPath.row] isEqualToString:@"header"]) {
        [cell.contentView addSubview:self.headerView];
    } else if ([[listOfSpecies objectAtIndex:indexPath.row] isEqualToString:@"footer"])
    {
        [cell.contentView addSubview:self.footer];
    } else {
    cell.textLabel.text = [listOfSpecies objectAtIndex:indexPath.row];
    }
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[listOfSpecies objectAtIndex:indexPath.row] isEqualToString:@"header"]) {
        return self.headerView.frame.size.height;
    } else if ([[listOfSpecies objectAtIndex:indexPath.row] isEqualToString:@"footer"])
    {
        return self.footer.frame.size.height;
    }
    return 44;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (IBAction)actFinalizeLog:(id)sender {
}

- (IBAction)actButtonBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)actLocation:(id)sender {
}

- (IBAction)actDate:(id)sender {
}

- (IBAction)actEndTime:(id)sender {
}

- (IBAction)actStartTime:(id)sender {
}

- (IBAction)actHuntType:(id)sender {
}

- (IBAction)actWeapon:(id)sender {
}

- (IBAction)actNorthernPike:(id)sender {
}

- (IBAction)actAdd:(id)sender {
    [listOfSpecies removeObject:@"footer"];
    [listOfSpecies addObject:@"add"];
    [listOfSpecies addObject:@"footer"];
    [self.table reloadData];
}
@end
