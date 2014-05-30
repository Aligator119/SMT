//
//  ReportsViewController.m
//  SMT
//
//  Created by Mac on 5/29/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "ReportsViewController.h"

@interface ReportsViewController ()

@property (weak, nonatomic) IBOutlet SMTGraphView *graphView;
@property (strong, nonatomic) NSMutableDictionary *valuesDict;

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
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd-yyyy hh:mm a"];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    arr = [NSMutableArray arrayWithObjects:[formatter dateFromString:@"01-02-2014 11:12 AM"],[formatter dateFromString:@"02-03-2014 02:12 AM"],[formatter dateFromString:@"02-09-2014 05:12 AM"],[formatter dateFromString:@"01-14-2014 04:12 AM"],[formatter dateFromString:@"01-18-2014 07:12 AM"],[formatter dateFromString:@"01-22-2014 11:12 AM"],[formatter dateFromString:@"01-24-2014 11:12 AM"],[formatter dateFromString:@"01-25-2014 02:12 AM"],[formatter dateFromString:@"01-26-2014 05:12 AM"],[formatter dateFromString:@"01-27-2014 04:12 AM"],[formatter dateFromString:@"01-27-2014 07:12 AM"],[formatter dateFromString:@"03-29-2014 11:12 AM"], nil];
    
    self.valuesDict = [NSMutableDictionary dictionaryWithObjects:[arr sortedArrayUsingSelector:@selector(compare:)] forKeys:[NSArray arrayWithObjects: @"13", @"5", @"12", @"6", @"7", @"11", @"15", @"16", @"22", @"1", @"11", @"11", nil]];
    [self.graphView buildGraphWithDataFromDictionary:self.valuesDict];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
