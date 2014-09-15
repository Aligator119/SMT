#import "FullImageViewController.h"
#import "UIViewController+LoaderCategory.h"
#import "Photo.h"
#import "AppDelegate.h"
#import "DataLoader.h"

#define ZOOM_STEP 2.0

@interface FullImageViewController ()
{
    NSURL * url;
    Photo * _photo;
    AppDelegate * appDelegate;
    DataLoader * dataLoader;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstr;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIScrollView *scrolView;
@property (weak, nonatomic) IBOutlet UIButton *remuvePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *sharePhotoButton;

- (IBAction)actBack:(id)sender;
- (IBAction)actRemovePhoto:(id)sender;
- (IBAction)actSharePhoto:(id)sender;


- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;
@end

@implementation FullImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andImage:(Photo *)photo
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _photo = photo;
        url = [NSURL URLWithString:photo.fullPhoto];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        self.topViewHeightConstr.constant -= 20;
    }
    [self AddActivityIndicator:[UIColor grayColor] forView:self.view];
    
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    // setting remove and shared button
    if ([_photo.userName isEqualToString:appDelegate.user.name]) {
        self.remuvePhotoButton.enabled = YES;
        self.sharePhotoButton.enabled = YES;
        dataLoader = [DataLoader instance];
    }
    
    //Setting up the scrollView
    _scrolView.bouncesZoom = YES;
    _scrolView.delegate = self;
    _scrolView.clipsToBounds = YES;
    
    //Setting up the imageView
    _image.userInteractionEnabled = YES;
    _image.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin);
    
    //Adding the imageView to the scrollView as subView
    _scrolView.contentSize = CGSizeMake(_image.bounds.size.width, _image.bounds.size.height);
    _scrolView.decelerationRate = UIScrollViewDecelerationRateFast;
    
    //UITapGestureRecognizer set up
    //UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerTap:)];
    
    [doubleTap setNumberOfTapsRequired:2];
    [twoFingerTap setNumberOfTouchesRequired:2];
    
    //Adding gesture recognizer
    [_image addGestureRecognizer:doubleTap];
    [_image addGestureRecognizer:twoFingerTap];
    
    // calculate minimum scale to perfectly fit image width, and begin at that scale
    float minimumScale = 1.0;//This is the minimum scale, set it to whatever you want. 1.0 = default
    _scrolView.maximumZoomScale = 4.0;
    _scrolView.minimumZoomScale = minimumScale;
    _scrolView.zoomScale = minimumScale;
    [_scrolView setContentMode:UIViewContentModeScaleAspectFit];
    [_image sizeToFit];
    [_scrolView setContentSize:CGSizeMake(_image.frame.size.width, _image.frame.size.height)];
    
    

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self startLoader];
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            self.image.image = img;
            [self endLoader];
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//---------------------------------------------------------------------------
- (void)scrollViewDidZoom:(UIScrollView *)aScrollView {
    CGFloat offsetX = (_scrolView.bounds.size.width > _scrolView.contentSize.width)?
    (_scrolView.bounds.size.width - _scrolView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (_scrolView.bounds.size.height > _scrolView.contentSize.height)?
    (_scrolView.bounds.size.height - _scrolView.contentSize.height) * 0.5 : 0.0;
    _image.center = CGPointMake(_scrolView.contentSize.width * 0.5 + offsetX,
                                   _scrolView.contentSize.height * 0.5 + offsetY);
}

- (void)viewDidUnload {
    self.scrolView = nil;
    self.image = nil;
}

#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _image;
}

#pragma mark TapDetectingImageViewDelegate methods

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    // zoom in
    float newScale = [_scrolView zoomScale] * ZOOM_STEP;
    
    if (newScale > self.scrolView.maximumZoomScale){
        newScale = self.scrolView.minimumZoomScale;
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
        
        [_scrolView zoomToRect:zoomRect animated:YES];
        
    }
    else{
        
        newScale = self.scrolView.maximumZoomScale;
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
        
        [_scrolView zoomToRect:zoomRect animated:YES];
    }
}


- (void)handleTwoFingerTap:(UIGestureRecognizer *)gestureRecognizer {
    // two-finger tap zooms out
    float newScale = [_scrolView zoomScale] / ZOOM_STEP;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
    [_scrolView zoomToRect:zoomRect animated:YES];
}

#pragma mark Utility methods

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates.
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [_scrolView frame].size.height / scale;
    zoomRect.size.width  = [_scrolView frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}
//----------------------------------------------------------------

- (IBAction)actBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actRemovePhoto:(id)sender {
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        [dataLoader deletePhotoWithId:[_photo.photoID intValue]];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            if(!dataLoader.isCorrectRezult) {
                NSLog(@"Error delete photo");
            } else {
                [self actBack:nil];
            }
        });
    });

}

- (IBAction)actSharePhoto:(id)sender {
}
@end
