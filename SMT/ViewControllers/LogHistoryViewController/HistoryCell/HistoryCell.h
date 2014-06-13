//
//  HistoryCell.h
//  SMT
//
//  Created by Mac on 5/29/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Species.h"
#import "DataLoader.h"

@interface HistoryCell : UITableViewCell

- (void) setCellFromSpecies:(NSDictionary *) specie;

@end
