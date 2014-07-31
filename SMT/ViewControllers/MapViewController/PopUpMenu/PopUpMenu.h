#import <UIKit/UIKit.h>


@protocol SearchInMapDelegate <NSObject>

@required

- (void)searcheLatitude:(float)latitude andLongitude:(float)longitude;

@end



@interface PopUpMenu : UIViewController

@property (weak, nonatomic) id<SearchInMapDelegate> delegate;

@end
