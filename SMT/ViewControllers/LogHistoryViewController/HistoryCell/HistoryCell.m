//
//  HistoryCell.m
//  SMT
//
//  Created by Mac on 5/29/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "HistoryCell.h"


@interface HistoryCell ()

@property (strong, nonatomic) IBOutlet UILabel *lbName;

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

- (void) setCellFromSpecies:(NSString *)specie_id
{
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        
        Species * specie = [[DataLoader instance] getSpecieWithId:[specie_id intValue]];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            if(![DataLoader instance].isCorrectRezult) {
                NSLog(@"Error download log history");
            } else {
                
                self.lbName.text = specie.name;
            }
        });
    });
}

@end
