//
//  HPSignUpViaEmailViewController.m
//  HunterPredictor
//
//  Created by Admin on 12/25/13.
//  Copyright (c) 2013 mobilesoft365. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"
//#import "HPHomeViewController.h"
#import "DataLoader.h"
#import "UserInfo.h"
#import "AppDelegate.h"

@interface RegisterViewController (){
    AppDelegate * appDel;
}

@property (nonatomic, weak) IBOutlet UITextField * firstNameTextField;
@property (nonatomic, weak) IBOutlet UITextField * lastNameTextField;
@property (nonatomic, weak) IBOutlet UITextField * emailTextField;
@property (nonatomic, weak) IBOutlet UITextField * confirmPasswordTextField;
@property (nonatomic, weak) IBOutlet UITextField * passwordTextField;
@property (nonatomic, weak) IBOutlet UITextField * birthYearTextField;
@property (nonatomic, weak) IBOutlet UISegmentedControl * sexSegment;
@property (nonatomic, weak) IBOutlet UIScrollView * scrollView;

@property (nonatomic, strong) UITextField * activeTextField;

- (UIImage *)createImageWithCollor:(UIColor *)color;
@end

@implementation RegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.scrollView.contentSize = self.view.frame.size;
    [self registerForKeyboardNotifications];
    
    //appDel = [UIApplication sharedApplication].delegate;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    else{
        [self.sexSegment setTintColor:[UIColor grayColor]];
    }
    if(self.isSignWithFacebook) {
        [self userWasSignWithFacebook];
    }
    
    self.logoView.layer.masksToBounds = YES;
    self.logoView.layer.cornerRadius = 5;
    
    UIColor * normal = [UIColor colorWithRed:0.0 green:153/255.0 blue:204/255.0 alpha:1.0];
    UIColor * pressed = [UIColor colorWithRed:51/255.0 green:129/255.0 blue:155/255.0 alpha:1.0];
    [self.btnLogin setBackgroundImage:[self createImageWithCollor:normal] forState:UIControlStateNormal];
    [self.btnLogin setBackgroundImage:[self createImageWithCollor:pressed] forState:UIControlStateHighlighted];
    [self.btnRegister setBackgroundImage:[self createImageWithCollor:normal] forState:UIControlStateNormal];
    [self.btnRegister setBackgroundImage:[self createImageWithCollor:pressed] forState:UIControlStateHighlighted];
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}

/*-(void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.scrollView.contentOffset = CGPointMake(0, 0);
    self.scrollView.contentSize = self.view.frame.size;
}*/


-(IBAction)goToLoginVC:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(BOOL) checkEmail: (NSString*) email{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-+]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z‌​]{2,4})$";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

-(BOOL) checkPasswords: (NSString*) password : (NSString*) confirmedPassword{
    if ([password isEqualToString:confirmedPassword]){
        return YES;
    }
    return NO;
}

