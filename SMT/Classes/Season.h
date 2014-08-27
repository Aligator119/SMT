#import <Foundation/Foundation.h>

@interface Season : NSObject

@property (strong, nonatomic) NSString * name;
@property (nonatomic) int season_id;
@property (nonatomic) int speciescategory_id;
@property (nonatomic, strong) NSString * description;
@property (nonatomic, strong) NSString * photo;
@property (nonatomic, strong) NSString * thumbnail;
@property (nonatomic) BOOL active;
@property (nonatomic) int seenVar;
@property (nonatomic) int harvestVar;
@property (nonatomic) int locationtype_id;
@property (nonatomic, strong) NSDictionary * category;
@property (nonatomic, strong) NSArray * subspecies;
@property (nonatomic, strong) NSArray * youtube_playlist;
@property (nonatomic, strong) NSArray * photos;


-(void)initSeasonWithData:(NSDictionary*) infoDict;


@end
