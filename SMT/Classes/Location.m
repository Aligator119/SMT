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
#define LOCATION_GROUP @"group"
#define LOCATION_ADRESS @"adress"
#define LOCATION_USER_ID @"user_id"

@implementation Location
@synthesize locID,locIsDeleted,locLatitude,locLongitude,locName,typeLocation, locationGroup, addres, locUserId;

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setValuesID:-1 isDeleted:NO lati:0.0f longi:0.0f name:@"" group:@"" adress:@"" userId:-1];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInteger:locID forKey:LOCATION_ID];
    [encoder encodeBool:locIsDeleted forKey:LOCATION_DELETE];
    [encoder encodeFloat:locLatitude forKey:LOCATION_LATITUDE];
    [encoder encodeFloat:locLongitude forKey:LOCATION_LONGITUDE];
    [encoder encodeObject:locName forKey:LOCATION_NAME];
    [encoder encodeInteger:typeLocation forKey:LOCATION_TYPE];
    [encoder encodeObject:locationGroup forKey:LOCATION_GROUP];
    [encoder encodeObject:addres forKey:LOCATION_ADRESS];
    [encoder encodeInteger:locUserId forKey:LOCATION_USER_ID];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init])) {
        locID = [decoder decodeIntForKey:LOCATION_ID];
        locIsDeleted = [decoder decodeBoolForKey:LOCATION_DELETE];
        locLatitude = [decoder decodeFloatForKey:LOCATION_LATITUDE];
        locLongitude = [decoder decodeFloatForKey:LOCATION_LONGITUDE];
        locName = [decoder decodeObjectForKey:LOCATION_NAME];
        typeLocation = [decoder decodeIntForKey:LOCATION_TYPE];
        locationGroup = [decoder decodeObjectForKey:LOCATION_GROUP];
        addres = [decoder decodeObjectForKey:LOCATION_ADRESS];
        locUserId = [decoder decodeIntForKey:LOCATION_USER_ID];
    }
    return self;
}



- (void)setValuesID:(int)_id isDeleted:(BOOL)_deleted lati:(float)_latitude longi:(float)_long name:(NSString*) _name group:(NSString *)_group adress:(NSString *)_adress userId: (int) _userId{
    locID = _id;
    locIsDeleted = _deleted;
    locLongitude = _long;
    locLatitude = _latitude;
    locName = _name;
    locationGroup = _group;
    addres = _adress;
    locUserId = _userId;
}

- (void)setValuesFromDict:(NSDictionary*) _info{
    [self setValuesID: [[_info objectForKey:LOCATION_ID] intValue]
            isDeleted: [[_info objectForKey:LOCATION_DELETE] boolValue]
                  lati:[[_info objectForKey:LOCATION_LATITUDE] floatValue]
                 longi:[[_info objectForKey:LOCATION_LONGITUDE] floatValue]
                 name: [_info objectForKey:LOCATION_NAME]
                group: [_info objectForKey:LOCATION_GROUP]
               adress: [_info objectForKey:LOCATION_ADRESS]
                userId:[[_info objectForKey:LOCATION_USER_ID] intValue]];
    typeLocation = [[_info objectForKey:LOCATION_TYPE] intValue];
}

- (NSString*)getLocationNames{
    return locName;
}

- (BOOL)isLocationDelete{
    return locIsDeleted;
}


@end
