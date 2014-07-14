#import <UIKit/UIKit.h>
#import "NewLog1ViewController.h"
#import "CameraViewController.h"
#import "FlyoutMenuViewController.h"
#import "MapViewController.h"
#import "CustomTabBar.h"
#import "CellWithTwoButton.h"


@interface LocationListViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate>
{
    BOOL isPresent;
}
@property (nonatomic) BOOL isTabBar;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *navigationBarHeightConstr;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *navigationBarVerticalConstr;
@property (nonatomic) NSInteger mapType;
@property (strong, nonatomic) IBOutlet CustomTabBar *tabBar;

@property (nonatomic, copy) NSString * screenName;

-(void) setIsPresent:(BOOL)present;

- (IBAction)actGroups:(id)sender;

@end
