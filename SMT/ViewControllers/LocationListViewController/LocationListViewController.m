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
@property (nonatomic, weak) IBOutlet UISegmentedControl *locationChangeSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segment;
- (LocationListCell *) getFirstCell:(CellWithTwoButton *) cell;
- (void) actAddLocationWithMap:(id)sender;
- (void) actAddLocationWithAddres:(id)sender;
@end

@implementation LocationListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveToLocationDetails:) name:@"LocationListInfoButtonPressed" object:nil];
    [self.tableView registerNib:[UINib nibWithNibName:@"LocationListCell" bundle:nil] forCellReuseIdentifier:@"LocationListCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CellWithTwoButton" bundle:nil] forCellReuseIdentifier:@"CellWithTwoButton"];
    
    appDel = (AppDelegate*) [UIApplication sharedApplication].delegate;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        self.navigationBarHeightConstr.constant -= 20;
        self.navigationBarVerticalConstr.constant -=20;
    }

    UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [self.segment setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    switch (self.locationChangeSegmentControl.selectedSegmentIndex) {
        case 0:
        {
            NSMutableArray * buf =[[NSMutableArray alloc]initWithArray:@[[NSString stringWithFormat:@"add"]]];
            [buf addObjectsFromArray:appDel.listFishLocations];
            [buf addObjectsFromArray:appDel.listHuntLocations];
            listLocations = [NSArray arrayWithArray:buf];
            [self.tableView reloadData];
        }
            break;
        case 1:
        {
            NSMutableArray * buf =[[NSMutableArray alloc]initWithArray:appDel.listSharedFishLocations];
            [buf addObjectsFromArray:appDel.listSharedHuntLocations];
            listLocations = [NSArray arrayWithArray:buf];
            [self.tableView reloadData];
        }
            break;
        case 2:
        {
            NSMutableArray * buf =[[NSMutableArray alloc]initWithArray:appDel.listSharedFishLocations];
            [buf addObjectsFromArray:appDel.listSharedHuntLocations];
            listLocations = [NSArray arrayWithArray:buf];
            [self.tableView reloadData];
        }
            break;
            
        default:
            break;
    }

    
    
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
    if ([[listLocations objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]) {
        CellWithTwoButton *cell1 = [tableView dequeueReusableCellWithIdentifier:@"CellWithTwoButton"];
        [cell1.btnMap addTarget:self action:@selector(actAddLocationWithMap:) forControlEvents:UIControlEventTouchUpInside];
        [cell1.btnAddres addTarget:self action:@selector(actAddLocationWithAddres:) forControlEvents:UIControlEventTouchUpInside];
        return cell1;
    }
    [cell processCellInfo:[listLocations objectAtIndex:indexPath.row]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)actBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actGroups:(id)sender {
}

-(IBAction) locationTypeChange:(id)sender{
    int selected = self.locationChangeSegmentControl.selectedSegmentIndex;
    switch (selected) {
        case 0:
        {
            NSMutableArray * buf =[[NSMutableArray alloc]initWithArray:@[[NSString stringWithFormat:@"add"]]];
            [buf addObjectsFromArray:appDel.listHuntLocations];
            [buf addObjectsFromArray:appDel.listFishLocations];
            listLocations = [NSArray arrayWithArray:buf];
            [self.tableView reloadData];
        }
            break;
            
        case 1:
        {
            NSMutableArray * buf =[[NSMutableArray alloc]initWithArray:appDel.listSharedFishLocations];
            [buf addObjectsFromArray:appDel.listSharedHuntLocations];
            listLocations = [NSArray arrayWithArray:buf];
            [self.tableView reloadData];
        }
            break;
        case 2:
            if (self.mapType == typeFishing){
                listLocations = [NSArray arrayWithArray:appDel.listSharedFishLocations];
            } else if (self.mapType == typeHunting){
                listLocations = [NSArray arrayWithArray:appDel.listSharedHuntLocations];
            }
            [self.tableView reloadData];
            break;
            
        default:
            break;
    }
}


-(void) setIsPresent:(BOOL)present
{
    isPresent = present;
    if (isPresent) {
        [((UIButton *)[self.tabBar viewWithTag:1]) setBackgroundImage:[UIImage imageNamed:@"home_icon.png"] forState:UIControlStateNormal];
        [((UIButton *)[self.tabBar viewWithTag:2]) setBackgroundImage:[UIImage imageNamed:@"global_icon_press.png"] forState:UIControlStateNormal];
        [((UIButton *)[self.tabBar viewWithTag:3]) setBackgroundImage:[UIImage imageNamed:@"camera_icon.png"] forState:UIControlStateNormal];
        [((UIButton *)[self.tabBar viewWithTag:4]) setBackgroundImage:[UIImage imageNamed:@"note_icon.png"] forState:UIControlStateNormal];
        [((UIButton *)[self.tabBar viewWithTag:5]) setBackgroundImage:[UIImage imageNamed:@"st_icon.png"] forState:UIControlStateNormal];
    } else {
        [((UIButton *)[self.tabBar viewWithTag:2]) setBackgroundImage:[UIImage imageNamed:@"global_icon.png"] forState:UIControlStateNormal];
    }
}


- (UITableViewCell *) getFirstCell:(CellWithTwoButton *)cell
{
    
    [cell.btnMap addTarget:self action:@selector(actAddLocationWithMap:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnAddres addTarget:self action:@selector(actAddLocationWithAddres:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

- (void) actAddLocationWithMap:(id)sender
{
    MapViewController * map = [MapViewController new];
    [self.navigationController pushViewController:map animated:YES];
}

- (void) actAddLocationWithAddres:(id)sender
{
    [[[UIAlertView alloc]initWithTitle:@"Fatal Error" message:@"No create controller" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

@end
