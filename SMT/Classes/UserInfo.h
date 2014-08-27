#import <Foundation/Foundation.h>

enum fbAttribute{
    fbUserMissing = 0,
    fbUserCreate = 1,
    fbUserCreateFB = 2
};

//com.mobilesoft365.HunterPredictor
//${PRODUCT_NAME}

@interface UserInfo : NSObject

@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * userPassword;
@property (nonatomic, readonly) int userID;
@property (strong, nonatomic) NSString * userFID;
@property (strong, nonatomic) NSString * userEmail;
@property (strong, nonatomic) NSString * avatarAdress;
@property (strong, nonatomic) NSData * imgData;
@property (nonatomic) int region_id;

- (id) init;
- (void)setUserInfoName:(NSString*) _name password:(NSString*)_pass appID:(int) _appID;
- (void)setUserInfoName:(NSString*) _name appID:(int) _appID;
- (void)setUserInfoPassword:(NSString*) _pass;
- (void)setInfoFID:(NSString*)_fid;
- (void)setUserName:(NSString*)_userName;

+ (int)itsFirstMomentWhenUserLoginAndIsWithFacebook:(NSString*)usName;
+ (BOOL)itsFirstMomentWhenUserLogin:(NSString*)usName;
- (void)saveUser;
- (void)redwriteUserFbID:(NSString*) usName andFID:(NSString*)_FbID;
- (void)loadImg;

@end
