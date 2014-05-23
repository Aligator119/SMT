//
//  InviteFriendViewController.m
//  HunterPredictor
//
//  Created by Admin on 4/2/14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import "InviteFriendViewController.h"
#import "InviteCell.h"
#import <AddressBook/AddressBook.h>
#import "DataLoader.h"
#import "Buddy.h"
#import "AppDelegate.h"

@interface InviteFriendViewController (){
    NSMutableArray * contactList;
    NSMutableArray * filteredContactList;
}

@property (nonatomic, weak) IBOutlet UITableView * tableView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint * heightConstr;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * verticalConstr;
@property (nonatomic, weak) IBOutlet UIView * navBarView;

@property (nonatomic, strong) UISearchBar * searchBar;
@property (nonatomic, strong) UISearchDisplayController * strongSearchDisplayController;

@end

@implementation InviteFriendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.screenName = @"InviteContacts";
    
    self.navigationController.navigationBar.hidden = YES;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        self.heightConstr.constant -=20;
        self.verticalConstr.constant -= 20;
    }
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"InviteFriendCell" bundle:nil] forCellReuseIdentifier:@"InviteFriendCell"];
    [self getContactList];
    [self setupSearchBar];
}

-(void) viewDidLayoutSubviews{
    self.tableView.contentOffset = CGPointMake(0, CGRectGetHeight(self.searchBar.bounds));
}

-(void) getContactList{
    contactList = [[NSMutableArray alloc] init];
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    ABAddressBookRequestAccessWithCompletion(addressBook, (ABAddressBookRequestAccessCompletionHandler)^(BOOL granted, CFErrorRef error){
        dispatch_semaphore_signal(sema);
    });
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex peopleCount = ABAddressBookGetPersonCount(addressBook);
    
    for (int i = 0; i < peopleCount; i++){
        NSMutableDictionary * userInfo = [NSMutableDictionary new];
        
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople, i);
        
        //get first last names
        NSString * firstName = (__bridge_transfer NSString*)ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        firstName = firstName ? firstName : @"";
        NSString* lastName =(__bridge_transfer NSString*) ABRecordCopyValue(ref, kABPersonLastNameProperty);
        lastName = lastName ? lastName : @"";
        [userInfo setValue:[NSString stringWithFormat:@"%@ %@", firstName, lastName] forKey:@"name"];
        
        // get email
        ABMutableMultiValueRef email = ABRecordCopyValue(ref, kABPersonEmailProperty);
        if (ABMultiValueGetCount(email) > 0){
            NSString * emailString = (__bridge NSString*)ABMultiValueCopyValueAtIndex(email, 0);
            [userInfo setObject:emailString forKey:@"email"];
            if ([self isUserInBuddyList:emailString]){
                [contactList addObject:userInfo];
            }
        }
        
       if (ref) CFRelease(ref);
    }
    if (addressBook) CFRelease(addressBook);
}

-(BOOL) isUserInBuddyList: (NSString * ) _email{
    AppDelegate * appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    for (Buddy * buddy in appDel.listUserBuddies){
        if ([buddy.userName isEqualToString:_email]){
            return NO;
        }
    }
    return YES;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InviteCell * cell = (InviteCell*) [tableView dequeueReusableCellWithIdentifier:@"InviteFriendCell" forIndexPath:indexPath];
        NSMutableDictionary * userInfo;
    if (cell == nil){
        cell = [[InviteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InviteFriendCell"];
    }
    if (tableView == self.tableView){
        userInfo  = [contactList objectAtIndex:indexPath.row];
    }
    else{
        userInfo  = [filteredContactList objectAtIndex:indexPath.row];
    }
    [cell processCellWithName: [userInfo objectForKey:@"name"] andEmail:[userInfo objectForKey:@"email"]];
    return cell;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableView){
        return contactList.count;
    }
    else{
        return filteredContactList.count;
    }
}

-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupSearchBar
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    self.searchBar.placeholder = @"Search";
    self.searchBar.delegate = self;
    self.searchBar.tintColor = [UIColor colorWithRed:175.0/255.0 green:220.0/255.0 blue:198.0/255.0 alpha:1.0];
    [self.searchBar setBackgroundImage:[UIImage imageNamed:@"search_bar_invite_bg"]];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTintColor:[UIColor colorWithRed:120.0/255.0 green:135.0/255.0 blue:160.0/255.0 alpha:1.0] ];
    [self.searchBar sizeToFit];
     CGRect superviewRect = self.searchDisplayController.searchBar.superview.frame;
      superviewRect.origin.y = 0;
     self.searchDisplayController.searchBar.superview.frame = superviewRect;
    self.strongSearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.delegate = self;
    self.tableView.tableHeaderView = self.searchBar;
    
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSString *predicateSearchString = [NSString stringWithFormat:@"(name BEGINSWITH[cd] '%@')", searchString];
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:predicateSearchString];
    
    filteredContactList = [NSMutableArray arrayWithArray:[contactList filteredArrayUsingPredicate:searchPredicate]];
    return YES;
}

-(void) searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView{
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"InviteFriendCell" bundle:nil] forCellReuseIdentifier:@"InviteFriendCell"];

}

-(void) searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        controller.searchResultsTableView.frame = self.tableView.frame;
        controller.searchResultsTableView.separatorInset = UIEdgeInsetsZero;
    }
}


@end
