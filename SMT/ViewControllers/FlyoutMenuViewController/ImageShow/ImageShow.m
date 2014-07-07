#import "ImageShow.h"

#define DOWNLOAD_IMAGE_SUCCES @"image is download"

@implementation ImageShow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setImageWithURL:(NSURL *) url andImageID:(NSString *)photoID
{
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            self.image.image = image;
            [[NSNotificationCenter defaultCenter] postNotificationName:DOWNLOAD_IMAGE_SUCCES object:self userInfo:@{photoID: image}];
        });
    });

}

- (void)prepareForReuse
{
    self.image.image = [[UIImage alloc]init];
}

- (void)prepareToReuse
{
    self.image.image = [[UIImage alloc]init];
}


@end
