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

@interface LocationListViewController (){
    AppDelegate * appDel;
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
}

- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) moveToLocationDetails: (NSNotification*) notification{
    Location * loc = (Location*) [notification object];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return appDel.listLocations.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LocationListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LocationListCell" forIndexPath:indexPath];
    [cell processCellInfo:[appDel.listLocations objectAtIndex:indexPath.row]];
    return cell;
}




@end
