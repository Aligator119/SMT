//
//  LocationSearchViewController.m
//  SMT
//
//  Created by Admin on 5/5/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "LocationSearchViewController.h"
#import "LocationSearch.h"
#import "PlaceSearchResult.h"
#import "MapViewController.h"

@interface LocationSearchViewController ()

@property (nonatomic, weak) IBOutlet NSLayoutConstraint * navigationBarHeightConstr;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * navigationBarVerticalConstr;
@property (nonatomic, weak) IBOutlet UITableView * tableView;
@property (nonatomic, strong) NSArray * searchResults;
@property (nonatomic, weak) IBOutlet UISearchBar * searchBar;
@end

@implementation LocationSearchViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        self.navigationBarHeightConstr.constant -= 20;
        self.navigationBarVerticalConstr.constant -= 20;
    }
}

-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.searchResults = [LocationSearch getSearchResultWithInput:searchText];
    [self.tableView reloadData];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchResults.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    PlaceSearchResult * place = (PlaceSearchResult*) [self.searchResults objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.text = place.name;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PlaceSearchResult * place = (PlaceSearchResult*) [self.searchResults objectAtIndex:indexPath.row];
    CLLocationCoordinate2D loc =  [LocationSearch getCoordinateOfLocationWithReference:place.reference];
    if (loc.latitude!=MAXFLOAT && loc.longitude!=MAXFLOAT){
        [(MapViewController*) self.parent moveToLocation:loc];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
}

-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
}
-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

-(UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footer = [UIView new];
    footer.backgroundColor = [UIColor grayColor];
    footer.alpha = 0.5;
    return footer;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5f;
}



@end
