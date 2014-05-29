//
//  Species.m
//  SMT
//
//  Created by Alexander on 06.05.14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "Species.h"
#define URLSportsMaster @"http://www.sportsmantracker.com/"
#define SPEC_ID @"id"
#define NAME @"name"
#define DESCRIPTION @"description"
#define PHOTO @"photo"
#define THUMBNAIL @"thumbnail"

@implementation Species

@synthesize specId, name, description, thumbnail, photo;

-(void)initSpeciesWithData:(NSDictionary *)infoDict
{
    specId = [infoDict objectForKey:SPEC_ID];
    name = [infoDict objectForKey:NAME];
    description = [infoDict objectForKey:DESCRIPTION];
    thumbnail = [NSString stringWithFormat:@"%@%@",URLSportsMaster,[infoDict objectForKey:THUMBNAIL]];
    photo = [NSString stringWithFormat:@"%@%@",URLSportsMaster,[infoDict objectForKey:PHOTO]];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:specId forKey:SPEC_ID];
    [encoder encodeObject:name forKey:NAME];
    [encoder encodeObject:description forKey:DESCRIPTION];
    [encoder encodeObject:thumbnail forKey:THUMBNAIL];
    [encoder encodeObject:photo forKey:THUMBNAIL];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init])) {
        specId = [decoder decodeObjectForKey:SPEC_ID];
        name = [decoder decodeObjectForKey:NAME];
        description = [decoder decodeObjectForKey:DESCRIPTION];
        thumbnail = [decoder decodeObjectForKey:THUMBNAIL];
        photo = [decoder decodeObjectForKey:PHOTO];
    }
    return self;
}


@end
