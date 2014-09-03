#import "CellForFirstView.h"

@implementation CellForFirstView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initWithSeason:(Season *)season
{
    self.lbName.text = season.name;
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:season.thumbnail]]];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            self.imgShow.image = image;
            if (!self.imgShow.image){
                self.imgShow.image = [UIImage imageNamed:@"menu_BG"];
            }
        });
    });
    

}

@end
