//
//  LocationListCell.m
//  SMT
//
//  Created by Admin on 5/7/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "LocationListCell.h"
#import "Location.h"

@interface LocationListCell (){
    Location *location;
}

@property (nonatomic, weak) IBOutlet UILabel *locationNameLabel;

@end

@implementation LocationListCell

-(void) processCellInfo: (Location*) _loc{
    self.locationNameLabel.text = _loc.locName;
    location = _loc;
}

-(IBAction)infoButtonPressed:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationListInfoButtonPressed" object:location];
}

@end
