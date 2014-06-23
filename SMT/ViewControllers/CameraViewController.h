//
//  CameraViewController.h
//  SMT
//
//  Created by Mac on 6/19/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "NewLog1ViewController.h"
#import "FlyoutMenuViewController.h"
#import "CustomTabBar.h"

@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet CustomTabBar *tabBar;

@end