-(BOOL) checkBirthYear: (NSString*) year{
    NSNumberFormatter * numFormat = [[NSNumberFormatter alloc] init];
    if (![numFormat numberFromString:year]){
        return NO;
    }
    NSCalendar * gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents * components = [gregorian components:NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger currentYear = [components year];
    NSInteger birthYear = [year integerValue];
    if (birthYear < 0 || birthYear > currentYear - 15){
        return NO;
    }
    if ((currentYear - birthYear)>120){
        return NO;
    }
    return YES;
}

-(void) fillRegistrationInfo:(NSString *)firstName :(NSString *)lastName :(NSString *)email :(int)birthYear :(NSString *)sex andUserFid:(NSString *)userFID{
    userName = email;
    userSex = sex;
    userBirthYear = birthYear;
    userFirstName = firstName;
    userSecondName = lastName;
    userFid = userFID;
    
  /*  self.firstNameTextField.text = userFirstName != nil ? userFirstName : @"";
    self.lastNameTextField.text = userSecondName != nil ? userSecondName : @"";
    self.emailTextField.text = userName != nil ? userName : @"";
    self.birthYearTextField.text =  userBirthYear!= 0 ? [NSString stringWithFormat:@"%i",userBirthYear] : @"";
    if(userSex != nil){
        self.sexSegment.selectedSegmentIndex = [userSex isEqualToString:@"male"] ? 0 : 1;
    }
    userName = nil;
    userSex = nil;
    userBirthYear = 0;
    userFirstName = nil;
    userSecondName = nil;
    userFid = nil;
     */
}

- (void)userWasSignWithFacebook{
    self.firstNameTextField.text = userFirstName != nil ? userFirstName : @"";
    self.lastNameTextField.text = userSecondName != nil ? userSecondName : @"";
    self.emailTextField.text = userName != nil ? userName : @"";
    self.birthYearTextField.text =  userBirthYear!= 0 ? [NSString stringWithFormat:@"%i",userBirthYear] : @"";
    if(userSex != nil){
        self.sexSegment.selectedSegmentIndex = [userSex isEqualToString:@"male"] ? 0 : 1;
    }
    
    self.isSignWithFacebook = YES;
    //* * * * * *
    userName = nil;
    userSex = nil;
    userBirthYear = 0;
    userFirstName = nil;
    userSecondName = nil;
    //userFid = nil;
}

-(IBAction)SignUp:(id)sender{
    
    NSString * firstName = self.firstNameTextField.text;
    NSString * lastName = self.lastNameTextField.text;
    NSString * email = self.emailTextField.text;
    NSString * password = self.passwordTextField.text;
    NSString * confirmedPassword = self.confirmPasswordTextField.text;
    NSString * birthYear = self.birthYearTextField.text;
    
    NSString * sex =  (self.sexSegment.selectedSegmentIndex == 0) ? @"male" : @"female";
    
    //NSString * strFirstName = self.firstNameTextField.text;
    //NSString * strLastName = self.lastNameTextField.text;
     
    /*
    if(![self removeGaps:strFirstName] || ![self removeGaps:strLastName]){
        [AppDelegate OpenAlertwithTitle:@"Error" andContent:@"Enter correctly \nFirst name and Last name"];
        return;
    }
    */
    if (![self checkEmail:email]){
        [AppDelegate OpenAlertwithTitle:@"Error" andContent:@"Please enter correct email"];
        return;
    }
    if (![self checkPasswords:password :confirmedPassword]){
        [AppDelegate OpenAlertwithTitle:@"Error" andContent:@"Please enter same password\nand confirm passwords"];
        return;
    }
    if (password.length < 6){
        [AppDelegate OpenAlertwithTitle:@"Error" andContent:@"Password length must be bigger\n than 5 symbols"];
        return;
    }
    if (![self checkBirthYear:birthYear]){
        [AppDelegate OpenAlertwithTitle:@"Error" andContent:@"Please enter correct year of birth"];
        return;
    }
    
    //[self startInternatIndicator];
    
        dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(newQueue, ^(){
            
        DataLoader * dataLoader = [DataLoader instance];
        [dataLoader createUserWithFirstName:firstName secondName:lastName userName:email password:password birthYear:[birthYear intValue] sex:sex];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            //[self stopInternatIndicator];
            if (dataLoader.isCorrectRezult){
            
                AppDelegate * appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
                NSLog(@"userFid : %@",userFid);
                [appDelegate.user redwriteUserFbID:appDelegate.user.userName andFID:userFid];
                 
            //*****
                //HomeViewController * homeVC = [[HPHomeViewController alloc] initWithNibName:@"HPHomeViewController" bundle:nil];
               // [self.navigationController pushViewController:homeVC animated:YES];
            
            }
        });
    });

   
}

#pragma mark keyboard methods

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

-(void) registerForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void) keyboardWasShown: (NSNotification*) notification{
    self.scrollView.contentSize = self.view.frame.size;
    NSDictionary * info = [notification userInfo];
    CGSize keyboardSize = [self.view convertRect:[[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue] fromView:self.view.window].size;
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    self.scrollView.contentInset = edgeInsets;
    self.scrollView.scrollIndicatorInsets = edgeInsets;
    //[self.scrollView setContentOffset:CGPointMake(0.0, keyboardSize.height)];
    
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= keyboardSize.height;
    
    //if (!CGRectContainsPoint(aRect, self.activeTextField.frame.origin)){
        [self.scrollView scrollRectToVisible:self.activeTextField.frame animated:YES];
   // }
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

- (BOOL)removeGaps:(NSString*)_str{
    NSString *trimmedString = [_str stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(trimmedString.length != 0) return YES;
        else return NO;
    
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 1 && textField.text.length >= 4 && range.length == 0){
        return NO;
    }
    if (textField.text.length > MAX_STRING_LENGTH && range.length == 0){
        return NO;
    }
    return YES;
}

- (UIImage *)createImageWithCollor:(UIColor *)color
{
    CGSize imageSize = CGSizeMake(64, 64);
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextFillRect(context, CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
