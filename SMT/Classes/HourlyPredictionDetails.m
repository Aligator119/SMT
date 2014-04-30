//
//  HourlyPredictionDetails.m
//  HunterPredictor
//
//  Created by Vasya on 13.01.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import "HourlyPredictionDetails.h"
#import "ConstantsClass.h"

@implementation HourlyPredictionDetails

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setName:@" " description:@" " stars:0];
    }
    return self;
}

- (void)setName:(NSString *)_nameDetail description:(NSString*) _descriptionD stars:(NSString*)count{
    self.name = _nameDetail;
    self.description = _descriptionD;
    self.starsCount = count;
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    
    if (self=[super init]){
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.description = [aDecoder decodeObjectForKey:@"description"];
        self.starsCount = [aDecoder decodeObjectForKey:@"starsCount"];
    }
    
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.description forKey:@"description"];
    [aCoder encodeObject:self.starsCount forKey:@"starsCount"];
}




@end
