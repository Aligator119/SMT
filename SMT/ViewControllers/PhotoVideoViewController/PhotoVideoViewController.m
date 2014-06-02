//
//  PhotoVideoViewController.m
//  SMT
//
//  Created by Mac on 5/6/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "PhotoVideoViewController.h"
#import "LogDetail2ViewController.h"
#import "DataLoader.h"

#define KEY_USERDEFAULT @"added_Image"

@interface PhotoVideoViewController ()
{
    NSUserDefaults * def;
    NSMutableDictionary * dict;
    NSDateFormatter * dateFormatter;
    NSDateFormatter * sectionFormatter;
    DataLoader * dataLoader;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIView *overlayView;

@property (nonatomic) UIImagePickerController *imagePickerController;

@property (nonatomic, weak) NSTimer *cameraTimer;
@property (nonatomic) NSMutableArray *capturedImages;

- (NSDictionary *) getImage;

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
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    sectionFormatter = [[NSDateFormatter alloc]init];
    [sectionFormatter setDateFormat:@"MMMM"];
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
    
    def = [NSUserDefaults standardUserDefaults];
    
    //[def removeObjectForKey:KEY_USERDEFAULT];
    
    dict = [[NSMutableDictionary alloc]initWithDictionary:[self getImage]];
    self.list = [dict allKeys];
    self.list = [self.list sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.list.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray * items = [dict objectForKey:[self.list objectAtIndex:section]];
    return items.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imagecell" forIndexPath:indexPath];
    NSArray * items = [dict objectForKey:[self.list objectAtIndex:indexPath.section]];
    NSDictionary * data = [items objectAtIndex:indexPath.row];
    
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
            cell.image.image = images;
            
        }
        
    };
    
    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
    {
        NSLog(@"can't get image");
        
    };
    
    NSURL *asseturl = [data objectForKey:@"path"];
    
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:asseturl 
                   resultBlock:resultblock   
                  failureBlock:failureblock];
    
    return cell;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
////    if (section) {
////        return CGSizeMake(320, 21);
////    }
//    
//    //return CGSizeZero;
//    return CGSizeMake(320, 35);
//}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CustomHeader * headerView = nil;
    NSDate * mont = [dateFormatter dateFromString:[self.list objectAtIndex:indexPath.section]];
    
    if (kind == UICollectionElementKindSectionHeader) {
        headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        UILabel * lb = [[UILabel alloc]initWithFrame:headerView.frame];
        lb.text = [@" " stringByAppendingString:[sectionFormatter stringFromDate:mont]];
        lb.textColor = [UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:159.0/255.0 alpha:1.0];
        [headerView setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1.0]];
        [headerView addSubview:lb];
        return headerView;
    }
    return nil;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<PhotoViewControllerDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(selectPhoto:)]) {
        [delegate selectPhoto:((ImageCell *)[collectionView cellForItemAtIndexPath:indexPath]).image.image];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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
    NSString * path = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
    NSString * str = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:29320000.0]];
    [self dismissViewControllerAnimated:YES completion:^{
        BOOL flag = NO;
        for (NSString * key in [dict allKeys]) {
        if ([key isEqualToString:str]) {
            NSMutableArray * buffer = [dict objectForKey:str];
            NSDictionary * newImage = [[NSDictionary alloc]initWithObjectsAndKeys:path, @"path", nil];
            [buffer addObject:newImage];
            [dict setObject:buffer forKey:str];
            flag = YES;
            NSData * buf = [NSKeyedArchiver archivedDataWithRootObject:dict];
            [def setObject:buf forKey:KEY_USERDEFAULT];
            [def synchronize];
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
                        [dataLoader uploadPhoto:images];
                        
                    }
                    
                };
                
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"can't get image");
                    
                };
                
                NSURL *asseturl = [newImage objectForKey:@"path"];
                
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
        }
        }
        if (!flag) {
            NSMutableArray * buffer = [[NSMutableArray alloc]init];
            NSDictionary * newImage = [[NSDictionary alloc]initWithObjectsAndKeys:path, @"path", nil];
            [buffer addObject:newImage];
            NSMutableDictionary * newDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
            [newDict addEntriesFromDictionary:@{str: buffer}];
            NSData * buf = [NSKeyedArchiver archivedDataWithRootObject:newDict];
            [def setObject:buf forKey:KEY_USERDEFAULT];
            dict = [newDict mutableCopy];
            [def synchronize];
        }
        self.list = [dict allKeys];
        self.list = [self.list sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        [self.collectionTable reloadData];
    }];
    
}

////----------------------------------------------------------------------------------------------------
//dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//dispatch_async(newQueue, ^(){
//    
//    [dataLoader uploadPhoto:images];
//    
//    dispatch_async(dispatch_get_main_queue(), ^(){
//        
//        if(!dataLoader.isCorrectRezult) {
//            NSLog(@"Error saved detail log");
//        } else {
//            
//        }
//    });
//});


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actTakePhoto:(id)sender {
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
}

- (IBAction)actChooseExisting:(id)sender {
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (NSDictionary *) getImage
{
    NSData * buf = [def objectForKey:KEY_USERDEFAULT];
    NSMutableDictionary * ret = [[NSMutableDictionary alloc]initWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:buf]];
    return ret;
}

- (IBAction)actBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actRefresh:(id)sender {
}
@end
