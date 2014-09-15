#import "PhotoVideoViewController.h"
#import "LogDetail2ViewController.h"
#import "DataLoader.h"
#import "Photo.h"
#import "UIViewController+LoaderCategory.h"
#import "AppDelegate.h"
#import "FullImageViewController.h"

#define KEY_USERDEFAULT @"added_Image"

@interface PhotoVideoViewController ()
{
    NSMutableDictionary * dict;
    NSMutableDictionary * photoDict;
    NSDateFormatter * dateFormatter;
    NSDateFormatter * sectionFormatter;
    NSDateFormatter * selectedFormatter;
    DataLoader * dataLoader;
    NSArray * arrayData;
    AppDelegate * appDelegate;
    MenuViewController * menuController;
    int limit;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;

@property (nonatomic) UIImagePickerController *imagePickerController;

@property (nonatomic, weak) NSTimer *cameraTimer;
@property (nonatomic) NSMutableArray *capturedImages;

- (NSDictionary *) getImage;

- (void) cashedImage:(Photo *)photo;

@end

@implementation PhotoVideoViewController
@synthesize list;

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
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    sectionFormatter = [[NSDateFormatter alloc]init];
    [sectionFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [sectionFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    [sectionFormatter setDateFormat:@"MMMM"];
    selectedFormatter = [[NSDateFormatter alloc]init];
    [selectedFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [selectedFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    [selectedFormatter setDateFormat:@"yyyy-MM"];

    UINib *cellNib = [UINib nibWithNibName:@"ImageCell" bundle:[NSBundle mainBundle]];
    [self.collectionTable registerNib:cellNib forCellWithReuseIdentifier:@"imagecell"];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        self.navigationBarHeightConstr.constant -= 20;
        self.navigationBarVerticalConstr.constant -=20;
    }
    
    dataLoader = [DataLoader instance];
    
    UINib *headerNib = [UINib nibWithNibName:@"CustomHeader" bundle:[NSBundle mainBundle]];
    [self.collectionTable registerClass:[CustomHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.collectionTable registerNib:headerNib forCellWithReuseIdentifier:@"header"];
    
    //def = [NSUserDefaults standardUserDefaults];
    
    //[def removeObjectForKey:KEY_USERDEFAULT];
    
    dict = [[NSMutableDictionary alloc]init];
    photoDict = [[NSMutableDictionary alloc]init];
    //self.list = [dict allKeys];
    //self.list = [self.list sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    
//----------------------------------------------------------------------------------------------------
    //[self startLoader];
    self.screenName = @"Photo screen";
    
    menuController = self.revealViewController;
    
    [self.view addGestureRecognizer:menuController.panGestureRecognizer];
    [_menuButton addTarget:menuController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    limit = 12;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.list = [[NSMutableArray alloc]init];
    [self getImage];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.list.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray * items = [self.list objectAtIndex:section];
    return items.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imagecell" forIndexPath:indexPath];
    NSArray * items = [self.list objectAtIndex:indexPath.section];
    Photo * photo = [items objectAtIndex:indexPath.row];
    if ([photoDict objectForKey:photo.photoID])
    {
        [cell setImg:[photoDict objectForKey:photo.photoID]];
    } else {
        [self cashedImage:photo];
        [cell setImage:photo.fullPhoto];
    }
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CustomHeader * headerView = nil;
    Photo * buffer = [[self.list objectAtIndex:indexPath.section] firstObject];
    NSDate * mont = [dateFormatter dateFromString:buffer.uploadDate];
    
    if (kind == UICollectionElementKindSectionHeader) {
        headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        //UILabel * lb = [[UILabel alloc]initWithFrame:headerView.frame];
        //lb.text = [sectionFormatter stringFromDate:mont];
        //lb.textColor = [UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:159.0/255.0 alpha:1.0];
        [headerView setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1.0]];
        headerView.lbName.text = [sectionFormatter stringFromDate:mont];
        //[headerView addSubview:lb];
        return headerView;
    }
    return nil;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * items = [self.list objectAtIndex:indexPath.section];
    Photo * photo = [items objectAtIndex:indexPath.row];
    FullImageViewController * fullVC = [[FullImageViewController alloc]initWithNibName:@"FullImageViewController" bundle:nil andImage:photo];
    [self.navigationController pushViewController:fullVC animated:YES];
}

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    if (self.imageView.isAnimating)
    {
        [self.imageView stopAnimating];
    }
    
    if (self.capturedImages.count > 0)
    {
        [self.capturedImages removeAllObjects];
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
       
        imagePickerController.showsCameraControls = NO;
        
       
        [[NSBundle mainBundle] loadNibNamed:@"OverlayView" owner:self options:nil];
        self.overlayView.frame = imagePickerController.cameraOverlayView.frame;
        imagePickerController.cameraOverlayView = self.overlayView;
        self.overlayView = nil;
    }
    
    self.imagePickerController = imagePickerController;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    [self dismissViewControllerAnimated:YES completion:^{

//----------------------------------------------------------------------------------------------------
        dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(newQueue, ^(){
            typedef void (^ALAssetsLibraryAssetForURLResultBlock)(ALAsset *asset);
            typedef void (^ALAssetsLibraryAccessFailureBlock)(NSError *error);
            
            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
            {
                ALAssetRepresentation *rep = [myasset defaultRepresentation];
                CGImageRef iref = [rep fullResolutionImage];
                UIImage *images;
                if (iref)
                {
                    
                    images = [UIImage imageWithCGImage:iref scale:[rep scale] orientation:(UIImageOrientation)[rep orientation]];
                    NSString * iD = [dataLoader uploadPhoto:images];
                    NSLog(@"%@",iD);
                    [self getImage];
                    
                }
                
            };
            
            ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
            {
                NSLog(@"can't get image");
                
            };
            
            NSURL *asseturl = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
            
            ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
            [assetslibrary assetForURL:asseturl
                           resultBlock:resultblock
                          failureBlock:failureblock];
            
            dispatch_async(dispatch_get_main_queue(), ^(){
                
                if(!dataLoader.isCorrectRezult) {
                    NSLog(@"Error saved detail log");
                } else {
                    
                }
            });
        });
    }];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actTakePhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)actChooseExisting:(id)sender {
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (NSDictionary *) getImage
{
    [self.list removeAllObjects];
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        
        arrayData = [dataLoader getPhotoWithLimit:[NSString stringWithFormat:@"%d", limit]];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            if(!dataLoader.isCorrectRezult) {
                NSLog(@"Error download sybSpecie");
            } else {
                for (Photo * photo in arrayData) {
                    NSDate * uploadDate = [NSDate date];
                    uploadDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",photo.uploadDate]];
                    if ([[dict allKeys] containsObject:[selectedFormatter stringFromDate:uploadDate]]){
                        NSMutableArray * buffer = [dict objectForKey:[selectedFormatter stringFromDate:uploadDate]];
                        [buffer addObject:photo];
                        [dict setObject:buffer forKey:[selectedFormatter stringFromDate:uploadDate]];
                    } else {
                        NSMutableArray * buffer = [[NSMutableArray alloc]init];
                        [buffer addObject:photo];
                        NSMutableDictionary * newDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
                        [newDict addEntriesFromDictionary:@{[selectedFormatter stringFromDate:uploadDate]: buffer}];
                        dict = [newDict mutableCopy];
                    }
                }
                for (NSString * key in [[dict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]) {
                    NSArray * newArray = [dict objectForKey:key];
                    [self.list addObject:newArray];
                }
                [dict removeAllObjects];
//                self.list = [dict allKeys];
//                self.list = [self.list sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
                [self.collectionTable reloadData];
                
            }
        });
    });

    return nil;
}

- (void) cashedImage:(Photo *)photo
{
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        
        NSURL * url = [NSURL URLWithString:photo.thumbnail];
        NSData * imgData = [NSData dataWithContentsOfURL:url];
        UIImage * img = [UIImage imageWithData:imgData];
        
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            [photoDict setValue:img forKey:photo.photoID];
            [self.collectionTable reloadData];
        });
    });
}

@end
