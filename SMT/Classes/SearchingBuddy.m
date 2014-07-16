#import "SearchingBuddy.h"


#define BUDDY_EMAIL        @"Username"
//#define BUDDY_PROFILE      @"profile"
//#define BUDDY_AVATAR       @"avatar"
//#define BUDDY_STATUS       @"Status"
#define BUDDY_SEX          @"Sex"
#define BUDDY_USER_ID      @"User ID"
#define BUDDY_NAME         @"Name"
#define BUDDY_FIRST_NAME   @"First Name"
#define BUDDY_SECOND_NAME  @"Last Name"
#define BUDDY_BIRTH_YEAR   @"Birth Year"

@implementation SearchingBuddy

- (id)init
{
    self = [super init];
    
    if (self)
    {
        [self setInitialData];
    }
    return self;
}

- (void)setInitialData{
    self.userName = @" ";
    self.userID = @" ";
    self.userEmail = @" ";
    self.userFirstName = @" ";
    self.userSecondName = @" ";
    self.sex = @" ";
    self.birthYear = @" ";
    //self.userAvatar = @" ";
    //self.userProfile = nil;
}

- (void)setData:(NSDictionary*)dic{
    self.userName = [dic objectForKey:BUDDY_NAME];
    self.userID = [dic objectForKey:BUDDY_USER_ID];
    self.userEmail = [dic objectForKey:BUDDY_EMAIL];
    self.userFirstName = [dic objectForKey:BUDDY_FIRST_NAME];
    self.userSecondName = [dic objectForKey:BUDDY_SECOND_NAME];
    self.sex = [dic objectForKey:BUDDY_SEX];
    self.birthYear = [dic objectForKey:BUDDY_BIRTH_YEAR];
    //self.userProfile = [dic objectForKey:BUDDY_PROFILE];
    //self.userAvatar = [dic objectForKey:BUDDY_AVATAR];
}


@end
