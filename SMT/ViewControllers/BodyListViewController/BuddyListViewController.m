//
//  BodyListViewController.m
//  SMT
//
//  Created by Mac on 4/29/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "BuddyListViewController.h"


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
}

@property (weak, nonatomic) IBOutlet UITableView *table;

- (void)actButtonBack:(UIButton *)sender;
- (void)actButtonAdd:(UIButton *)sender;
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
    
    UIButton * btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, 60, 40);
    UIImage * btnBackImage = [UIImage imageNamed:@"back_arrow.png"];
    [btnBack setImage:btnBackImage forState:UIControlStateNormal];
    [btnBack setImage:btnBackImage forState:UIControlStateSelected];
    [btnBack addTarget:self action:@selector(actButtonBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * back = [[UIBarButtonItem alloc]initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = back;
//--------------------------------------------------------------------------------------------------------------------
    UIButton * btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAdd.frame = CGRectMake(280, 0, 40, 40);
    [btnAdd setTitle:@"Add" forState:UIControlStateNormal];
    [btnAdd setTitle:@"Add" forState:UIControlStateSelected];
    [btnAdd setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnAdd addTarget:self action:@selector(actButtonAdd:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * add = [[UIBarButtonItem alloc]initWithCustomView:btnAdd];
    self.navigationItem.rightBarButtonItem = add;
//--------------------------------------------------------------------------------------------------------------------
    NSMutableArray * array = [[NSMutableArray alloc]init];
    NSDictionary * dict1 = [[NSDictionary alloc]initWithObjectsAndKeys:@"myFriend)))", @"name", FRIEND_LIST, @"type", nil];
     NSDictionary * dict = [[NSDictionary alloc]initWithObjectsAndKeys:@"myFriend#2$", @"name", FRIEND_LIST, @"type", nil];
    friendList = [[NSArray alloc]initWithObjects:dict1, dict, nil];
    if (friendList) {
        [array addObject:friendList];
    }
    NSDictionary * dict2 = [[NSDictionary alloc]initWithObjectsAndKeys:@"incoming", @"name", INCOMING_QWERY, @"type", nil];
    incomingQwery = [[NSArray alloc]initWithObjects:dict2, nil];
    if (incomingQwery) {
        [array addObject:incomingQwery];
    }
    NSDictionary * dict3 = [[NSDictionary alloc]initWithObjectsAndKeys:@"invite friend", @"name", INVITE_FRIEND, @"type", nil];
    inviteFriend = [[NSArray alloc]initWithObjects:dict3, nil];
    if (inviteFriend) {
        [array addObject:inviteFriend];
    }
    
    
    
    
    allBuddyList = [[NSArray alloc]initWithArray:array];
    
    
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
    
   if ([INCOMING_QWERY isEqualToString:[[buffer objectAtIndex:indexPath.row] objectForKey:@"type"]]) {
       
            cell = [tableView dequeueReusableCellWithIdentifier:@"IncomingFriendCell"];
            if (!cell) {
                cell = [[IncomingFriendCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"IncomingFriendCell"];
            }
            ((IncomingFriendCell *)cell).lbFriendName.text = [[buffer objectAtIndex:indexPath.row] objectForKey:@"name"];
            [((IncomingFriendCell *)cell).btnDone addTarget:self action:@selector(actDone:) forControlEvents:UIControlEventTouchUpInside];
            [((IncomingFriendCell *)cell).btnAccept addTarget:self action:@selector(actAccept:) forControlEvents:UIControlEventTouchUpInside];
        }
    
            
        if ([FRIEND_LIST isEqualToString:[[buffer objectAtIndex:indexPath.row] objectForKey:@"type"]])
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
            if (!cell) {
                cell = [[Cell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"Cell"];
            }
            ((Cell *)cell).lbFriendName.text = [[buffer objectAtIndex:indexPath.row] objectForKey:@"name"];
            //cell.detailTextLabel.text = @"detail info";
        }
    
            
        if ([INVITE_FRIEND isEqualToString:[[buffer objectAtIndex:indexPath.row] objectForKey:@"type"]])
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"InviteFriendCell"];
            if (!cell) {
                cell = [[InviteFriendCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"InviteFriendCell"];
            }
            ((InviteFriendCell *)cell).lbFriendName.text = [[buffer objectAtIndex:indexPath.row] objectForKey:@"name"];
            [((InviteFriendCell *)cell).btnHidde addTarget:self action:@selector(actHidden:) forControlEvents:UIControlEventTouchUpInside];
        }
    
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return [[[allBuddyList objectAtIndex:section] firstObject] objectForKey:@"type"];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heigth = 0.0;
    
    if ([[[[allBuddyList objectAtIndex:indexPath.section] firstObject] objectForKey:@"type"] isEqualToString:INCOMING_QWERY]) {
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

- (void)actButtonBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actButtonAdd:(UIButton *)sender
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
