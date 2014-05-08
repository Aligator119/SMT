//
//  HPUpdateLocationViewController.h
//  HunterPredictor
//
//  Created by Admin on 1/27/14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Location;
@interface UpdateLocationViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) Location * location;

@end
