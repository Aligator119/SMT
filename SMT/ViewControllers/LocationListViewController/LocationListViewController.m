//
//  LocationListViewController.m
//  SMT
//
//  Created by Admin on 5/6/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "LocationListViewController.h"
#import "Location.h"
#import "LocationListCell.h"
#import "AppDelegate.h"
#import "BaseLocationViewController.h"

@interface LocationListViewController (){
    AppDelegate * appDel;
    NSArray *listLocations;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation LocationListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveToLocationDetails:) name:@"LocationListInfoButtonPressed" object:nil];
    [self.tableView registerNib:[UINib nibWithNibName:@"LocationListCell" bundle:nil] forCellReuseIdentifier:@"LocationListCell"];
    appDel = (AppDelegate*) [UIApplication sharedApplication].delegate;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        self.navigationBarHeightConstr.constant -= 20;
        self.navigationBarVerticalConstr.constant -=20;
    }

}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.mapType == typeFishing){
        listLocations = [NSArray arrayWithArray:appDel.listFishLocations];
    } else if (self.mapType == typeHunting){
        listLocations = [NSArray arrayWithArray:appDel.listHuntLocations];
    }
    [self.tableView reloadData];
}

- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) moveToLocationDetails: (NSNotification*) notification{
    Location * loc = (Location*) [notification object];
    BaseLocationViewController *updateLocationVC = [BaseLocationViewController new];
    updateLocationVC.location = loc;
    [self.navigationController pushViewController:updateLocationVC animated:YES];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return listLocations.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LocationListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LocationListCell" forIndexPath:indexPath];
    [cell processCellInfo:[listLocations objectAtIndex:indexPath.row]];
    return cell;
}




- (IBAction)actBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actGroups:(id)sender {
}
@end
