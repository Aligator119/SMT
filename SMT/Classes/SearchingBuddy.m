#import "SearchingBuddy.h"

/*
 "Email": "venko_29@ukr.net",
 "First Name": "as",
 "Last Name": "as",
 "User ID": "103"
 }
 */

#define BUDDY_EMAIL   @"username"
#define BUDDY_PROFILE @"profile"
#define BUDDY_AVATAR  @"avatar"
#define BUDDY_STATUS  @"Status"
#define BUDDY_USER_ID @"id"

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
    self.userAvatar = @" ";
    self.userProfile = nil;
}

- (void)setData:(NSDictionary*)dic{
    self.userName = [dic objectForKey:BUDDY_EMAIL];
    self.userID = [dic objectForKey:BUDDY_USER_ID];
    self.userProfile = [dic objectForKey:BUDDY_PROFILE];
    self.userAvatar = [dic objectForKey:BUDDY_AVATAR];
}


@end
