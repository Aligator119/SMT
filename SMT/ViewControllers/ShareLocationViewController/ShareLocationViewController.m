//
//  ShareLocationViewController.m
//  SMT
//
//  Created by Mac on 6/12/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "ShareLocationViewController.h"
#import "DataLoader.h"
#import "AppDelegate.h"
#import "UIViewController+LoaderCategory.h"

@interface ShareLocationViewController ()
{
    Location * _location;
    DataLoader * dataLoader;
    AppDelegate * appDelegate;
    NSArray * buddyShareds;
    NSMutableArray * idBuddyShareds;
    NSMutableDictionary * dictionary;
}
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *navigationBarHeightConstr;
@property (strong, nonatomic) IBOutlet UITableView *table;
- (IBAction)actBack:(id)sender;
- (void)actChack:(UIButton *)sender;
- (UIButton *)addChackButtonAndChek:(BOOL)flag andIndex:(int)row;
- (void) getSharedsBuddyWithLocationID:(Location *)loc;
@end

@implementation ShareLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andLocation:(Location *)location
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _location = location;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        self.navigationBarHeightConstr.constant -= 20;
    }
    [self AddActivityIndicator:[UIColor grayColor] forView:self.view];
    dataLoader = [DataLoader instance];
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.listUserBuddies.firstObject == nil) {
        [dataLoader buddyGetListUsersBuddies];
    }
    
    dictionary = [NSMutableDictionary new];
    [self getSharedsBuddyWithLocationID:_location];
    self.screenName = @"Shared location screen";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return appDelegate.listUserBuddies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Buddy * buddy = [appDelegate.listUserBuddies objectAtIndex:indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }

    NSString * currentID = [NSString stringWithFormat:@"%@",buddy.userID];
    if ([idBuddyShareds containsObject:currentID]) {
        [cell addSubview:[self addChackButtonAndChek:YES andIndex:indexPath.row]];
        cell.tag = 1;
    } else {
        [cell addSubview:[self addChackButtonAndChek:NO andIndex:indexPath.row]];
        cell.tag = 0;
    }
    cell.textLabel.text = buddy.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIButton *)addChackButtonAndChek:(BOOL)flag andIndex:(int)row
{
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(280.0, 7.0, 30.0, 30.0)];
    btn.layer.masksToBounds = YES;
    btn.layer.borderWidth = 1.0f;
    btn.layer.borderColor = [UIColor grayColor].CGColor;
    if (flag) {
        [btn setBackgroundImage:[UIImage imageNamed:@"chek"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"chek"] forState:UIControlStateHighlighted];
        btn.tag = row;
    } else {
        [btn setBackgroundImage:[UIImage imageNamed:@"unchek"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"unchek"] forState:UIControlStateHighlighted];
        btn.tag = row;
    }
    [btn addTarget:self action:@selector(actChack:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)actChack:(UIButton *)sender
{
   
    [self startLoader];
    sender.enabled = NO;
    if (sender.superview.superview.tag) {
        // remove buddy of list shared
        
        dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(newQueue, ^(){
             NSDictionary * result;
            Buddy * buf = [appDelegate.listUserBuddies objectAtIndex:sender.tag];
            result = [dataLoader unsharedLocation:_location.locID andWithBuddy:[buf.userID intValue]];
            
            dispatch_async(dispatch_get_main_queue(), ^(){
                
                if(!dataLoader.isCorrectRezult) {
                    NSLog(@"Error shared %@",result);
                    [sender setBackgroundImage:[UIImage imageNamed:@"chek"] forState:UIControlStateNormal];
                    [sender setBackgroundImage:[UIImage imageNamed:@"chek"] forState:UIControlStateHighlighted];
                } else {
                    NSLog(@"shared %@",result);
                    sender.superview.superview.tag = 0;
                    [sender setBackgroundImage:[UIImage imageNamed:@"unchek"] forState:UIControlStateNormal];
                    [sender setBackgroundImage:[UIImage imageNamed:@"unchek"] forState:UIControlStateHighlighted];
                    //[self getSharedsBuddyWithLocationID:_location];
                    [idBuddyShareds removeObject:[NSString stringWithFormat:@"%@",buf.userID]];
                    sender.enabled = YES;
                    [self.table reloadData];
                    [self endLoader];
                }
            });
        });

    } else {
        // add buddy of list shared
        [sender setBackgroundImage:[UIImage imageNamed:@"chek"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"chek"] forState:UIControlStateHighlighted];
        dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(newQueue, ^(){
            NSDictionary * result;
            Buddy * buf = [appDelegate.listUserBuddies objectAtIndex:sender.tag];
            result = [dataLoader sharedLocation:_location.locID  andWithBuddy:[buf.userID intValue]];
            
            dispatch_async(dispatch_get_main_queue(), ^(){
                
                if(!dataLoader.isCorrectRezult) {
                    NSLog(@"Error shared %@",result);
                    [sender setBackgroundImage:[UIImage imageNamed:@"unchek"] forState:UIControlStateNormal];
                    [sender setBackgroundImage:[UIImage imageNamed:@"unchek"] forState:UIControlStateHighlighted];
                } else {
                    NSLog(@"shared %@",result);
                    sender.superview.superview.tag = 1;
                    [sender setBackgroundImage:[UIImage imageNamed:@"chek"] forState:UIControlStateNormal];
                    [sender setBackgroundImage:[UIImage imageNamed:@"chek"] forState:UIControlStateHighlighted];
                    //[self getSharedsBuddyWithLocationID:_location];
                    [idBuddyShareds addObject:[NSString stringWithFormat:@"%@",buf.userID]];
                    sender.enabled = YES;
                    [self.table reloadData];
                    [self endLoader];
                }
            });
        });
    }
}


- (void) getSharedsBuddyWithLocationID:(Location *)loc;
{
    buddyShareds = [dataLoader getBuddySharedLocationWithID:[NSString stringWithFormat:@"%d",loc.locID]];
    idBuddyShareds = [[NSMutableArray alloc]init];
    for (Buddy * bud in buddyShareds) {
        [idBuddyShareds addObject:bud.userID];
    }
}


@end
