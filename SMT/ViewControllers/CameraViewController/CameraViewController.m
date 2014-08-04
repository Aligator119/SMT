#import "CameraViewController.h"
#import "DataLoader.h"
#import "UIViewController+LoaderCategory.h"
#import <AVFoundation/AVFoundation.h>

@interface CameraViewController ()
{
    DataLoader * dataLoader;
    AVCaptureSession * session;
    AVCaptureStillImageOutput * stillImageOutput;
    BOOL frontCamera;
}
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *captureView;

- (IBAction)actOpenGalery:(id)sender;

- (IBAction)actTakePhoto:(id)sender;

- (IBAction)actClose:(id)sender;

- (IBAction)actChangeCamera:(id)sender;

- (AVCaptureDevice *)frontCamera;
- (void) settingInputDevice:(AVCaptureDevice *)inputDevice;
@end

@implementation CameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dataLoader = [DataLoader instance];
    [self AddActivityIndicator:[UIColor grayColor] forView:self.view];
    
    self.screenName = @"Camera screen";
    frontCamera = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self settingInputDevice:[self frontCamera]];
}


- (AVCaptureDevice *)frontCamera {
    AVCaptureDevice * inputDevice;
    if (frontCamera) {
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *device in devices) {
            if ([device position] == AVCaptureDevicePositionFront) {
                inputDevice = device;
            }
        }

    } else {
        inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return inputDevice;
}

- (void) settingInputDevice:(AVCaptureDevice *)inputDevice
{
    session = [[AVCaptureSession alloc]init];
    [session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    //AVCaptureDevice * inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError * error;
    AVCaptureDeviceInput * device = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
    
    if ([session canAddInput:device]) {
        [session addInput:device];
    }
    
    AVCaptureVideoPreviewLayer * preLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:session];
    [preLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    CALayer * rootLayer = [[self view] layer];
    [rootLayer setMasksToBounds:YES];
    CGRect frame = self.captureView.frame;
    
    [preLayer setFrame:frame];
    
    [rootLayer insertSublayer:preLayer atIndex:0];
    
    stillImageOutput = [[AVCaptureStillImageOutput alloc]init];
    NSDictionary * outputSettings = [[NSDictionary alloc]initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:stillImageOutput];
    
    [session startRunning];

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;

    [picker dismissViewControllerAnimated:YES completion:^{
        //l
    }];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:^{
       //l
    }];
    
}

- (IBAction)actSelectPhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)actSetAvatar:(id)sender {
    if (self.imageView.image) {
    [self startLoader];
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        
        [dataLoader setUserAvatar:self.imageView.image];
        
        dispatch_async(dispatch_get_main_queue(),^(){
            
            if(!dataLoader.isCorrectRezult) {
                NSLog(@"Error upload avatar");
                [self endLoader];
            } else {
                
                id<CameraControllerDelegate> delegate = self.delegate;
                if ([delegate respondsToSelector:@selector(newUserAvatar:)]) {
                    [delegate newUserAvatar:self.imageView.image];
                }
                [self endLoader];
            }
            
        });
    });
    }

}






- (IBAction)actOpenGalery:(id)sender {
}

- (IBAction)actTakePhoto:(id)sender {
    AVCaptureConnection * videoConnection = nil;
    
    for (AVCaptureConnection * connection in stillImageOutput.connections) {
        for (AVCaptureInputPort * port in connection.inputPorts) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if(imageDataSampleBuffer != NULL) {
            NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage * image = [UIImage imageWithData:imageData];
            self.imageView.image = image;
            self.captureView.hidden = YES;
            self.imageView.hidden = NO;
        }
    }];

}

- (IBAction)actClose:(id)sender {
    
}

- (IBAction)actChangeCamera:(id)sender {
    frontCamera = !frontCamera;
    [self settingInputDevice:[self frontCamera]];
}
@end
