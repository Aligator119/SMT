//
//  DataLoader.h
//  testCaAnimation
//
//  Created by Vasya on 01.01.14.
//  Copyright (c) 2014 Vasya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Species.h"
#import "Buddy.h"
#import "Activity.h"
#import "AFNetworking.h"
#import "Photo.h"

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
    ApplicationServiceRequestSearchBuddy = 14,
    ApplicationServiceRequestSendInvitation = 15,
    ApplicationServiceRequestChangeTrackingVisibility = 16,
    ApplicationServiceRequestGetUserTrackingVisibility = 17,
    ApplicationServiceRequestGetWeatherForecast = 18,
    ApplicationServiceRequestGetListActivities = 19,
    ApplicationServiceRequestGetActivityWithId = 20,
    ApplicationServiceRequestCreateActivity = 21,
    ApplicationServiceRequestUpdateActivity = 22,
    ApplicationServiceRequestDeleteActivity = 23,
    ApplicationServiceRequestPhoto = 24,
    ApplicationServiceRequestLogDetail = 25,
    ApplicationServiceRequestSpecies = 26,
    ApplicationServiceRequestGetAllSharedLocations = 27,
    ApplicationServiceRequestGetSharedLocationsFromBuddy = 28,
    ApplicationServiceRequestShareLocationWithBuddy = 29,
    ApplicationServiceRequestUnshareLocation = 30,
};

@interface DataLoader : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    NSString * strUrl;
    NSMutableData * receivedData;
    
    NSString * keyUsername;
    NSString * keyUserID;
    NSString * keyUserFirstName;
    NSString * keyUserSecondName;
    
    //NSDictionary * info;
    
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
- (void) createLocationWithName : (NSString*) name Latitude: (double) latitude Longitude: (double) longitude locationType:(NSInteger) _type;
- (void)deleteLocationWithID:(int) _locID;
- (void)updateChooseLocation:(int)_locID
                     newName:(NSString*)_newName
                     newLati:(NSString*)_lati
                     newLong:(NSString*)_long;

- (void)buddyAddWithName:(NSString*)buddyName;
- (void)buddyGetListUsersBuddies;
- (Buddy *)buddyGetUserBuddyWithId:(int)_idBuddy;
- (void)buddyChangeUserBuddy:(int)_idBuddy status:(int)_statusBuddy andVisible:(int)_visible;
- (void)buddyDeleteUserFromBuddies:(int)_idBuddy;
- (void)updateUserLocationLat:(NSString*)_latitude andLong:(NSString*)_longitude;

- (NSArray *)buddySearchByLastName:(NSString*)_name;
- (void) sendInvitationEmailWithEmail: (NSString*) _email andName: (NSString*) _name;
//- (void) updateUserTrackingVisibility: (BOOL) _tracking_visibility;
//- (void) getUserTrackingVisibility;
- (void)getWeatherPredictionForCurrentLocation:(int)_idLocation;
//----------- Species ---------------------------------------------
- (NSArray *)getAllSpecies;
- (Species *)getSpecieWithId:(int) specieID;
- (NSArray *)getSubSpecies:(int) subSpeciesID;
- (Species *)getSubSpecieWithId:(int) subSpecieID;
- (NSArray *)getSubSpecieKillingQuestionsWithId:(int) subSpecieID;
- (NSArray *)getQuestionsWithSubSpecieId:(int) subSpecieId;

//------------- Activity ---------------------------------------------
- (NSString *) createActivityWithActivityObject: (Activity*) _activity andActivityDetails: (NSArray*) _activityDetails andSpeciesId: (NSInteger) _speciesId;
- (NSMutableArray*) getAllActivities;
- (NSMutableArray*) getActivitiesWithBuddyID:(int)buddy_id;
- (NSMutableArray*) getActivityListFrom: (NSInteger) first to: (NSInteger) last;
- (NSDictionary *) getActivityWithId: (NSInteger) _id;
- (void) upadateActivityWithId: (NSString*) _activityId speciesId: (NSString*) _speciesId startTime: (NSString*) _startTime endTime: (NSString*) _endTime locationId: (NSString*) _locationId date: (NSString*) _date;
- (void) deleteActivityWithId: (NSInteger) _activityId;

//------- Photo metods -----------------------------------------
- (NSArray *)getPhoto;
- (Photo *)getPhotoWithId:(int)photo_id;
- (NSArray *)getPhotoWithBuddyId:(int)buddy_id;
- (NSString *)uploadPhoto:(UIImage *)photo;
- (void)updatePhotoWithId:(int) photo_id andActivity:(int)activity_id andSighting:(int)sighting_id andType:(int)type_id andDescription:(NSString *)description andCaption:(NSString *)caption;
- (void)deletePhotoWithId:(int)photo_id;
- (NSString *)setUserAvatar:(UIImage *)avatar;
//------- Log Detail -----------------------------------------------
- (void) getLogDetail;
- (void) updateLogDetailWithId:(NSString *) logId andSighting:(NSDictionary *)sighting;
- (void) deleteLogDetailWithId:(int)logId;
//------- Shared Location -----------------------------------------------
- (NSArray *) getBuddySharedLocation;
- (void) sharedLocation:(int)location_id andWithBuddy:(int)buddy_id;
- (void) unsharedLocation:(int)location_id andWithBuddy:(int)buddy_id;

@end
