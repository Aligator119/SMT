#import "CommentHeaderView.h"

@implementation CommentHeaderView

-(id)init
{
    if (self = [super init]){
        NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"CommentHeaderView" owner:self options:nil];
        UIView *mainView = [subviewArray objectAtIndex:0];
        [self addSubview:mainView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]){
        NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"CommentHeaderView" owner:self options:nil];
        UIView *mainView = [subviewArray objectAtIndex:0];
        mainView.frame = self.frame;
        [self addSubview:mainView];
    }
    return self;
}

- (void)initWithPhoto:(Photo *)photo
{
    self.nameLabel.text = photo.userName;
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photo.fullPhoto]]];
        dispatch_async(dispatch_get_main_queue(), ^(){
            self.photoImageView.image= img;
        });
    });
    
    self.timeLabel.text = [self calculationTime:photo.time];
}

- (NSString *)calculationTime:(NSDate *)date
{
    NSTimeInterval interval = ABS([date timeIntervalSinceNow]);
    NSString * strTime = [NSString new];
    float minute = 60;
    float hour   = 3600;
    float day    = 86400;
    if (interval > day) {
        int d = round(interval /= day);
        strTime = [strTime stringByAppendingString:[NSString stringWithFormat:@"%d days",d]];
    } else if (interval > hour) {
        int d = round(interval /= hour);
        strTime = [strTime stringByAppendingString:[NSString stringWithFormat:@" %d hour",d]];
    } else if (interval > minute) {
        int d = (interval/minute);
        strTime = [strTime stringByAppendingString:[NSString stringWithFormat:@" %d minute",d]];
    }
    strTime = [strTime stringByAppendingString:@" ago"];
    return strTime;
}

@end
