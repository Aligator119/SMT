#import <UIKit/UIKit.h>
#import "Location.h"

@protocol LocationListViewControllerDelegate;

@protocol LocationListViewControllerDelegate <NSObject>

@required

- (void)selectLocation:(Location*)location;

@end

@interface SelectLocationViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id<LocationListViewControllerDelegate> delegate;

- (IBAction)cancelButtonTap:(id)sender;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *navigationBarHeightConstr;

@property (nonatomic, copy) NSString * screenName;


@end
