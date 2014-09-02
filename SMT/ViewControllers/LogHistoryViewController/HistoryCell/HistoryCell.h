#import <UIKit/UIKit.h>
#import "Species.h"
#import "DataLoader.h"

@interface HistoryCell : UITableViewCell

- (void) setCellFromSpecies:(NSDictionary *) specie;

@end
