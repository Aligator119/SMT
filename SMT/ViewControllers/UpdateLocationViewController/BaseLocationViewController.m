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
#import "ShareLocationViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface BaseLocationViewController (){
    AppDelegate * appDel;
    DataLoader * loader;
    GMSMapView *mapView_;
    
}

@property (nonatomic, weak) IBOutlet NSLayoutConstraint * heightConstr;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * verticalConstr;
@property (nonatomic, weak) IBOutlet UITextField * locNameTextField;

@property (nonatomic, weak) IBOutlet UIView * updateNameView;
@property (nonatomic, weak) IBOutlet UIView * coordinatesView;
@property (nonatomic, weak) IBOutlet UIButton * deleteButton;
@property (nonatomic, weak) IBOutlet UIButton *shareButton;

@property (weak, nonatomic) IBOutlet UILabel *lbGroup;
@property (weak, nonatomic) IBOutlet UILabel *lbType;
@property (weak, nonatomic) IBOutlet UILabel *lbAdress;
@property (weak, nonatomic) IBOutlet UILabel *lbCoordinate;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (nonatomic, weak) IBOutlet UIView *mapContainerView;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *activeTextField;
- (IBAction)actShared:(id)sender;

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
    
    if (self.location.locUserId != appDel.user.userID){
        self.saveButton.hidden = YES;
        self.deleteButton.hidden = YES;
        self.shareButton.hidden = YES;
    }
    
    [self showMap];
    
    [self registerForKeyboardNotifications];
    
    
}

- (void) showMap{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.location.locLatitude
                                                            longitude:self.location.locLongitude
                                                                 zoom:12];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    //[mapView_ addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:NULL];
    
    mapView_.myLocationEnabled = YES;
    mapView_.delegate = self;
    mapView_.mapType = kGMSTypeHybrid;
    [self.mapContainerView addSubview:mapView_];
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(self.location.locLatitude, self.location.locLongitude);
    GMSMarker * marker = [GMSMarker markerWithPosition:coord];
    marker.title = self.location.locName;
    marker.map = mapView_;
    
    mapView_.selectedMarker = marker;
    
}

- (void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    mapView_.frame = self.mapContainerView.bounds;
}

-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)delete:(id)sender{
    
    [loader deleteLocationWithID:self.location.locID];
    if (loader.isCorrectRezult){
        [appDel.listLocations removeObject:self.location];
        if (self.location.typeLocation == typeHunting){
            [appDel.listHuntLocations removeObject:self.location];
        }else if (self.location.typeLocation == typeFishing){
            [appDel.listFishLocations removeObject:self.location];
        }
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

- (IBAction)actShared:(id)sender {
    ShareLocationViewController * slvc = [[ShareLocationViewController alloc]initWithNibName:@"ShareLocationViewController" bundle:nil andLocation:self.location];
    [self.navigationController pushViewController:slvc animated:YES];
}

#pragma mark Keabord methods

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) registerForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void) keyboardWasShown: (NSNotification*) notification{
    NSDictionary * info = [notification userInfo];
    CGSize keyboardSize = [self.view convertRect:[[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue] fromView:self.view.window].size;
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    self.scrollView.contentInset = edgeInsets;
    self.scrollView.scrollIndicatorInsets = edgeInsets;
    
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= keyboardSize.height;
    
    //if (!CGRectContainsPoint(aRect, self.activeTextField.frame.origin)){
    [self.scrollView scrollRectToVisible:self.activeTextField.frame animated:YES];
    //}
}

-(void) keyboardWillBeHidden: (NSNotification*) notification{
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = edgeInsets;
    self.scrollView.scrollIndicatorInsets = edgeInsets;
}

-(void) textFieldDidBeginEditing:(UITextField *)textField{
    self.activeTextField = textField;
}

-(void) textFieldDidEndEditing:(UITextField *)textField{
    self.activeTextField = nil;
}

@end
