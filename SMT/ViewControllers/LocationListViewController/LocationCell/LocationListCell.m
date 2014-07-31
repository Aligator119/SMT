#import "LocationListCell.h"
#import "Location.h"

@interface LocationListCell (){
    Location *location;
}

@property (nonatomic, weak) IBOutlet UILabel *locationNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWigth;
@property (weak, nonatomic) IBOutlet UIImageView *locationIcon;

@end

@implementation LocationListCell

-(void) processCellInfo: (Location*) _loc{
    self.locationNameLabel.text = _loc.locName;
    location = _loc;
    if (_loc.typeLocation == 1) {
        self.imageWigth.constant = 30;
        [self updateConstraintsIfNeeded];
        self.locationIcon.image = [UIImage imageNamed:@"hunt_mode_icon_selected.png"];
    } else if (_loc.typeLocation == 2) {
        self.imageWigth.constant = 30;
        [self updateConstraintsIfNeeded];
         self.locationIcon.image = [UIImage imageNamed:@"fish_mode_icon_selected.png"];
    } else {
        self.imageWigth.constant = 30;
        [self updateConstraintsIfNeeded];
        self.locationIcon.image = [UIImage imageNamed:@"fish_mode_icon_selected.png"];
    }
}


@end
