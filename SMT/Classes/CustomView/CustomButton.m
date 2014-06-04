#import "CustomButton.h"

@interface CustomButton ()
{
    NSMutableArray * inputArray;
    NSString * selectItem;
    Species * selectSpecie;
    NSString * questionID;
}

- (void)click:(id)sender;
@end


@implementation CustomButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        selectItem = @"";
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        selectItem = @"";
    }
    return self;
}



- (void)removeSelectIthem
{   if (selectSpecie)
    [inputArray removeObject:selectSpecie];
}

- (void) addSpecie:(Species *)spec
{
    [inputArray addObject:spec];
}

- (void) setInputArray:(NSArray *)array
{
    inputArray = [[NSMutableArray alloc]initWithArray:array];
    //[self setTitle:@"Nother Pike" forState:UIControlStateNormal];
}
- (void) setWithInputDictionary:(NSDictionary *)dict
{
    questionID = [dict objectForKey:@"id"];
    [self setTitle:[dict objectForKey:@"question"] forState:UIControlStateNormal];
    inputArray = [[NSMutableArray alloc]init];
    for (NSDictionary * obj in [dict objectForKey:@"options"]) {
        [inputArray addObject:[obj objectForKey:@"myoption"]];
    }
}


- (NSString *)getQuestion
{
    return questionID;
}

- (NSString *) getSelectedIthem
{
    return selectItem;
}

- (Species *) getSelectedSpecie
{
    return selectSpecie;
}

- (void) setSelectedIthem:(NSString *)str
{
    if (str) {
    for (NSString * obj in inputArray) {
        if ([obj isEqualToString:str]) {
            selectItem = str;
            [self setTitle:str forState:UIControlStateNormal];
        }
    }
    }
}

- (void) setSelectedSpecies:(Species *)spec
{
    for (Species * obj in inputArray) {
        if ([obj isEqual:spec]) {
            selectSpecie = obj;
            [self setTitle:spec.name forState:UIControlStateNormal];
        }
    }
}

- (void)click:(id)sender
{
    id<ButtonControllerDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(openPickerWithData:andTag:)]) {
        [delegate openPickerWithData:inputArray andTag:self.tag];
    }
}

@end
