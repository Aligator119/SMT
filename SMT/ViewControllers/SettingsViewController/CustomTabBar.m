#import "CustomTabBar.h"

@interface CustomTabBar ()

@property (strong, nonatomic) IBOutlet UIButton *btnFlyoutMenu;
@property (strong, nonatomic) IBOutlet UIButton *btnMap;
@property (strong, nonatomic) IBOutlet UIButton *btnCamera;
@property (strong, nonatomic) IBOutlet UIButton *btnActivity;
@property (strong, nonatomic) IBOutlet UIButton *btnSetting;
- (void)actFlyputMenu:(id)sender;
- (void)actMap:(id)sender;
- (void)actCamera:(id)sender;
- (void)actActivity:(id)sender;
- (void)actSetting:(id)sender;

@end


@implementation CustomTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.btnFlyoutMenu = (UIButton *)[self viewWithTag:1];
        [self.btnFlyoutMenu addTarget:self action:@selector(actFlyputMenu:) forControlEvents:UIControlEventTouchUpInside];
        self.btnMap = (UIButton *)[self viewWithTag:2];
        [self.btnMap addTarget:self action:@selector(actMap:) forControlEvents:UIControlEventTouchUpInside];
        self.btnCamera = (UIButton *)[self viewWithTag:3];
        [self.btnCamera addTarget:self action:@selector(actCamera:) forControlEvents:UIControlEventTouchUpInside];
        self.btnActivity = (UIButton *)[self viewWithTag:4];
        [self.btnActivity addTarget:self action:@selector(actActivity:) forControlEvents:UIControlEventTouchUpInside];
        self.btnSetting = (UIButton *)[self viewWithTag:5];
        [self.btnSetting addTarget:self action:@selector(actSetting:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.btnFlyoutMenu = (UIButton *)[self viewWithTag:1];
        [self.btnFlyoutMenu addTarget:self action:@selector(actFlyputMenu:) forControlEvents:UIControlEventTouchUpInside];
        self.btnMap = (UIButton *)[self viewWithTag:2];
        [self.btnMap addTarget:self action:@selector(actMap:) forControlEvents:UIControlEventTouchUpInside];
        self.btnCamera = (UIButton *)[self viewWithTag:3];
        [self.btnCamera addTarget:self action:@selector(actCamera:) forControlEvents:UIControlEventTouchUpInside];
        self.btnActivity = (UIButton *)[self viewWithTag:4];
        [self.btnActivity addTarget:self action:@selector(actActivity:) forControlEvents:UIControlEventTouchUpInside];
        self.btnSetting = (UIButton *)[self viewWithTag:5];
        [self.btnSetting addTarget:self action:@selector(actSetting:) forControlEvents:UIControlEventTouchUpInside];
       
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)actFlyputMenu:(id)sender {
    id<MyNewCustomTabBarDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(selectController:)]) {
        [delegate selectController:1];
    }
}

- (void)actMap:(id)sender {
    id<MyNewCustomTabBarDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(selectController:)]) {
        [delegate selectController:2];
    }
}

- (void)actCamera:(id)sender {
    id<MyNewCustomTabBarDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(selectController:)]) {
        [delegate selectController:3];
    }
}

- (void)actActivity:(id)sender {
    id<MyNewCustomTabBarDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(selectController:)]) {
        [delegate selectController:4];
    }
}

- (void)actSetting:(id)sender {
    id<MyNewCustomTabBarDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(selectController:)]) {
        [delegate selectController:5];
    }
}

@end
