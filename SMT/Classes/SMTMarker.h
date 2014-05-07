//
//  SMTMarker.h
//  SMT
//
//  Created by Admin on 5/7/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@class Location;
@interface SMTMarker : GMSMarker

@property (nonatomic, strong) Location* location;

@end
