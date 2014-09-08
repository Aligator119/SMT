#import "CommentTableViewCell.h"

@interface CommentTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation CommentTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)initWithData:(NSDictionary *)dict
{
    self.commentLabel.text = [dict objectForKey:@"comment"];
    self.timeLabel.text = [self calculationTime:[dict objectForKey:@"timestamp"]];
}

- (NSString *)calculationTime:(NSString *)date
{
    NSDateFormatter * dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate * dat = [dateFormatter dateFromString:date];
    NSTimeInterval interval = ABS([dat timeIntervalSinceNow]);
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
