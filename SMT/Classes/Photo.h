//
//  Photo.h
//  SMT
//
//  Created by Mac on 6/10/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject

@property (strong, nonatomic) NSString * photoID;
@property (strong, nonatomic) NSDictionary * raw;
@property (strong, nonatomic) NSString * uploadDate;
@property (strong, nonatomic) NSString * userName;
@property (strong, nonatomic) NSString * thumbnail;
@property (strong, nonatomic) NSString * fullPhoto;

@end
