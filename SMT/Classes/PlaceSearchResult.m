//
//  PlaceSearchResult.m
//  HunterPredictor
//
//  Created by Admin on 1/22/14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import "PlaceSearchResult.h"

@implementation PlaceSearchResult

-(id) initWithName: (NSString*) name Reference: (NSString*) ref{
    if (self = [super init]){
        self.name = name;
        self.reference = ref;
    }
    return self;
}

@end
