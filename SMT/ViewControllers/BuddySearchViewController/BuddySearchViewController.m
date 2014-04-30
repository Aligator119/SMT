//
//  HPBuddySearchViewController.m
//  HunterPredictor
//
//  Created by Vasya on 06.02.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import "BuddySearchViewController.h"
#import "BuddySearchCell.h"
#import "DataLoader.h"
#import "Buddy.h"
#import "SearchingBuddy.h"
#import "AppDelegate.h"
#import "BuddyListViewController.h"

//#import "UIViewController+LoaderCategory.h"

@interface BuddySearchViewController (){
    NSMutableArray * listFindedUsers;
    DataLoader * dataLoader;
}

@property (strong, nonatomic) IBOutlet NSLayoutConstraint * verticalConstr;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint * heightConstr;

@end

@implementation BuddySearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        self.heightConstr.constant -= 20;
        self.verticalConstr.constant -= 20;
    }
    
    listFindedUsers = [NSMutableArray new];
    dataLoader = [DataLoader instance];
    
    [self setPropertiesOfSerchBar];
    [self setPropertiesOfTable];
    
}

-(void)viewWillAppear:(BOOL)animated{
    //[self AddActivityIndicator:[UIColor blackColor]];
}

#pragma mark - Work with Search Bar

- (void)setPropertiesOfSerchBar{
    self.searchBuddy.delegate = self;
    [self.searchBuddy setSearchFieldBackgroundImage:[UIImage imageNamed:@"search_bar_line"] forState:UIControlStateNormal];
    [self.searchBuddy setBackgroundImage:[UIImage imageNamed:@"search_bar_bg"]];
    [self.searchBuddy setPlaceholder:@"Search"];
   
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor blackColor]];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    self.searchBuddy.autocorrectionType = UITextAutocorrectionTypeNo;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    self.searchBuddy.showsCancelButton = NO;
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
    
   // [self.tblListOfFindedUsers reloadData];
    NSLog(@"Edit finished - Search");
    
    if(![AppDelegate removeGapsWithString:self.searchBuddy.text]){
        [AppDelegate OpenAlertwithTitle:@"Error" andContent:@"Field can't contains only gaps"];
        return;
    }
    //****
    //[self startLoader];
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        
        [dataLoader buddySearchByLastName:self.searchBuddy.text];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            //[self endLoader];
            
            if(dataLoader.isCorrectRezult){
                [self.tblListOfFindedUsers reloadData];
            }
        });
    });
        
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

#pragma mark - Work with Table

- (void)setPropertiesOfTable{
    self.tblListOfFindedUsers.delegate = self;
    self.tblListOfFindedUsers.dataSource = self;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return listFindedUsers.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BuddySearchCell * costumCell = [tableView dequeueReusableCellWithIdentifier:@"CellId"];
    if (costumCell == nil)
    {
        NSArray *nib = nil;
        nib = [[NSBundle mainBundle] loadNibNamed:@"BuddySearchCell"owner:self options:nil];
        costumCell = [nib objectAtIndex:0];
    }
    costumCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [costumCell setSizeToFit];
    [costumCell addDelegate:self];
    costumCell.btnAddBuddy.tag = indexPath.row;
    
    SearchingBuddy * buddy = (SearchingBuddy*)[listFindedUsers objectAtIndex:indexPath.row];
    //****
    costumCell.lblBuddySecondName.text = [NSString stringWithFormat:@"%@ %@",buddy.userFirstName,buddy.userSecondName];
    costumCell.lblBuddyUserName.text = buddy.userName;
    //*****
    
    return costumCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BuddySearchCell * cell = (BuddySearchCell* )[self tableView:tableView cellForRowAtIndexPath:indexPath];
 
    return cell.frame.size.height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString * sectionTitle = @"      Search Results";
    return sectionTitle;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor colorWithRed:(199.0f/255.0f) green:(178.0f/255.0f) blue:(153.0f/255.0f) alpha:1.0f];
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor colorWithRed:(28.0f/255.0f) green:(29.0f/255.0f) blue:(9.0f/255.0f) alpha:1.0f]];
    [header.textLabel setFont:[UIFont fontWithName:@"Arial" size:12.0f]];
}


#pragma mark - AddBuddy protocol

- (IBAction)AddBuddy:(id)sender{
    NSLog(@"Buddy was added");
    
    NSIndexPath * numberAddUser = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    NSLog(@"Sec : %i Row : %i",numberAddUser.section,numberAddUser.row);
    //[self startLoader];
    
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        
        [dataLoader buddyAddWithName:[(SearchingBuddy* )[listFindedUsers objectAtIndex:[sender tag]] userName]];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            //[self endLoader];
            if(dataLoader.isCorrectRezult){
                [self.tblListOfFindedUsers beginUpdates];
                SearchingBuddy * friend = (SearchingBuddy* )[listFindedUsers objectAtIndex:[sender tag]];
                [listFindedUsers removeObjectAtIndex:[sender tag]];
                
                [self.tblListOfFindedUsers deleteRowsAtIndexPaths:[NSArray arrayWithObject:numberAddUser] withRowAnimation:UITableViewRowAnimationTop];
                [self.tblListOfFindedUsers endUpdates];
        
                [self.tblListOfFindedUsers reloadData];
                // * * *
                [self getInfoAboutNewBuddy:friend.userID];
            };
        });
    });
    
    // - - - - - - - - - - - - - - - - -
}

- (void)getInfoAboutNewBuddy:(NSString*)_userId{
    //[self startInternatIndicator];
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        
        [dataLoader buddyGetUserBuddyWithId:[_userId intValue]];
         dispatch_async(dispatch_get_main_queue(), ^(){
             //[self stopInternatIndicator];
             NSLog(@"Get info");
         });
    });
}

- (IBAction)returnToPreView:(id)sender {
    AppDelegate * appDel = [UIApplication sharedApplication].delegate;
    
    UINavigationController * controller = (UINavigationController*)appDel.window.rootViewController;
    id obj = [controller.viewControllers objectAtIndex:(controller.viewControllers.count - 2)];
    if([obj isKindOfClass:[BuddyListViewController class]]){
        BuddyListViewController * viewC = (BuddyListViewController*)[controller.viewControllers objectAtIndex:(controller.viewControllers.count - 2)];
        //[viewC setInitValueOfProperties];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addFindingUsers:(NSMutableArray *)_list{
    listFindedUsers = nil;
    listFindedUsers = [NSMutableArray new];
    listFindedUsers = [NSMutableArray arrayWithArray:_list];
}

- (void)addFindingUserToBuddies:(Buddy*)_buddy{
    AppDelegate * appDel = (AppDelegate* )[UIApplication sharedApplication].delegate;
    [appDel.listUserBuddies addObject:_buddy];
}

@end
