//
//  NewLog1ViewController.m
//  SMT
//
//  Created by Mac on 5/8/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "NewLog1ViewController.h"
#import "LogHistoryViewController.h"
#import "DataLoader.h"
#import "AppDelegate.h"
#import "Species.h"
#import "NewLog2ViewController.h"
#import "UIViewController+LoaderCategory.h"
#import "LogAnActivityViewController.h"

@interface NewLog1ViewController ()
{
    AppDelegate * appDelegate;
    DataLoader *loader;
    NSArray * array;
    Species * spec;
}
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tabBarWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *con1;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *con2;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *con3;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *con4;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *con5;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *con6;

- (void)actDownloadData;
@end

@implementation NewLog1ViewController

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
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        self.navigationBarHeightConstr.constant -= 20;
        self.navigationBarVerticalConstr.constant -=20;
    }

    self.navigationController.navigationBar.hidden = YES;
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    loader = [[DataLoader alloc]init];
    [self AddActivityIndicator:[UIColor grayColor] forView:self.view];
    
    UINib *cellNib = [UINib nibWithNibName:@"SpeciesCell" bundle:[NSBundle mainBundle]];
    [self.table registerNib:cellNib forCellReuseIdentifier:@"SpeciesCell"];

}

-(void) viewWillAppear:(BOOL)animated
{
    self.tabBarWidth.constant = self.view.frame.size.width;
    float f = self.view.frame.size.width - 180;
    self.con1.constant = f/6;
    self.con2.constant = f/6;
    self.con3.constant = f/6;
    self.con4.constant = f/6;
    self.con5.constant = f/6;
    self.con6.constant = f/6;
    [self.view updateConstraintsIfNeeded];
    [self actDownloadData];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return appDelegate.speciesList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SpeciesCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SpeciesCell"];
        
    [cell setSpecie:[appDelegate.speciesList objectAtIndex:indexPath.row]];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Select Species";
    }
    return @"";
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        spec = [appDelegate.speciesList objectAtIndex:indexPath.row];
        array = [[NSArray alloc]initWithArray:[loader getQuestionsWithSubSpecieId:[spec.specId intValue]]] ;
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            if(!loader.isCorrectRezult) {
                NSLog(@"Error download sybSpecie");
            } else {
                NSDictionary * dict = [[NSDictionary alloc]initWithObjectsAndKeys:spec, @"species", array, @"questions", nil];
                NewLog2ViewController * nlvc = [[NewLog2ViewController alloc]initWithNibName:@"NewLog2ViewController" bundle:nil andData:dict];
                [self.navigationController pushViewController:nlvc animated:YES];
            }
        });
    });
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) actDownloadData
{
    if ([appDelegate.speciesList firstObject] == nil) {
    [self startLoader];
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        
       [loader getAllSpecies];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            if(!loader.isCorrectRezult) {
                NSLog(@"Error download sybSpecie");
                [self endLoader];
            } else {
                [self.table reloadData];
                [self endLoader];
            }
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            {
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            }
        });
    });
    }
}

-(void) setIsPresent:(BOOL)present
{
    isPresent = present;
    if (isPresent) {
        [((UIButton *)[self.tabBar viewWithTag:1]) setBackgroundImage:[UIImage imageNamed:@"home_icon.png"] forState:UIControlStateNormal];
        [((UIButton *)[self.tabBar viewWithTag:2]) setBackgroundImage:[UIImage imageNamed:@"global_icon.png"] forState:UIControlStateNormal];
        [((UIButton *)[self.tabBar viewWithTag:3]) setBackgroundImage:[UIImage imageNamed:@"camera_icon.png"] forState:UIControlStateNormal];
        [((UIButton *)[self.tabBar viewWithTag:4]) setBackgroundImage:[UIImage imageNamed:@"note_icon_press.png"] forState:UIControlStateNormal];
        [((UIButton *)[self.tabBar viewWithTag:5]) setBackgroundImage:[UIImage imageNamed:@"st_icon.png"] forState:UIControlStateNormal];
    } else {
        [((UIButton *)[self.tabBar viewWithTag:1]) setBackgroundImage:[UIImage imageNamed:@"note_icon.png"] forState:UIControlStateNormal];
    }
}


@end
