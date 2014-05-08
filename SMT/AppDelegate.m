//
//  AppDelegate.m
//  SMT
//
//  Created by Mac on 4/28/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize session;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    session = [[FBSession alloc] init];
    // Set the active session
    [FBSession setActiveSession:session];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [GMSServices provideAPIKey:kGoogleBrouserAPIkey];
    
    //Test with versionOfBuild
    /*
     NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
     NSString * build = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
     NSLog(@"Version : %@ Build : %@",version,build);
     */
    self.predictionsCalls = 0;
    [self getPredictionsCalls];
    self.user = [[UserInfo alloc] init];
    /*
    BOOL isSignBefore = [self isUserSignBefore];
    if(isSignBefore){
        self.isUserSign = [self isUserSignIn];
        if(self.isUserSign) [self getSignUser];
    }
    */
    self.listUserBuddies = [NSMutableArray new];
    
    //self.userLocation = [UserLocationInThisMoment instance];
//------------------------------------------------------------------------------
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    NSString * nibName = [AppDelegate nibNameForBaseName:@"LoginViewController"];
    self.viewController = [[LoginViewController alloc]initWithNibName:nibName bundle:nil];
    self.navigationController = [[UINavigationController alloc]initWithRootViewController:self.viewController];
    self.window.rootViewController = self.navigationController;
    self.window.backgroundColor = [UIColor whiteColor];
    self.speciesList = [NSMutableArray new];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"default_location"]!= nil) {
        self.defaultLocation = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"default_location"]];
    }
    
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

#pragma mark nibName for xib
//--------------------------------------------------------------------------------------------------------------------
+ (BOOL) isiPhone5 {
    int height = [UIScreen mainScreen].bounds.size.height;
    
    if (height == 568)
        return YES;
    
    return NO;
}

+ (BOOL) isiPhone4 {
    int height = [UIScreen mainScreen].bounds.size.height;
    
    if (height == 480)
        return YES;
    
    return NO;
}

+ (NSString*) nibNameForBaseName:(NSString *)baseName {
    NSString* result = [baseName stringByAppendingString:@"_"];
    
    if ([AppDelegate isiPhone5])
    {
        result = [result stringByAppendingString:@"iPhone5"];
    }
    else if ([AppDelegate isiPhone4])
    {
        result = [result stringByAppendingString:@"iPhone4"];
    }
    else
    {
        return baseName;
    }
    
    return result;
    
}
//--------------------------------------------------------------------------------------------------------------------

+ (void)OpenAlertwithTitle:(NSString *)_title andContent:(NSString *)_content{
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:_title
                                                            message:_content
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)getPredictionsCalls{
    NSDictionary *retrievedDictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"preddictionCalls"];
    if(retrievedDictionary != nil)
        self.predictionsCalls = [[retrievedDictionary objectForKey:@"countCalls"] intValue];
    else self.predictionsCalls = 0;
}

//------------------
+ (BOOL)removeGapsWithString:(NSString*)_str{
    NSString *trimmedString = [_str stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(trimmedString.length != 0) return YES;
    else return NO;
}

- (NSString*)deleteZeroFromTime:(NSString*)_time{
    NSString * strNewTime = [[NSString alloc] initWithString:_time];
    if([[strNewTime substringToIndex:1] isEqualToString:@"0"])
        strNewTime = [strNewTime substringFromIndex:1];
    return strNewTime;
}

//--------------------------------------------------------------------------------------------------------------------
/*
- (void)saveSignUser:(UserInfo*)_userInfo{
    // UserInfo * user =  [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:USER_SIGN_KEY]];
    
    NSData *savedPredictData = [NSKeyedArchiver archivedDataWithRootObject:_userInfo];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:savedPredictData forKey:USER_SIGN_KEY];
    [defaults synchronize];
}

- (void)getSignUser{
    UserInfo * userGet =  [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:USER_SIGN_KEY]];
    if(userGet != nil)
        self.user = userGet;
}

- (BOOL)isUserSignIn{
    BOOL isSign = NO;
    
    NSDictionary *retrievedDictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:IS_USER_SIGN_KEY];
    
    if(retrievedDictionary != nil){
        isSign = [[retrievedDictionary objectForKey:@"isSign"] boolValue];
    }
    
    return isSign;
}

- (BOOL)isUserSignBefore{
    BOOL isSign = NO;
    
    NSDictionary *retrievedDictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:IS_USER_SIGN_KEY];
    
    if(retrievedDictionary != nil) isSign = YES;
    
    return isSign;
}
*/
- (void)saveStateOfUser:(BOOL)_isSign{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:_isSign],@"isSign", nil];
    
    //[[NSUserDefaults standardUserDefaults] setObject:dic forKey:IS_USER_SIGN_KEY];
    //[[NSUserDefaults standardUserDefaults] synchronize];
}
//--------------------------------------------------------------------------------------------------------------------

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
