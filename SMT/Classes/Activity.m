#import "Activity.h"

@implementation Activity

- (id) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]){
        self.startTime = [aDecoder decodeObjectForKey:@"startTime"];
        self.date = [aDecoder decodeObjectForKey:@"date"];
        self.endTime = [aDecoder decodeObjectForKey:@"endTime"];
        self.location_id = [[aDecoder decodeObjectForKey:@"location_id"] integerValue];
        self.notes = [aDecoder decodeObjectForKey:@"notes"];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.startTime forKey:@"startTime"];
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.endTime forKey:@"endTime"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%d", self.location_id] forKey:@"location_id"];
    [aCoder encodeObject:self.notes forKey:@"notes"];
}
@end
