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

- (void)setImageWithURL:(NSURL *) url andImageID:(NSString *)photoID andDescriptions:(NSString *)str
{
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            [self setPhotoDescriptions:str];
            self.img.image = image;
            [[NSNotificationCenter defaultCenter] postNotificationName:DOWNLOAD_IMAGE_SUCCES object:self userInfo:@{photoID: image}];
        });
    });

}

- (void)setPhotoDescriptions:(NSString *)str
{
    if (!str) {
        self.heigthImage.constant = 0.0;
        [self updateConstraints];
    } else {
        self.lbDescriptions.text = str;
    }
}


- (void)setImage:(UIImage *)image
{
    self.heigthImage.constant = 0.0;
    [self updateConstraints];
    self.img.image = image;
}

- (void)prepareForReuse
{
    self.img.image = [[UIImage alloc]init];
}

- (void)prepareToReuse
{
    self.img.image = [[UIImage alloc]init];
}


@end
