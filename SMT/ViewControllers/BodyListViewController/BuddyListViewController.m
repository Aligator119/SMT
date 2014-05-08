//
//  BodyListViewController.m
//  SMT
//
//  Created by Mac on 4/29/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "BuddyListViewController.h"
#import "DataLoader.h"
#import "AppDelegate.h"
#import "Buddy.h"
#import "ConstantsClass.h"


#define FRIEND_LIST    @"   My buddies"
#define INCOMING_QWERY @"   Buddy incoming"
#define INVITE_FRIEND  @"   Buddy Requests"

#define CELL_HEIGTH           44
#define INCOMING_CELL_HEIGTTH 80

@interface BuddyListViewController ()
{
    int numberOfSection;
    NSArray * friendList;
    NSArray * incomingQwery;
    NSArray * inviteFriend;
    NSArray * allBuddyList;
    DataLoader * dataLoader;
}

@property (weak, nonatomic) IBOutlet UITableView *table;

- (IBAction)actButtonBack:(UIButton *)sender;
- (IBAction)actButtonAdd:(UIButton *)sender;
- (void)actDone:(UIButton *)sender;
- (void)actAccept:(UIButton *)sender;
- (void)actHidden:(UIButton *)sender;
@end

@implementation BuddyListViewController

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
    dataLoader = [DataLoader instance];
    
    [dataLoader buddyGetListUsersBuddies];

    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        self.navigationBarHeightConstr.constant -= 20;
        self.navigationBarVerticalConstr.constant -=20;
    }
//--------------------------------------------------------------------------------------------------------------------
    NSMutableArray * array = [[NSMutableArray alloc]init];
    AppDelegate * app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSMutableArray * buddies = [NSMutableArray new];
    NSMutableArray * pendingBuddies = [NSMutableArray new];
    NSMutableArray * buddiesReceived = [NSMutableArray new];
    
    for (Buddy * buddy in app.listUserBuddies) {
        if([buddy.userRelation isEqualToString:StatusAccepted]){
            [buddies addObject:buddy];
        } else if([buddy.userRelation isEqualToString:StatusSent]){  //@"REQUEST_SENT"
            [pendingBuddies addObject:buddy];
        } else if([buddy.userRelation isEqualToString:StatusReceived]){
            [buddiesReceived addObject:buddy];
        }
    }
   
    friendList = [[NSArray alloc]initWithArray:buddies];
    if (friendList.count) {
        [array addObject:friendList];
    }
    incomingQwery = [[NSArray alloc]initWithArray:buddiesReceived];
    if (incomingQwery.count) {
        [array addObject:incomingQwery];
    }
    inviteFriend = [[NSArray alloc]initWithArray:pendingBuddies];
    if (inviteFriend.count) {
        [array addObject:inviteFriend];
    }
    
    allBuddyList = [[NSArray alloc]initWithArray:array];
//--------------------------------------------------------------------------------------------------------------------
    
    UINib *cellNib1 = [UINib nibWithNibName:@"Cell" bundle:[NSBundle mainBundle]];
    [self.table registerNib:cellNib1 forCellReuseIdentifier:@"Cell"];
    UINib *cellNib2 = [UINib nibWithNibName:@"InviteFriendCell" bundle:[NSBundle mainBundle]];
    [self.table registerNib:cellNib2 forCellReuseIdentifier:@"InviteFriendCell"];
    UINib *cellNib3 = [UINib nibWithNibName:@"IncomingFriendCell" bundle:[NSBundle mainBundle]];
    [self.table registerNib:cellNib3 forCellReuseIdentifier:@"IncomingFriendCell"];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return allBuddyList.count;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * array = [allBuddyList objectAtIndex:section];
    return array.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;// = nil;
    NSArray * buffer = [allBuddyList objectAtIndex:indexPath.section];
    Buddy * buddy = [buffer objectAtIndex:indexPath.row];
   if ([buddy.userRelation isEqualToString:StatusReceived]) {
       
            cell = [tableView dequeueReusableCellWithIdentifier:@"IncomingFriendCell"];
            if (!cell) {
                cell = [[IncomingFriendCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"IncomingFriendCell"];
            }
            ((IncomingFriendCell *)cell).lbFriendName.text = buddy.userFirstName;
            [((IncomingFriendCell *)cell).btnDone addTarget:self action:@selector(actDone:) forControlEvents:UIControlEventTouchUpInside];
            [((IncomingFriendCell *)cell).btnAccept addTarget:self action:@selector(actAccept:) forControlEvents:UIControlEventTouchUpInside];
        }
    
            
        if ([buddy.userRelation isEqualToString:StatusAccepted])
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
            if (!cell) {
                cell = [[Cell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"Cell"];
            }
            ((Cell *)cell).lbFriendName.text = buddy.userFirstName;
            ((Cell *)cell).detailTextLabel.text = buddy.userSecondName;
        }
    
            
        if ([buddy.userRelation isEqualToString:StatusSent])
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"InviteFriendCell"];
            if (!cell) {
                cell = [[InviteFriendCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"InviteFriendCell"];
            }
            ((InviteFriendCell *)cell).lbFriendName.text = buddy.userFirstName;
            ((Cell *)cell).detailTextLabel.text = buddy.userSecondName;
            [((InviteFriendCell *)cell).btnHidde addTarget:self action:@selector(actHidden:) forControlEvents:UIControlEventTouchUpInside];
        }
    
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString * str;
    Buddy * buf = [[allBuddyList objectAtIndex:section] firstObject];
    if ([buf.userRelation isEqualToString:StatusReceived]) {
        str = @"   Buddy Requests";
    } else if ([buf.userRelation isEqualToString:StatusSent]) {
        str = @"   Request Sent";
    } else if ([buf.userRelation isEqualToString:StatusAccepted]){
        str = @"   My buddies";
    }
    return str;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heigth = 0.0;
    Buddy * buf = [[allBuddyList objectAtIndex:indexPath.section] firstObject];
    if ([buf.userRelation isEqualToString:StatusReceived]) {
        heigth = INCOMING_CELL_HEIGTTH;
    } else {
            heigth = CELL_HEIGTH;
    }
    return heigth;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actButtonBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actButtonAdd:(UIButton *)sender
{
    NSLog(@"Add");
}

- (void)actDone:(UIButton *)sender
{
    NSLog(@"Done");
}

- (void)actAccept:(UIButton *)sender
{
    NSLog(@"Accept");
}

- (void)actHidden:(UIButton *)sender
{
    NSLog(@"Hidde");
}


@end
