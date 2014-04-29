//
//  BodyListViewController.m
//  SMT
//
//  Created by Mac on 4/29/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "BuddyListViewController.h"


#define FRIEND_LIST    1
#define INCOMING_QWERY 0
#define INVITE_FRIEND  2

@interface BuddyListViewController ()
{
    int numberOfSection;
    NSArray * friendList;
    NSArray * incomingQwery;
    NSArray * inviteFriend;
}

@property (weak, nonatomic) IBOutlet UITableView *table;

- (void)actButtonBack:(UIButton *)sender;
- (void)actButtonAdd:(UIButton *)sender;
- (void)actDone:(UIButton *)sender;
- (void)actAccept:(UIButton *)sender;
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
    
    friendList = [[NSArray alloc]initWithObjects:@"myFriend)))", nil];
    incomingQwery = [[NSArray alloc]initWithObjects:@"incoming", nil];
    inviteFriend = [[NSArray alloc]initWithObjects:@"invite friend", nil];
    
    numberOfSection = 0;
    numberOfSection = friendList.count>0 ? numberOfSection+1 : numberOfSection;
    numberOfSection = inviteFriend.count>0 ? numberOfSection+1 : numberOfSection;
    numberOfSection = incomingQwery.count>0 ? numberOfSection+1 : numberOfSection;
    
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
    return numberOfSection;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int number = 0;
    switch (section) {
        case INCOMING_QWERY:
            number = incomingQwery.count;
            break;
            
        case FRIEND_LIST:
            number = friendList.count;
            break;
            
        case INVITE_FRIEND:
            number = inviteFriend.count;
            break;
    }
    return number;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;// = nil;
    switch (indexPath.section) {
        case INCOMING_QWERY:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"IncomingFriendCell"];
            if (!cell) {
                cell = [[IncomingFriendCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"IncomingFriendCell"];
            }
            ((IncomingFriendCell *)cell).lbFriendName.text = [incomingQwery firstObject];
            [((IncomingFriendCell *)cell).btnDone addTarget:self action:@selector(actDone:) forControlEvents:UIControlEventTouchUpInside];
            [((IncomingFriendCell *)cell).btnAccept addTarget:self action:@selector(actAccept:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
            
        case FRIEND_LIST:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
            if (!cell) {
                cell = [[Cell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"Cell"];
            }
            ((Cell *)cell).lbFriendName.text = [friendList firstObject];
            //cell.detailTextLabel.text = @"detail info";
        }
            break;
            
        case INVITE_FRIEND:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"InviteFriendCell"];
            if (!cell) {
                cell = [[InviteFriendCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"InviteFriendCell"];
            }
            ((InviteFriendCell *)cell).lbFriendName.text = [inviteFriend firstObject];
        }
            break;
    }
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString * str;
    switch (section) {
        case INCOMING_QWERY:
            str = @"   Buddy Requests";
            break;
            
        case FRIEND_LIST:
            str = @"   My buddies";
            break;
        case INVITE_FRIEND:
            str = @"   Buddy incoming";
            break;
    }
    return str;
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




@end
