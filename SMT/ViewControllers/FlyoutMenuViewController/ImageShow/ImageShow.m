#import "ImageShow.h"
#import "UIViewController+LoaderCategory.h"

#define DOWNLOAD_IMAGE_SUCCES @"image is download"
#define ActiveTag 12321

const NSInteger timeFontSize = 13;

@interface ImageShow ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelWidthConstraint;
@end
@implementation ImageShow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIActivityIndicatorView * a = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.contentView addSubview:a];
        
        //CGPoint point = self.center;
        //point.y = self.contentView.frame.size.height/2 + 25;
        a.center = self.center;
        
        a.color = [UIColor blackColor];
        a.hidesWhenStopped = YES;
        a.tag = ActiveTag;
    }
    return self;
}

- (void)setImageWithURL:(NSURL *) url andImageID:(NSString *)photoID descriptions:(NSString *)str andUserName:(NSString *)name
{
    self.btnComment.tag = [photoID intValue];
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            [self setPhotoDescriptions:str andUserName:name andImage:image photoID:photoID];
            //self.img.image = image;
            [[NSNotificationCenter defaultCenter] postNotificationName:DOWNLOAD_IMAGE_SUCCES object:self userInfo:@{photoID: image}];
        });
    });

}

- (void)setPhotoDescriptions:(NSString *)str andUserName:(NSString *)name andImage:(UIImage *)image photoID:(NSString *)photo_id
{
    self.lbName.text = name;
    self.img.image = image;
    self.btnComment.tag = [photo_id intValue];
    if (str) {
        self.lbDescriptions.text = str;
    } else {
        self.lbDescriptions.text = @"";
    }
    [self.btnComment.layer setMasksToBounds:YES];
    self.btnComment.layer.borderWidth = 0.5f;
    self.btnComment.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
    [self.btnComment setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0]];
}

- (void)setPhotoDescriptions:(NSString *)str andUserName:(NSString *)name andTime:(NSDate*)time andImage:(UIImage *)image photoID:(NSString *)photo_id
{
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd MMMM yyyy";
    self.timeLabel.text = [dateFormatter stringFromDate:time];
    
    self.labelWidthConstraint.constant = [self getWidthText:self.timeLabel.text andLabelHeight:self.timeLabel.frame.size.height] + 5;
    
    self.lbName.text = name;
    self.img.image = image;
    self.btnComment.tag = [photo_id intValue];
    if (str) {
        self.lbDescriptions.text = str;
    } else {
        self.lbDescriptions.text = @"";
    }
    [self.btnComment.layer setMasksToBounds:YES];
    self.btnComment.layer.borderWidth = 0.5f;
    self.btnComment.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
    [self.btnComment setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0]];
}


- (void)startLaderInCell
{
    [self.btnComment.layer setMasksToBounds:YES];
    self.btnComment.layer.borderWidth = 0.5f;
    self.btnComment.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
    [self.btnComment setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0]];
    UIActivityIndicatorView * a = (UIActivityIndicatorView* )[self.contentView viewWithTag:ActiveTag];
    [a startAnimating];
}


- (void)stopLoaderInCell
{
    UIActivityIndicatorView * a = (UIActivityIndicatorView* )[self.contentView viewWithTag:ActiveTag];
    [a stopAnimating];
}


- (void)prepareForReuse
{
    self.lbName.text = @"";
    self.img.image = [UIImage imageNamed:@"placeholderImage.png"];
}

- (float) getWidthText:(NSString *)str andLabelHeight:(float) lbHeight
{
    float f = 0;
    
    if (str) {
        //CGFloat labelWidth = self.view.frame.size.width - 30.0f;
        CGSize contentTextSize = [str sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size: timeFontSize]
                                 constrainedToSize:CGSizeMake(200, lbHeight)
                                     lineBreakMode:NSLineBreakByWordWrapping];
        
        f = contentTextSize.width;
        
    }
    return f;
}


@end
