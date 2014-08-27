#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBLoader : NSObject

@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 * myDataBase;

+ (DBLoader *)instance;
- (NSArray *) getContryList;
- (NSArray *) getRegionListWithCountry_id:(int)_id;

@end
