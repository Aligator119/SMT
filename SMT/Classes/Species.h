//
//  Species.h
//  SMT
//
//  Created by Alexander on 06.05.14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Species;

@interface Species : NSObject

@property (strong, nonatomic) NSString *specId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *thumbnail;
@property (strong, nonatomic) NSString *photo;
@property (nonatomic) int seen;
@property (nonatomic) int harvested;
@property (strong, nonatomic) NSString * required;

-(void)initSpeciesWithData:(NSDictionary*) infoDict;

@end
