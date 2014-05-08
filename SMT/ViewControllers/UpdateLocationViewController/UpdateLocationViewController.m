//
//  HPUpdateLocationViewController.m
//  HunterPredictor
//
//  Created by Admin on 1/27/14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import "UpdateLocationViewController.h"
#import "AppDelegate.h"
#import "DataLoader.h"
#import "Location.h"
#import "MapViewController.h"

@interface UpdateLocationViewController (){
    AppDelegate * appDel;
    DataLoader * loader;
}

@property (nonatomic, weak) IBOutlet NSLayoutConstraint * heightConstr;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * verticalConstr;
@property (nonatomic, weak) IBOutlet UITextField * locNameTextField;

@property (nonatomic, weak) IBOutlet UIView * updateNameView;
@property (nonatomic, weak) IBOutlet UIView * coordinatesView;
@property (nonatomic, weak) IBOutlet UIButton * deleteButton;

@property (nonatomic, weak) IBOutlet UILabel * latitudeLabel;
@property (nonatomic, weak) IBOutlet UILabel * longitudeLabel;

@end

@implementation UpdateLocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        self.heightConstr.constant -=20;
        self.verticalConstr.constant -= 20;
    }
    
    appDel = (AppDelegate*) [UIApplication sharedApplication].delegate;
    loader = [DataLoader instance];
    
    self.locNameTextField.text = self.location.locName;
    
    self.updateNameView.layer.cornerRadius = 6;
    self.coordinatesView.layer.cornerRadius = 6;
    self.deleteButton.layer.cornerRadius = 6;
    
    self.latitudeLabel.text = [NSString stringWithFormat:@"Latitude: %f", self.location.locLatitude];
    self.longitudeLabel.text = [NSString stringWithFormat:@"Longitude: %f", self.location.locLongitude];
    
}

-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)delete:(id)sender{
    
    [loader deleteLocationWithID:self.location.locID];
    if (loader.isCorrectRezult){
        [appDel.listLocations removeObject:self.location];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction)save:(id)sender{
    NSString *newName = self.locNameTextField.text;
    NSString * trimmedNewName = [newName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString * lat = [NSString stringWithFormat:@"%f", self.location.locLatitude];
    NSString * lng = [NSString stringWithFormat:@"%f", self.location.locLongitude];
    [loader updateChooseLocation:self.location.locID newName:trimmedNewName newLati:lat newLong:lng];
    if (loader.isCorrectRezult){
        for(int i = self.navigationController.viewControllers.count-1; i > 0; i--){
            UIViewController * vc = [self.navigationController.viewControllers objectAtIndex:i];
            if ([vc isKindOfClass:[MapViewController class]]){
                [self.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

@end
