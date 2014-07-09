#import "TIPS.h"

#define USER_ID       @"user_id"
#define SPECIE_ID     @"species_id"
#define SUB_SPECIE_ID @"subspecies_id"
#define TIP           @"tip"
#define TIPS_ID       @"id"
#define TIMESTAMP     @"timestamp"

@implementation TIPS

@synthesize user_id, species_id, subspecies_id, tip, tipsID, timestamp;

-(void)initTipsWithData:(NSDictionary*) infoDict
{
    tipsID        = [infoDict objectForKey:TIPS_ID];
    species_id    = [infoDict objectForKey:SPECIE_ID];
    tip           = [infoDict objectForKey:TIP];
    subspecies_id = [infoDict objectForKey:SUB_SPECIE_ID];
    user_id       = [infoDict objectForKey:USER_ID];
    timestamp     = [infoDict objectForKey:TIMESTAMP];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:tipsID forKey:TIPS_ID];
    [encoder encodeObject:species_id forKey:SPECIE_ID];
    [encoder encodeObject:tip forKey:TIP];
    [encoder encodeObject:subspecies_id forKey:SUB_SPECIE_ID];
    [encoder encodeObject:user_id forKey:USER_ID];
    [encoder encodeObject:timestamp forKey:TIMESTAMP];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init])) {
        tipsID = [decoder decodeObjectForKey:TIPS_ID];
        species_id = [decoder decodeObjectForKey:SPECIE_ID];
        tip = [decoder decodeObjectForKey:TIP];
        subspecies_id = [decoder decodeObjectForKey:SUB_SPECIE_ID];
        user_id = [decoder decodeObjectForKey:USER_ID];
        timestamp = [decoder decodeObjectForKey:TIMESTAMP];
    }
    return self;
}


@end
