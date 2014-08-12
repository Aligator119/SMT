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
#define USER_DATA @"userdata"

@interface SettingsViewController ()
{
    NSUserDefaults *settings;
    AppDelegate *appDelegate;
    DataLoader * dataLoader;
}

@property (strong, nonatomic) IBOutlet UITextField *tfOldPassword;
@property (strong, nonatomic) IBOutlet UITextField *tfNewPassworld_1;
@property (strong, nonatomic) IBOutlet UITextField *tfNewPassworld_2;
@property (strong, nonatomic) Location *selectedLocation;
@property (strong, nonatomic) Species *selectedSpecies;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * navigationBarHeightConstr;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * navigationBarVerticalConstr;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIButton *speciesButton;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        self.navigationBarHeightConstr.constant -= 20;
        self.navigationBarVerticalConstr.constant -=20;
    }
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    settings = [NSUserDefaults standardUserDefaults];
    
    self.selectedLocation = [self defaultLocation];
    self.selectedSpecies = [self defaultSpecies];
 
    [self setupButtonsTitles];
    
    self.screenName = @"Setting screen";
    
    dataLoader = [DataLoader instance];
    
    MenuViewController * menuController = self.revealViewController;
    
    [self.view addGestureRecognizer:menuController.panGestureRecognizer];
    [_menuButton addTarget:menuController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
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
    if (self.tfOldPassword.text.length && self.tfNewPassworld_1.text.length && self.tfNewPassworld_2.text.length) {
        if ([self.tfOldPassword.text isEqualToString:appDelegate.user.userPassword]) {
            if ([self.tfNewPassworld_1.text isEqualToString:self.tfNewPassworld_2.text]) {
                [self startLoader];
                dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(newQueue, ^(){
                
                    [dataLoader changeUserPassworld:self.tfNewPassworld_1.text];
                    dispatch_async(dispatch_get_main_queue(), ^(){
                    
                        if(!dataLoader.isCorrectRezult) {
                            NSLog(@"Error change passworld");
                            [self endLoader];
                        } else {
                            appDelegate.user.userPassword = self.tfNewPassworld_1.text;
                            [settings removeObjectForKey:USER_DATA];
                            [settings synchronize];
                            NSData * data = [NSKeyedArchiver archivedDataWithRootObject:appDelegate.user];
                            [settings setObject:data forKey:USER_DATA];
                            [settings synchronize];
                            [self endLoader];
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    });
                });

            } else {
                [[[UIAlertView alloc]initWithTitle:@"Warning" message:@"Incoming passwords are not the same" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            }
        } else {
            [[[UIAlertView alloc]initWithTitle:@"Warning" message:@"Incoming old password are not the same" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

@end

