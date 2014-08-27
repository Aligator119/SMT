#import <Foundation/Foundation.h>

@interface Region : NSObject

@property (strong, nonatomic) NSString * name;
@property (nonatomic) int _id;
@property (nonatomic) int country_id;
@property (strong, nonatomic) NSString * code;
@property (strong, nonatomic) NSString * adm1code;

@end
