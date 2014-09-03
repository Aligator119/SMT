#import <Foundation/Foundation.h>

@interface Photo : NSObject

@property (strong, nonatomic) NSString * photoID;
@property (strong, nonatomic) NSDictionary * raw;
@property (strong, nonatomic) NSString * uploadDate;
@property (strong, nonatomic) NSString * userName;
@property (strong, nonatomic) NSString * thumbnail;
@property (strong, nonatomic) NSString * fullPhoto;
@property (strong, nonatomic) NSString * description;
@property (strong, nonatomic) NSString * caption;
@property (strong, nonatomic) NSDate *time;

@end
