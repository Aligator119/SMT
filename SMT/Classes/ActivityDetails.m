//
//  ActivityDetails.m
//  SMT
//
//  Created by Admin on 5/26/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "ActivityDetails.h"

@implementation ActivityDetails

- (id) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]){
        self.subspecies_id = [[aDecoder decodeObjectForKey:@"subspecies"] integerValue];
        self.activitylevel = [[aDecoder decodeObjectForKey:@"activitylevel"] integerValue];
        self.harvested = [[aDecoder decodeObjectForKey:@"harvested"] integerValue];
        self.seen = [[aDecoder decodeObjectForKey:@"seen"] integerValue];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:[NSString stringWithFormat:@"%d", self.subspecies_id] forKey:@"subspecies_id"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%d", self.activitylevel] forKey:@"activitylevel"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%d", self.harvested] forKey:@"harvested"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%d", self.seen] forKey:@"seen"];
}

@end
