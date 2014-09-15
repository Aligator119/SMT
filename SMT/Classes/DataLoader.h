#import <Foundation/Foundation.h>
#import "Species.h"
#import "Buddy.h"
#import "Activity.h"
#import "AFNetworking.h"
#import "Photo.h"
#import "TIPS.h"
#import "Season.h"
#import "Location.h"

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
    ApplicationServiceRequestTips = 31,
    ApplicationServiceRequestComment = 32,
};

@interface DataLoader : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    NSString * strUrl;
    NSMutableData * receivedData;
    
    NSString * keyUsername;
    NSString * keyUserID;
    NSString * keyName;
    
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
- (void)changeUserPassworld:(NSString *)passworld;
- (void)getLocationsAssociatedWithUser;
- (void) createLocationWithName : (NSString*) name Latitude: (double) latitude Longitude: (double) longitude locationType:(NSInteger) _type;
- (void)deleteLocationWithID:(int) _locID;
- (Location *)updateChooseLocation:(int)_locID
                     newName:(NSString*)_newName
                     newLati:(NSString*)_lati
                     newLong:(NSString*)_long;

#pragma mark Users
- (NSArray *)getUsersWithProfiletype:(int)profiletype_id;
- (NSArray *)getUsersWithProfiletype:(int)profiletype_id andName:(NSString *)name;
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
- (NSArray *)getPhotoWithLimit:(NSString *)limit;
- (Photo *)getPhotoWithId:(int)photo_id;
- (NSArray *)getPhotoWithBuddyId:(int)buddy_id;
- (NSString *)uploadPhoto:(UIImage *)photo;
- (void)setDescriptionWithPhotoID:(int)photoID andDescription:(NSString *)des;
- (void)updatePhotoWithId:(int) photo_id andActivity:(int)activity_id andSighting:(int)sighting_id andType:(int)type_id andDescription:(NSString *)description andCaption:(NSString *)caption;
- (void)deletePhotoWithId:(int)photo_id;
- (NSString *)setUserAvatar:(UIImage *)avatar;

//------- Log Detail -----------------------------------------------
- (void) getLogDetail;
- (void) updateLogDetailWithId:(NSString *) logId andSighting:(NSDictionary *)sighting;
- (void) deleteLogDetailWithId:(int)logId;

//------- Shared Location -----------------------------------------------
- (NSArray *) getBuddySharedLocationWithID:(NSString *)loc_id;
- (NSDictionary *) sharedLocation:(int)location_id andWithBuddy:(int)buddy_id;
- (NSDictionary *) unsharedLocation:(int)location_id andWithBuddy:(int)buddy_id;
- (void) getPublicLocationWithID:(NSString *)locID name:(NSString *)name page:(int)page limit:(int)limit state_fips:(int)state county_fips:(int)country;
- (NSArray *) getPublicLocationWithName:(NSString *)name;

//--------TIPS----------------------------------------------------------------------
- (NSArray *)getTips;
- (NSArray *)getTipsWithTipsId:(int)tipsID;
- (TIPS *)createNewTipsWithSpecieID:(int)specieID tip:(NSString *)tipText subSpecieID:(int)subSpecieID andUserID:(int)userID;
- (void)updateTipsWithTipsID:(int)tipID specieID:(int)specieID tip:(NSString *)tipText subSpecieID:(int)subSpecieID andUserID:(int)userID;
- (void)deleteTipsWithID:(int)tipsID;

//------Seasons-------------------------------------------------------------------------------
- (NSArray *) getSeasonWithRegion:(int)region_id;
- (NSArray *) getSpeciesWithSeason:(Season *)season;

//----Comments-------------------------------------------------------------------------
- (NSArray *)getCommentsWithPhotoID:(int)photo_id;
- (void) createComment:(NSString *)text withPhoto:(int)photo_id;
- (void) deleteCommentWithID:(int)comment_id;
@end
