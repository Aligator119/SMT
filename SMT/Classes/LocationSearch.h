//
//  HPLocationSearch.h
//  HunterPredictor
//
//  Created by Admin on 1/22/14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface LocationSearch : NSObject

+(NSArray*) getSearchResultWithInput: (NSString*) input;
+(CLLocationCoordinate2D) getCoordinateOfLocationWithReference: (NSString*) ref;

@end
