//
//  HPLoginViewController.m
//  HunterPredictor
//
//  Created by Admin on 12/24/13.
//  Copyright (c) 2013 mobilesoft365. All rights reserved.
//

#import "LoginViewController.h"
#import "FlyoutMenuViewController.h"
#import "RegisterViewController.h"
#import "DataLoader.h"
#import "FBConnectClass.h"
#import "ConstantsClass.h"
#import "ForgotPasswordViewController.h"
#import "AppDelegate.h"
#import "UserInfo.h"






@interface LoginViewController (){
    DataLoader * dataLoader;
    BOOL wasFacebookClick;
    BOOL isFirstMoment; // for save user - automaticaly login
}

@property (nonatomic, weak) IBOutlet UIScrollView * scrollView;
@property (nonatomic, weak) IBOutlet UITextField * userNameTextField;
@property (nonatomic, weak) IBOutlet UITextField * passwordTextField;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView * activityIndicator;

@property (nonatomic, strong) UITextField * activeTextField;
@property (strong, nonatomic) UIActivityIndicatorView  * activityIndicat;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 20);
    dataLoader = [DataLoader instance];
    self.scrollView.contentSize = self.view.frame.size;
    [self registerForKeyboardNotifications];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    isFirstMoment = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    [self addActivity];
    self.userNameTextField.text = @"";
    self.passwordTextField.text = @"";
    wasFacebookClick = NO;
    [self.view endEditing:YES];
    
    if([[UIApplication sharedApplication] isIgnoringInteractionEvents])
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    [self.activityIndicat stopAnimating];
}

- (void)viewDidAppear:(BOOL)animated{
    
    AppDelegate * appDel = (AppDelegate*) [UIApplication sharedApplication].delegate;
    if(appDel.isUserSign && isFirstMoment) {
        [self.activityIndicat startAnimating];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [self fbUserLogin:appDel.user.userName password:appDel.user.userPassword];
    }
     
}

-(BOOL) checkEmail: (NSString*) email{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-+]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z‌​]{2,4})$";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

-(IBAction)goToHomeScreen:(id)sender{
    self.userNameTextField.text = @"boloonka1@bigmir.net";
    self.passwordTextField.text = @"19921992q";
    
    if(self.userNameTextField.text.length == 0) {
        [AppDelegate OpenAlertwithTitle:@"Error" andContent:@"Email field is empty"];
        return;
     
    }
    
    if(![self checkEmail:self.userNameTextField.text])
    {
        [AppDelegate OpenAlertwithTitle:@"Error" andContent:@"Enter correct form of email"];
        return;
    }
    
    if(self.passwordTextField.text.length < 6) {
       [AppDelegate OpenAlertwithTitle:@"Error" andContent:@"Length of password must be\nhigher than 5 symbols"];
        return;
    }
    
    // * * * * * *
    [self.activityIndicat startAnimating];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    AppDelegate * appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    
    appDelegate.user.userName = self.userNameTextField.text;
    appDelegate.user.userPassword = self.passwordTextField.text;
    // * * Avtorize * *
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        
    [dataLoader avtorizeUser:appDelegate.user.userName password:appDelegate.user.userPassword];
    // * * * *
        
    dispatch_async(dispatch_get_main_queue(), ^(){
        
        if(dataLoader.isCorrectRezult){
            dataLoader.isCorrectRezult = NO;
        
            if(!wasFacebookClick){
                if([UserInfo itsFirstMomentWhenUserLogin:appDelegate.user.userName]){
                    [appDelegate.user saveUser];
                }
            } else {
                switch ([UserInfo itsFirstMomentWhenUserLoginAndIsWithFacebook:appDelegate.user.userName]) {
                    case fbUserMissing:
                        [appDelegate.user saveUser];
                        break;
                    case fbUserCreate:
                        [appDelegate.user redwriteUserFbID:appDelegate.user.userName andFID:appDelegate.user.userFID];
                        break;
                    default:
                        break;
                }
            }
            [self.activityIndicat stopAnimating];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
            FlyoutMenuViewController * fmVC = [[FlyoutMenuViewController alloc] initWithNibName:@"FlyoutMenuViewController" bundle:nil];
            [self.navigationController pushViewController:fmVC animated:YES];
        } else {
            [self.activityIndicat stopAnimating];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
    });
                        
    });
}

-(IBAction)signUpAct:(id)sender{
    
    NSString * nibName = [AppDelegate nibNameForBaseName:@"RegisterViewController"];
    RegisterViewController * flyoutMenu = [[RegisterViewController alloc] initWithNibName:nibName bundle:nil];
    [self.navigationController pushViewController:flyoutMenu animated:YES];
}

#pragma mark - Work with FACEBOOK

- (IBAction)openDashBoard:(id)sender {
   
    FBConnectClass * connect = [FBConnectClass instance];
    connect.delegate = self;
    [self.activityIndicat startAnimating];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    [connect sentRequest:requestLogin];
    
}

- (void)fbUserLogin:(NSString *)uName password:(NSString *)uPassword{
    
    FBConnectClass * connect = [FBConnectClass instance];
    
    if(connect.haveError){
        [AppDelegate OpenAlertwithTitle:@"Error" andContent:@"Problem in connection.\nPlease, try again"];
        [self.activityIndicat stopAnimating];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
    } else {
        dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
        dispatch_async(newQueue, ^(){
            
        [dataLoader avtorizeUser:uName password:uPassword];
            
        if(dataLoader.isCorrectRezult) {
            dataLoader.isCorrectRezult = NO;
            
            dispatch_async(dispatch_get_main_queue(), ^(){
                [self.activityIndicat stopAnimating];
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                
            FlyoutMenuViewController * fmView = [[FlyoutMenuViewController alloc] initWithNibName:@"FlyoutMenuViewController" bundle:nil];
        
            AppDelegate * appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
            [appDelegate getPredictionsCalls];
        
            [self.navigationController pushViewController:fmView animated:YES];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^(){
                [AppDelegate OpenAlertwithTitle:@"Error" andContent:@"Problem in connection.\nPlease, try again"];
                [self.activityIndicat stopAnimating];
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            });
        }
        });
    }
    
}

- (void)fbUserFirstLogin:(NSString *)_name fbID:(NSString *)_fbID{
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        
    [self.activityIndicat stopAnimating];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    AppDelegate * appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    [appDelegate.user setInfoFID:_fbID];
    self.userNameTextField.text = _name != nil ? _name : @"";
        
    wasFacebookClick = YES;
    
    [AppDelegate OpenAlertwithTitle:@"" andContent:@"Please, enter correct username\n and password"];
        
    });
     
}

- (IBAction)forgotPassword:(id)sender{
    
    ForgotPasswordViewController * forgotPasswordVC = [[ForgotPasswordViewController alloc] initWithNibName:@"ForgotPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:forgotPasswordVC animated:YES];
     
}

#pragma mark Keabord methods

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

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - Other methods

- (void)addActivity{
    self.activityIndicat = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:self.activityIndicat];
    
    self.activityIndicat.center = self.view.center;
    
    self.activityIndicat.color = [UIColor grayColor];
    self.activityIndicat.hidesWhenStopped = YES;
}

- (void)sessionIsActive{
    dispatch_async(dispatch_get_main_queue(), ^(){
        [self.activityIndicat stopAnimating];
        if([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    });
}

- (void) displayBuddies{
    
}


@end
