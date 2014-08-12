#import "BaseLocationViewController.h"
#import "AppDelegate.h"
#import "DataLoader.h"
#import "Location.h"
#import "MapViewController.h"
#import "ShareLocationViewController.h"
#import <CoreLocation/CoreLocation.h>


#define EDIT_VIEW_HEIGTH 120


@interface BaseLocationViewController (){
    AppDelegate * appDel;
    DataLoader * loader;
    GMSMapView *mapView_;
    BOOL isFullMap;
    CGRect bounds;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapHeigth;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint * heightConstr;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * verticalConstr;
@property (nonatomic, weak) IBOutlet UITextField * locNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *locLatitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *locLongitudeTextField;

@property (nonatomic, weak) IBOutlet UIView * updateNameView;
@property (nonatomic, weak) IBOutlet UIView * coordinatesView;
@property (nonatomic, weak) IBOutlet UIButton * deleteButton;
@property (nonatomic, weak) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (weak, nonatomic) IBOutlet UILabel *lbLocation;
@property (weak, nonatomic) IBOutlet UILabel *lbLatitude;
@property (weak, nonatomic) IBOutlet UILabel *lbLongitude;
@property (weak, nonatomic) IBOutlet UIImageView *imgTypeLocation;

@property (weak, nonatomic) IBOutlet UIButton *btnDone;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (nonatomic, weak) IBOutlet UIView *mapContainerView;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *activeTextField;
- (IBAction)actShared:(id)sender;
- (IBAction)actCloseFullMap:(id)sender;
- (IBAction)actEdit:(id)sender;

- (void) actChangeSizeMap:(UITapGestureRecognizer *)recognizer;
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
    self.locLatitudeTextField.text = [NSString stringWithFormat:@"%f",self.location.locLatitude];
    self.locLongitudeTextField.text = [NSString stringWithFormat:@"%f",self.location.locLongitude];
    
    self.updateNameView.layer.cornerRadius = 6;
    self.coordinatesView.layer.cornerRadius = 6;
    self.deleteButton.layer.cornerRadius = 6;
    
//    NSString * title = [NSString stringWithFormat:@"Lat/Lng "];
//    
//    NSString * data = [[[NSString stringWithFormat:@"%f",self.location.locLatitude] stringByAppendingString:@", "] stringByAppendingString:[NSString stringWithFormat:@"%f", self.location.locLongitude]];
//    NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@", title, data]];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,title.length)];
//    [self.lbCoordinate setAttributedText:str];
    
    
    if (self.location.typeLocation == 1) {
        self.imgTypeLocation.image = [UIImage imageNamed:@"hunt_mode_icon_selected.png"];
    } else {
        self.imgTypeLocation.image = [UIImage imageNamed:@"fish_mode_icon_selected.png"];
    }
    self.lbLocation.text = self.location.locName;
    self.lbLatitude.text = [NSString stringWithFormat:@"Latitude: %f",self.location.locLatitude];
    self.lbLongitude.text = [NSString stringWithFormat:@"Longitude: %f",self.location.locLongitude];;
    
    if (self.location.locUserId != appDel.user.userID){
        self.saveButton.hidden = YES;
        self.deleteButton.hidden = YES;
        self.shareButton.hidden = YES;
    }
    
    [self showMap];
    
    [self registerForKeyboardNotifications];
    
    
    
}

- (void) viewWillAppear:(BOOL)animated
{
    bounds = self.mapContainerView.frame;
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
//---------- add action to  gesture recognizer in google map ------------------------------------------------------
    UIGestureRecognizer * recognizer = [mapView_.gestureRecognizers firstObject];
    [recognizer addTarget:self action:@selector(actChangeSizeMap:)];
    recognizer.delegate = self;
    [self.mapContainerView addGestureRecognizer:recognizer];
    isFullMap = NO;
//----------------------------------------------------------------------------------------------------------------
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
    NSString * lat = self.locLatitudeTextField.text;//[NSString stringWithFormat:@"%f", self.location.locLatitude];
    NSString * lng = self.locLongitudeTextField.text;//[NSString stringWithFormat:@"%f", self.location.locLongitude];
    self.location = [loader updateChooseLocation:self.location.locID newName:trimmedNewName newLati:lat newLong:lng];
    if (loader.isCorrectRezult){
        for(int i = self.navigationController.viewControllers.count-1; i > 0; i--){
            UIViewController * vc = [self.navigationController.viewControllers objectAtIndex:i];
            if ([vc isKindOfClass:[MapViewController class]]){
                [self.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
    }
    self.saveButton.hidden = YES;
    self.editButton.hidden = NO;
    self.updateNameView.hidden = YES;
    [self showMap];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

- (IBAction)actShared:(id)sender {
    ShareLocationViewController * slvc = [[ShareLocationViewController alloc]initWithNibName:@"ShareLocationViewController" bundle:nil andLocation:self.location];
    [self.navigationController pushViewController:slvc animated:YES];
}

- (IBAction)actCloseFullMap:(id)sender {
    if (isFullMap) {
        self.mapHeigth.constant = 160;
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        }];
        self.saveButton.hidden = YES;
        self.backButton.hidden = NO;
        self.editButton.hidden = NO;
        self.btnDone.hidden = YES;
        isFullMap = !isFullMap;
    }
}

- (IBAction)actEdit:(id)sender {
    
    self.editButton.hidden = YES;
    self.saveButton.hidden = NO;
    self.updateNameView.hidden = NO;
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

- (void) actChangeSizeMap:(UITapGestureRecognizer *)recognizer
{
    if (!isFullMap) {
        if (recognizer.numberOfTouches == 1 && recognizer.state == UIGestureRecognizerStateBegan) {
            self.mapHeigth.constant = self.view.frame.size.height - 64.0;
            [UIView animateWithDuration:0.5 animations:^{
                [self.view layoutIfNeeded];
            }];
            self.saveButton.hidden = YES;
            self.backButton.hidden = YES;
            self.editButton.hidden = YES;
            self.updateNameView.hidden = YES;
            self.btnDone.hidden = NO;
            isFullMap = !isFullMap;
        }
    }
}

@end
