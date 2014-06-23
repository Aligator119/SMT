#import <UIKit/UIKit.h>

@protocol MyNewCustomTabBarDelegate <NSObject>

@required
- (void)selectController:(int)tag;
@end


@interface CustomTabBar : UIView

@property (weak, nonatomic) id<MyNewCustomTabBarDelegate> delegate;



@end
