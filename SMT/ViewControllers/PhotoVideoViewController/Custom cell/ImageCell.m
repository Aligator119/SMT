#import "ImageCell.h"

#define ActiveTag 12321


@implementation ImageCell

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
        
        //CGRect screenRect = self.contentView.bounds; //[[UIScreen mainScreen] bounds];
        a.center = self.contentView.center; //CGPointMake(screenRect.size.width/2,screenRect.size.height/2);
        
        a.color = [UIColor blackColor];
        a.hidesWhenStopped = YES;
        a.tag = ActiveTag;
    }
    return self;
}

- (void)setImg:(UIImage *)img
{
    UIActivityIndicatorView * a = (UIActivityIndicatorView* )[self.contentView viewWithTag:ActiveTag];
    [a stopAnimating];
    self.foneImage.image = img;
}

- (void) setImage:(NSString *)url
{
    UIActivityIndicatorView * a = (UIActivityIndicatorView* )[self.contentView viewWithTag:ActiveTag];
    [a startAnimating];
//    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(newQueue, ^(){
//    
//        _img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
//        
//        dispatch_async(dispatch_get_main_queue(), ^(){
//            
//            self.foneImage.image = _img;
//            UIActivityIndicatorView * a = (UIActivityIndicatorView* )[self.contentView viewWithTag:ActiveTag];
//            [a stopAnimating];
//        });
//    });
}

- (void) prepareForReuse
{
    self.foneImage.image = nil;
}

@end
