//
//  CreateTipsCell.h
//  SMT
//
//  Created by Mac on 7/2/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Species.h"

@interface CreateTipsCell : UICollectionViewCell //<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *tfText;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectSpecie;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectSubSpecie;


@property (strong, nonatomic) Species * specie;
@property (strong, nonatomic) Species * subSpecie;

@end
