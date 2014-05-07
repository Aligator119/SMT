//
//  LocationListCell.h
//  SMT
//
//  Created by Admin on 5/7/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Location;
@interface LocationListCell : UITableViewCell

-(void) processCellInfo: (Location*) _loc;

@end
