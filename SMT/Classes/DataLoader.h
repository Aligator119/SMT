//
//  DataLoader.h
//  testCaAnimation
//
//  Created by Vasya on 01.01.14.
//  Copyright (c) 2014 Vasya. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AppDelegate;

enum ApplicationServiceRequest
{
    ApplicationServiceRequestCreateUser = 0,
    ApplicationServiceRequestAvtorizeUser = 1,
    ApplicationServiceRequestCreateLocation = 2,
    ApplicationServiceRequestTest2 = 3,
    ApplicationServiceRequestLocationsAssociatedWithUser = 4,
    ApplicationServiceRequestPredictionInfo = 5,
    ApplicationServiceRequestDeleteLocation = 6,
    ApplicationServiceRequestUpdateLocation = 7,
    ApplicationServiceRequestAddBuddy = 8,
    ApplicationServiceRequestGetListOfBuddies = 9,
    ApplicationServiceRequestGetInfoAboutBuddy = 10,
    ApplicationServiceRequestDeleteFromBuddies = 11,
    ApplicationServiceRequestChangeTypeOfBuddyRequest = 12,
    ApplicationServiceRequestUpdateUserCurrentLocation = 13,
    ApplicationServiceRequestSearchBuddy = 14
};

@interface DataLoader : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    NSString * strUrl;
    NSMutableData * receivedData;
    
    NSString * keyUsername;
    NSString * keyUserID;
    
    NSDictionary * info;
    
    NSString * enterPassword;
    AppDelegate * appDel;
    
    //**
    NSString * typeRequest;
}

@property (nonatomic, readonly) enum ApplicationServiceRequest typeOfServiceRequest;
@property (assign, nonatomic) BOOL isCorrectRezult;

- (id)init;
+ (DataLoader *)instance;
- (void)avtorizeUser:(NSString*) userName password:(NSString*) userPassword;
- (void)createUserWithFirstName:(NSString*) firstName
                     secondName:(NSString*) secondName
                       userName:(NSString*) userName
                       password:(NSString*) userPassword
                      birthYear:(int) birthYear
                            sex:(NSString*) userMale;
- (void)getLocationsAssociatedWithUser;
- (void) getPredictionWithLocationID: (int) lid andSpecieID: (int)sid;
- (void) createLocationWithName : (NSString*) name Latitude: (double) latitude Longitude: (double) longitude;
- (void)deleteLocationWithID:(int) _locID;
- (void)updateChooseLocation:(int)_locID
                     newName:(NSString*)_newName
                     newLati:(NSString*)_lati
                     newLong:(NSString*)_long;

- (void)buddyAddWithName:(NSString*)buddyName;
- (void)buddyGetListUsersBuddies;
- (void)buddyGetUserBuddyWithId:(int)_idBuddy;
- (void)buddyChangeUserBuddy:(int)_idBuddy status:(int)_statusBuddy andVisible:(int)_visible;
- (void)buddyDeleteUserFromBuddies:(int)_idBuddy;
- (void)updateUserLocationLat:(NSString*)_latitude andLong:(NSString*)_longitude;

- (void)buddySearchByLastName:(NSString*)_name;

@end