#import "DBLoader.h"
#import "Country.h"
#import "Region.h"


@implementation DBLoader


+ (DBLoader *)instance
{
    static DBLoader *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DBLoader alloc] init];
    });
    return instance;
}


- (NSArray *) getContryList
{
    sqlite3 *database;
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"DataBase/region_data.db"];
    NSString *resourcePath;
    
    if ([fileManager fileExistsAtPath:dbPath] == NO) {
        resourcePath = [[NSBundle mainBundle] pathForResource:@"region_data" ofType:@""];
        [fileManager copyItemAtPath:resourcePath toPath:dbPath error:&error];
    }
    
	NSMutableArray * list = [[NSMutableArray alloc] init];
	
    if(sqlite3_open([resourcePath UTF8String], &database) == SQLITE_OK) {
    
      
        NSLog(@"db open is ok %s", sqlite3_errmsg(database));
       
        NSString * sqlStatement = @"select _id, country from country";
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                 //NSLog(@"OK %@", [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)]);
                Country * count = [Country new];
                count._id = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)]intValue];
                count.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                [list addObject:count];
            }
        } else {
            NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
        
        sqlite3_close(database);
    } else {
        NSLog(@"Error: failed open db '%s'.", sqlite3_errmsg(database));
    }
    return list;
}


- (NSArray *) getRegionListWithCountry_id:(int)_id
{
    sqlite3 *database;
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"DataBase/region_data.db"];
    NSString *resourcePath;
    
    if ([fileManager fileExistsAtPath:dbPath] == NO) {
        resourcePath = [[NSBundle mainBundle] pathForResource:@"region_data" ofType:@""];
        [fileManager copyItemAtPath:resourcePath toPath:dbPath error:&error];
    }
    
	NSMutableArray * list = [[NSMutableArray alloc] init];
	
    if(sqlite3_open([resourcePath UTF8String], &database) == SQLITE_OK) {
        
        
        NSLog(@"db open is ok %s", sqlite3_errmsg(database));
        
        NSString * sqlStatement = [NSString stringWithFormat:@"select _id, region from states where country_id=%d", _id];
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                //NSLog(@"OK %@", [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)]);
                Region * reg = [Region new];
                reg._id = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)]intValue];
                reg.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                [list addObject:reg];
            }
        } else {
            NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
        
        sqlite3_close(database);
    } else {
        NSLog(@"Error: failed open db '%s'.", sqlite3_errmsg(database));
    }
    return list;
}


@end
