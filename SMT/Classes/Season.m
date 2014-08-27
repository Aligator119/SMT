#import "Season.h"


#define NAME             @"name"
#define SEASON_ID        @"id"
#define DESCRIPTION      @"description"
#define PHOTO            @"photo"
#define THUMBNAIL        @"thumbnail"
#define SEEN             @"seenVar"
#define HARVEST          @"harvestVar"
#define LOCATION_ID      @"locationtype_id"
#define CATEGORY         @"category"
#define SUBSPECIES       @"subspecies"
#define SPECIES_CATEGORY @"speciescategory_id"
#define ACTIVE           @"active"
#define YOUTUBE          @"youtube_playlist"
#define PHOTOS           @"photos"

#define CATEGORY_ID    @"id"
#define CATEGORY_TITLE @"title"


@implementation Season

@synthesize name, season_id, speciescategory_id, description, photo, thumbnail, active, seenVar, harvestVar, locationtype_id, category, subspecies, youtube_playlist, photos;

-(void)initSeasonWithData:(NSDictionary*) infoDict
{
    name            = [infoDict objectForKey:NAME];
    season_id       = [[infoDict objectForKey:SEASON_ID] intValue];
    description     = [infoDict objectForKey:DESCRIPTION];
    photo           = [infoDict objectForKey:PHOTO];
    thumbnail       = [infoDict objectForKey:THUMBNAIL];
    seenVar         = [[infoDict objectForKey:SEEN]intValue];
    harvestVar      = [[infoDict objectForKey:HARVEST]intValue];
    locationtype_id = [[infoDict objectForKey:LOCATION_ID]intValue];
    category        = [infoDict objectForKey:CATEGORY];
    subspecies      = [infoDict objectForKey:SUBSPECIES];
    
    speciescategory_id = [[infoDict objectForKey:SPECIES_CATEGORY]intValue];
    active             = [[infoDict objectForKey:ACTIVE]boolValue];
    youtube_playlist   = [infoDict objectForKey:YOUTUBE];
    photos             = [infoDict objectForKey:PHOTOS];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:name forKey:NAME];
    [encoder encodeObject:@(season_id) forKey:SEASON_ID];
    [encoder encodeObject:description forKey:DESCRIPTION];
    [encoder encodeObject:photo forKey:PHOTO];
    [encoder encodeObject:thumbnail forKey:THUMBNAIL];
    [encoder encodeObject:@(seenVar) forKey:SEEN];
    [encoder encodeObject:@(harvestVar) forKey:HARVEST];
    [encoder encodeObject:@(locationtype_id) forKey:LOCATION_ID];
    [encoder encodeObject:category forKey:CATEGORY];
    [encoder encodeObject:subspecies forKey:SUBSPECIES];
    
    [encoder encodeObject:@(speciescategory_id) forKey:SPECIES_CATEGORY];
    [encoder encodeObject:@(active) forKey:ACTIVE];
    [encoder encodeObject:youtube_playlist forKey:YOUTUBE];
    [encoder encodeObject:photos forKey:PHOTOS];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init])) {
        name = [decoder decodeObjectForKey:NAME];
        season_id = [[decoder decodeObjectForKey:SEASON_ID]intValue];
        description = [decoder decodeObjectForKey:DESCRIPTION];
        photo = [decoder decodeObjectForKey:PHOTO];
        thumbnail = [decoder decodeObjectForKey:THUMBNAIL];
        seenVar = [[decoder decodeObjectForKey:SEEN]intValue];
        harvestVar = [[decoder decodeObjectForKey:HARVEST]intValue];
        locationtype_id = [[decoder decodeObjectForKey:LOCATION_ID]intValue];
        category = [decoder decodeObjectForKey:CATEGORY];
        subspecies = [decoder decodeObjectForKey:SUBSPECIES];
        
        speciescategory_id = [[decoder decodeObjectForKey:SPECIES_CATEGORY]intValue];
        active = [[decoder decodeObjectForKey:ACTIVE]boolValue];
        youtube_playlist = [decoder decodeObjectForKey:YOUTUBE];
        photos = [decoder decodeObjectForKey:PHOTOS];

    }
    return self;
}


@end
