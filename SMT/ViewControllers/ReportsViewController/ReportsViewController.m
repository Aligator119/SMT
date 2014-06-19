//
//  ReportsViewController.m
//  SMT
//
//  Created by Mac on 5/29/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "ReportsViewController.h"
#import "ReportsActivity.h"
#import "ReportsHarvestrow.h"

@interface ReportsViewController ()
{
    NSMutableArray *activityLevelData;
    NSMutableArray *harvestedData;
    NSMutableArray *seenData;
    NSMutableArray *dateData;
    
    NSInteger selectedSpeciesId;
    NSInteger selectedSubSpeciesId;
}

@property (weak, nonatomic) IBOutlet SMTGraphView *graphView;
@property (strong, nonatomic) NSMutableDictionary *valuesDict;
@property (nonatomic, weak) IBOutlet UISegmentedControl * dateSegmentControl;
@property (nonatomic, weak) IBOutlet UISegmentedControl *dataSourceSegmentControl;

@end

@implementation ReportsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    selectedSpeciesId = 1;
    selectedSubSpeciesId = 1;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd-yyyy hh:mm a"];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    arr = [NSMutableArray arrayWithObjects:[formatter dateFromString:@"01-02-2014 11:12 AM"],[formatter dateFromString:@"02-03-2014 02:12 AM"],[formatter dateFromString:@"02-09-2014 05:12 AM"],[formatter dateFromString:@"01-14-2014 04:12 AM"],[formatter dateFromString:@"01-18-2014 07:12 AM"],[formatter dateFromString:@"01-22-2014 11:12 AM"],[formatter dateFromString:@"01-24-2014 11:12 AM"],[formatter dateFromString:@"01-25-2014 02:12 AM"],[formatter dateFromString:@"01-26-2014 05:12 AM"],[formatter dateFromString:@"01-27-2014 04:12 AM"],[formatter dateFromString:@"01-27-2014 07:12 AM"],[formatter dateFromString:@"03-29-2014 11:12 AM"], nil];
    
    self.valuesDict = [NSMutableDictionary dictionaryWithObjects:[arr sortedArrayUsingSelector:@selector(compare:)] forKeys:[NSArray arrayWithObjects: @"13", @"5", @"12", @"6", @"7", @"11", @"15", @"16", @"22", @"1", @"11", @"11", nil]];
    
    NSDictionary *attributes1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor], UITextAttributeTextColor,
                                nil];
    [self.dateSegmentControl setTitleTextAttributes:attributes1 forState:UIControlStateNormal];
    NSDictionary *highlightedAttributes1 = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    [self.dateSegmentControl setTitleTextAttributes:highlightedAttributes1 forState:UIControlStateHighlighted];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor], UITextAttributeTextColor,
                                nil];
    [self.dataSourceSegmentControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    [self.dataSourceSegmentControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    
}

- (void) viewDidLayoutSubviews{
    [self.graphView buildGraphWithDataFromDictionary:self.valuesDict];
}


- (IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) createDataSource{
    
    dateData = [NSMutableArray new];
    activityLevelData = [NSMutableArray new];
    harvestedData = [NSMutableArray new];
    seenData = [NSMutableArray new];
    
    for (ReportsActivity * act in self.activitiesArray){
        if (act.species_id == selectedSpeciesId){
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSDate * date = [formatter dateFromString:act.date];
            [dateData addObject:date];
            NSArray *harvArr = [NSArray arrayWithArray:act.harvestrows];
            for (ReportsHarvestrow *harv in harvArr){
                if (harv.subspecies_id == selectedSubSpeciesId){
                    [activityLevelData addObject:[NSString stringWithFormat:@"%d", harv.activityLevel]];
                    [harvestedData addObject:[NSString stringWithFormat:@"%d", harv.harvested]];
                    [seenData addObject:[NSString stringWithFormat:@"%d", harv.seen]];
                }
            }
        }
    }
}

- (IBAction)DateSegmentDidChangeState:(id)sender{
    NSInteger selectedIndex = self.dateSegmentControl.selectedSegmentIndex;
    
    switch (selectedIndex) {
        case 0:
            [self.graphView day];
            break;
            
        case 1:
            [self.graphView week];
            break;
            
        case 2:
            [self.graphView month];
            break;
            
        default:
            break;
    }
}

-(IBAction) GraphTypeSegmentDidChange:(id)sender{
    NSInteger selectedIndex = self.dateSegmentControl.selectedSegmentIndex;
    
    switch (selectedIndex) {
        case 0:
            
            break;
            
        case 1:
            
            break;
            
        case 2:
            
            break;
            
        default:
            break;
    }
}

-(IBAction) selectSpecies:(id)sender{
    
}

-(IBAction) selectSubSpecies:(id)sender{
    
}

@end
