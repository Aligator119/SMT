//
//  TIPS.h
//  SMT
//
//  Created by Mac on 7/2/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TIPS : NSObject
@property (strong, nonatomic) NSString * tipsID;
@property (strong, nonatomic) NSString * species_id;
@property (strong, nonatomic) NSString * subspecies_id;
@property (strong, nonatomic) NSString * tip;
@property (strong, nonatomic) NSString * user_id;

-(void)initTipsWithData:(NSDictionary*) infoDict;

@end
