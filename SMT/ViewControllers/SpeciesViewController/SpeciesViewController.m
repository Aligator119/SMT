//
//  SpeciesViewController.m
//  SMT
//
//  Created by Alexander on 06.05.14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "SpeciesViewController.h"
#import "Species.h"
#import "UIImageView+AFNetworking.h"
#import "DataLoader.h"
#import "AppDelegate.h"
#import "SettingsViewController.h"
#import "UIViewController+LoaderCategory.h"

@interface SpeciesViewController ()
{
    AppDelegate *appDelegate;
}
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *navigationBarHeightConstr;

@end

@implementation SpeciesViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        self.navigationBarHeightConstr.constant -= 20;
        //self.navigationBarVerticalConstr.constant -=20;
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    DataLoader *loader = [[DataLoader alloc]init];
    if ([appDelegate.speciesList firstObject] == nil) {
        [loader getAllSpecies];
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return appDelegate.speciesList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    Species *species = (Species*)[appDelegate.speciesList objectAtIndex:indexPath.row];
    [cell.imageView setFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    NSURL * url = [NSURL URLWithString:species.thumbnail];
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    
    cell.textLabel.text = species.name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<SpeciesViewControllerDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(selectSpecies:)]) {
        [delegate selectSpecies:[appDelegate.speciesList objectAtIndex:indexPath.row]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
