#import "CameraViewController.h"
#import "DataLoader.h"
#import "UIViewController+LoaderCategory.h"
#import <AVFoundation/AVFoundation.h>

@interface CameraViewController ()
{
    DataLoader * dataLoader;
    AVCaptureSession * session;
    AVCaptureStillImageOutput * stillImageOutput;
    AVCaptureVideoPreviewLayer * preLayer;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *captureView;
@property (strong, nonatomic) IBOutlet UIView *presentView;

- (IBAction)actOpenGalery:(id)sender;

- (IBAction)actTakePhoto:(id)sender;

- (IBAction)actClose:(id)sender;

- (IBAction)actChangeCamera:(id)sender;

- (IBAction)actConfirm:(id)sender;

- (IBAction)actRetake:(id)sender;

- (void) settingInputDevice;
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
    
    self.isReturnImage = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [session stopRunning];
    
    [self settingInputDevice];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self resetCamera];
}

- (void) settingInputDevice
{
    session = [[AVCaptureSession alloc]init];
    [session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    AVCaptureDevice * inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError * error;
    AVCaptureDeviceInput * device = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
    
    if ([session canAddInput:device]) {
        [session addInput:device];
    }
    
    preLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:session];
    [preLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    CALayer * rootLayer = [[self view] layer];
    [rootLayer setMasksToBounds:YES];
    CGRect frame = self.view.frame;
    
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
    [self.view addSubview:self.presentView];

    [picker dismissViewControllerAnimated:YES completion:^{
        //sdfghjkl
    }];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:^{
       
    }];
    
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
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
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
            [self.view addSubview:self.presentView];
        }
    }];
}

- (IBAction)actClose:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:^{
//        //-
//    }];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)actChangeCamera:(id)sender {
    if(session)
    {
        //Indicate that some changes will be made to the session
        [session beginConfiguration];
        
        //Remove existing input
        AVCaptureInput* currentCameraInput = [session.inputs objectAtIndex:0];
        [session removeInput:currentCameraInput];
        
        //Get new input
        AVCaptureDevice *newCamera = nil;
        if(((AVCaptureDeviceInput*)currentCameraInput).device.position == AVCaptureDevicePositionBack)
        {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
        }
        else
        {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
        }
        
        //Add input to session
        AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:newCamera error:nil];
        [session addInput:newVideoInput];
        
        //Commit all the configuration changes at once
        [session commitConfiguration];
    }



}

- (IBAction)actConfirm:(id)sender {
    if (self.isReturnImage) {
        id<CameraControllerDelegate> delegate = self.delegate;
        if ([delegate respondsToSelector:@selector(returnImage:)]) {
            [delegate returnImage:self.imageView.image];
        }
    } else {
        // add logic to create log
    }
}

- (IBAction)actRetake:(id)sender {
    
    [self.presentView removeFromSuperview];
    [self resetCamera];
    [self viewWillAppear:YES];
}

- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == position) return device;
    }
    return nil;
}


- (void) resetCamera
{
    if([session isRunning])[session stopRunning];
    AVCaptureInput* input = [session.inputs objectAtIndex:0];
    [session removeInput:input];
    AVCaptureVideoDataOutput* output = (AVCaptureVideoDataOutput*)[session.outputs objectAtIndex:0];
    [session removeOutput:output];
    [preLayer removeFromSuperlayer];
    
    preLayer = nil;
    session = nil;
}

@end
