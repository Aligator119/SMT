//
//  HPUpdateLocationViewController.m
//  HunterPredictor
//
//  Created by Admin on 1/27/14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import "BaseLocationViewController.h"
#import "AppDelegate.h"
#import "DataLoader.h"
#import "Location.h"
#import "MapViewController.h"

@interface BaseLocationViewController (){
    AppDelegate * appDel;
    DataLoader * loader;
}

@property (nonatomic, weak) IBOutlet NSLayoutConstraint * heightConstr;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * verticalConstr;
@property (nonatomic, weak) IBOutlet UITextField * locNameTextField;

@property (nonatomic, weak) IBOutlet UIView * updateNameView;
@property (nonatomic, weak) IBOutlet UIView * coordinatesView;
@property (nonatomic, weak) IBOutlet UIButton * deleteButton;

@property (strong, nonatomic) IBOutlet UILabel *lbGroup;
@property (strong, nonatomic) IBOutlet UILabel *lbType;
@property (strong, nonatomic) IBOutlet UILabel *lbAdress;
@property (strong, nonatomic) IBOutlet UILabel *lbCoordinate;
@property (strong, nonatomic) IBOutlet UIImageView *image;

@end

@implementation BaseLocationViewController

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
    
    NSString * title = [NSString stringWithFormat:@"Lat/Lng "];
    
    NSString * data = [[[NSString stringWithFormat:@"%f",self.location.locLatitude] stringByAppendingString:@", "] stringByAppendingString:[NSString stringWithFormat:@"%f", self.location.locLongitude]];
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@", title, data]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,title.length)];
    [self.lbCoordinate setAttributedText:str];
    
    
    if (self.location.typeLocation == 1) {
        self.lbType.text = @"Hunting Location";
    } else {
        self.lbType.text = @"Fishing Location";
    }
    self.lbGroup.text = self.location.locationGroup;
    self.lbAdress.text = self.location.addres;
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
