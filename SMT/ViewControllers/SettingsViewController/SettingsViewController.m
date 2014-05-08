//
//  SettingsViewController.m
//  SMT
//
//  Created by Alexander on 06.05.14.
//  Copyright (c) 2014 Mac. All rights reserved.
//
#import "SettingsViewController.h"
#import "DataLoader.h"
#import "AppDelegate.h"
#import "UIViewController+LoaderCategory.h"

#define DEFAULT_LOCATION @"default_location"
#define DEFAULT_SPECIES @"default_species"

@interface SettingsViewController ()
{
    NSUserDefaults *settings;
    AppDelegate *appDelegate;
}

@property (strong, nonatomic) Location *selectedLocation;
@property (strong, nonatomic) Species *selectedSpecies;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * navigationBarHeightConstr;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * navigationBarVerticalConstr;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIButton *speciesButton;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        self.navigationBarHeightConstr.constant -= 20;
        self.navigationBarVerticalConstr.constant -=20;
    }
    appDelegate = [UIApplication sharedApplication].delegate;
    
    settings = [NSUserDefaults standardUserDefaults];
    
    self.selectedLocation = [self defaultLocation];
    self.selectedSpecies = [self defaultSpecies];
 
    [self setupButtonsTitles];
}

- (void) setupButtonsTitles{
    if (self.selectedLocation.locName == nil) {
        [self.locationButton setTitle:@"Select Default Location" forState:UIControlStateNormal];
    }
    else{
        [self.locationButton setTitle:self.selectedLocation.locName forState:UIControlStateNormal];
    }
    
    if (self.selectedSpecies.name == nil) {
        [self.speciesButton setTitle:@"Select Default Species" forState:UIControlStateNormal];
    }
    else{
        [self.speciesButton setTitle:self.selectedSpecies.name forState:UIControlStateNormal];
    }
}

- (IBAction)backTomenuButtonTap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)changeLocationTap:(id)sender {
    SelectLocationViewController *locationsList = [[SelectLocationViewController alloc]init];
    locationsList.delegate = self;
    [self.navigationController pushViewController:locationsList animated:YES];
}

- (IBAction)changeDefaultSpeciesTap:(id)sender {
    SpeciesViewController *speciesList = [[SpeciesViewController alloc]init];
    speciesList.delegate = self;
    [self.navigationController pushViewController:speciesList animated:YES];
}

- (IBAction)cancelButtonTap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveSettingsButtonTap:(id)sender {
    [self saveLocation:self.selectedLocation];
    [self saveSpecies:self.selectedSpecies];
    [self.navigationController popViewControllerAnimated:YES];
}

- (Location*)defaultLocation
{
        return [NSKeyedUnarchiver unarchiveObjectWithData:[settings objectForKey:DEFAULT_LOCATION]];
}

- (Species*)defaultSpecies
{
        return [NSKeyedUnarchiver unarchiveObjectWithData:[settings objectForKey:DEFAULT_SPECIES]];
}

- (void)saveLocation:(Location*)location
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:location];
    [settings setObject:encodedObject forKey:DEFAULT_LOCATION];
    [settings synchronize];
}

- (void)saveSpecies:(Species*)species
{
    appDelegate.defaultLocation = self.selectedLocation;
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:species];
    [settings setObject:encodedObject forKey:DEFAULT_SPECIES];
    [settings synchronize];
}

-(void)selectLocation:(Location *)location
{
    self.selectedLocation = location;
    [self.locationButton setTitle:self.selectedLocation.locName forState:UIControlStateNormal];
}

- (void)selectSpecies:(Species *)species
{
    self.selectedSpecies = species;
    [self.speciesButton setTitle:self.selectedSpecies.name forState:UIControlStateNormal];
}


@end

