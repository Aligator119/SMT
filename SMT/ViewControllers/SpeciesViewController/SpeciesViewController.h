#import <UIKit/UIKit.h>
#import "Species.h"
@protocol SpeciesViewControllerDelegate;

@protocol SpeciesViewControllerDelegate <NSObject>

@required

- (void)selectSpecies:(Species*)species;

@end

@interface SpeciesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id<SpeciesViewControllerDelegate> delegate;


@end
