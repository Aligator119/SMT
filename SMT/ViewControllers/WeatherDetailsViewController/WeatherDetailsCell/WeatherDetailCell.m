//
//  WeatherDetailCell.m
//  HunterPredictor
//
//  Created by Aleksey on 2/20/14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import "WeatherDetailCell.h"

@implementation WeatherDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setWindDirectionN:(NSString*)strWindDirection{
    UIImage * img;
    if(strWindDirection.length <= 2){
        img = [UIImage imageNamed:[NSString stringWithFormat:@"%@_arrow_icon.png",strWindDirection]];
        if(img == nil) {
            NSString * charFirst = [strWindDirection substringToIndex:1];
            NSString * charSecond = [strWindDirection substringFromIndex:1];
            strWindDirection = [NSString stringWithFormat:@"%@%@",charSecond,charFirst];
            img = [UIImage imageNamed:[NSString stringWithFormat:@"%@_arrow_icon.png",strWindDirection]];
        }
        self.windDirectionIcon.image = img;
    } else {
        NSArray * arrKeys = [[NSArray alloc] initWithObjects:@"SSE",@"WSW",@"NNW",@"ENE", nil];
        float gradusReturn = 22.5f;
        BOOL isAddedValue = NO;
        for(NSString* strCompare in arrKeys){
            if([strCompare isEqualToString:strWindDirection]) {
                strWindDirection = [strWindDirection substringFromIndex:1];
                isAddedValue = YES;
                break;
            }
            if(isAddedValue) break;
        }
        if(!isAddedValue){
            strWindDirection = [strWindDirection substringFromIndex:1];
            gradusReturn *= -1;
        }
        img = [UIImage imageNamed:[NSString stringWithFormat:@"%@_arrow_icon.png",strWindDirection]];
        self.windDirectionIcon.image = img;
        [self chooseWindDirection:gradusReturn];
    }
}

- (void)chooseWindDirection:(float)_gradus{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.01f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.windDirectionIcon.transform = CGAffineTransformRotate(self.windDirectionIcon.transform, _gradus * (M_PI/360));
    [UIView commitAnimations];
    
}


@end
