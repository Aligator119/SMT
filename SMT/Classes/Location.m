//
//  Location.m
//  HunterPredictor
//
//  Created by Vasya on 06.01.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import "Location.h"

#define LOCATION_ID @"id"
#define LOCATION_DELETE @"is_deleted"
#define LOCATION_LATITUDE @"latitude"
#define LOCATION_LONGITUDE @"longitude"
#define LOCATION_NAME @"name"
#define LOCATION_TYPE @"type_id"

@implementation Location
@synthesize locID,locIsDeleted,locLatitude,locLongitude,locName,typeLocation;

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setValuesID:-1 isDeleted:NO lati:0.0f longi:0.0f name:@""];
    }
    return self;
}

- (void)setValuesID:(int)_id isDeleted:(BOOL)_deleted lati:(float)_latitude longi:(float)_long name:(NSString*) _name{
    locID = _id;
    locIsDeleted = _deleted;
    locLongitude = _long;
    locLatitude = _latitude;
    locName = _name;
}

- (void)setValuesFromDict:(NSDictionary*) _info{
    [self setValuesID: [[_info objectForKey:LOCATION_ID] intValue]
            isDeleted: [[_info objectForKey:LOCATION_DELETE] boolValue]
                  lati:[[_info objectForKey:LOCATION_LATITUDE] floatValue]
                 longi:[[_info objectForKey:LOCATION_LONGITUDE] floatValue]
                 name: [_info objectForKey:LOCATION_NAME]];
    typeLocation = [[_info objectForKey:LOCATION_TYPE] intValue];
   // NSLog(@"Location : %@",_info);
}//_info	__NSCFString *	@"updatedtime"	0x0aa5d8b0

- (NSString*)getLocationNames{
    return locName;
}

- (BOOL)isLocationDelete{
    return locIsDeleted;
}


@end
