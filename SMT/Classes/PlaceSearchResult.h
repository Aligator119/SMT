//
//  PlaceSearchResult.h
//  HunterPredictor
//
//  Created by Admin on 1/22/14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceSearchResult : NSObject

@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * reference;

-(id) initWithName: (NSString*) name Reference: (NSString*) ref;

@end
