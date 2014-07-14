#import <UIKit/UIKit.h>
#import "Location.h"

@interface WeatherDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *moonrise;
@property (strong, nonatomic) IBOutlet UILabel *sunrise;
@property (strong, nonatomic) IBOutlet UILabel *moonset;
@property (strong, nonatomic) IBOutlet UILabel *sunset;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblMoonPercent;
@property (strong, nonatomic) IBOutlet UIImageView *imgMoonIcon;


//@property (strong, nonatomic) NSString * locationName;
@property (strong, nonatomic) Location * currentLocation;

- (id)initWithIndexPathRow:(NSInteger)row;


//- (IBAction)openTides;

@end
