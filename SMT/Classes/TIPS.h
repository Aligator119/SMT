#import <Foundation/Foundation.h>

@interface TIPS : NSObject
@property (strong, nonatomic) NSString * tipsID;
@property (strong, nonatomic) NSString * species_id;
@property (strong, nonatomic) NSString * subspecies_id;
@property (strong, nonatomic) NSString * tip;
@property (strong, nonatomic) NSString * user_id;
@property (strong, nonatomic) NSString * timestamp;
@property (strong, nonatomic) NSString * userName;

-(void)initTipsWithData:(NSDictionary*) infoDict;

@end
