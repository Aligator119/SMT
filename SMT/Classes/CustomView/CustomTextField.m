#import "CustomTextField.h"

@interface CustomTextField ()
{
    NSString * questionID;
}
@end


@implementation CustomTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.font = [UIFont systemFontOfSize:15.0f];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        self.font = [UIFont systemFontOfSize:15.0f];
    }
    return self;
}

- (void) setWithInputDictionary:(NSDictionary *)dict
{
    questionID = [dict objectForKey:@"id"];
    [self setPlaceholder:[@"Enterd " stringByAppendingString:[dict objectForKey:@"question"]]];
}

- (NSString *) getQuestionID
{
    return questionID;
}

- (NSString *) getText
{
    return self.text;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
