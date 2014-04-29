//
//  AppDelegate.m
//  SMT
//
//  Created by Mac on 4/28/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    NSString * nibName = [AppDelegate nibNameForBaseName:@"LoginViewController"];
    self.viewController = [[LoginViewController alloc]initWithNibName:nibName bundle:nil];
    self.navigationController = [[UINavigationController alloc]initWithRootViewController:self.viewController];
    self.window.rootViewController = self.navigationController;
    self.window.backgroundColor = [UIColor whiteColor];
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
