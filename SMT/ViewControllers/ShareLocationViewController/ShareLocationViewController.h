#import <UIKit/UIKit.h>
#import "Location.h"

@interface ShareLocationViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSString * screenName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andLocation:(Location *)location;

@end
