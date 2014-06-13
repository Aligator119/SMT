//
//  HistoryCell.m
//  SMT
//
//  Created by Mac on 5/29/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "HistoryCell.h"


@interface HistoryCell ()
{
    NSData * data;
}

@property (strong, nonatomic) IBOutlet UILabel *lbName;
@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet UILabel *lbLocation;
@property (strong, nonatomic) IBOutlet UILabel *lbDate;

@end


@implementation HistoryCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setCellFromSpecies:(NSDictionary *)specie
{
    self.lbName.text = [[specie objectForKey:@"species"] objectForKey:@"name"];
    NSURL * url = [NSURL URLWithString:[@"http://sportsmantracker.com/" stringByAppendingString:[[specie objectForKey:@"species"] objectForKey:@"thumbnail"]]];
    self.lbLocation.text = [[specie objectForKey:@"location"] objectForKey:@"name"];
    self.lbDate.text = [specie objectForKey:@"logtimestamp"];
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        
        data = [NSData dataWithContentsOfURL:url];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            if(![DataLoader instance].isCorrectRezult) {
                NSLog(@"Error download log history");
            } else {
                
                self.img.image = [UIImage imageWithData:data];
            }
        });
    });
}

@end
