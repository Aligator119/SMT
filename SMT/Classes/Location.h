//
//  Location.h
//  HunterPredictor
//
//  Created by Vasya on 06.01.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import <Foundation/Foundation.h>

enum TypeOfLocation{
    typeHunting = 1,
    typeFishing = 2
};

@interface Location : NSObject

@property (nonatomic, readonly) int locID;
@property (nonatomic, readonly) BOOL locIsDeleted;
@property (assign, nonatomic, readonly) float locLatitude;
@property (assign, nonatomic, readonly) float locLongitude;
@property (strong, nonatomic, readonly) NSString * locName;
@property (assign, nonatomic, readonly) int typeLocation;
@property (assign, nonatomic, readonly) NSString * locationGroup;
@property (assign, nonatomic, readonly) NSString * addres;

- (id)init;
- (void)setValuesID:(int)_id
          isDeleted:(BOOL)_deleted
                lati:(float)_latitude
               longi:(float)_long
               name:(NSString*) _name
              group:(NSString *) _group
             adress:(NSString *) _adress;

- (void)setValuesFromDict:(NSDictionary*) _info;
- (NSString*) getLocationNames;
- (BOOL)isLocationDelete;


@end
