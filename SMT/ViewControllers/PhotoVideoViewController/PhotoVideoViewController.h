//
//  PhotoVideoViewController.h
//  SMT
//
//  Created by Mac on 5/6/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "CustomHeader.h"
#import "Photo.h"

@protocol PhotoViewControllerDelegate <NSObject>

@required

- (void)selectPhoto:(Photo *)photo;

@end


@interface PhotoVideoViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) id<PhotoViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionTable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *navigationBarHeightConstr;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *navigationBarVerticalConstr;
@property (strong, nonatomic) NSArray *list;
@property (strong, nonatomic) id controller;

- (IBAction)actTakePhoto:(id)sender;
- (IBAction)actChooseExisting:(id)sender;

- (IBAction)actBack:(id)sender;
- (IBAction)actRefresh:(id)sender;

@end
