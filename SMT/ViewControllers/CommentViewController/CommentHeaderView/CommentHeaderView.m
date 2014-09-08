//
//  CommentHeaderView.m
//  SMT
//
//  Created by Admin on 9/4/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "CommentHeaderView.h"

@implementation CommentHeaderView

-(id)init
{
    if (self = [super init]){
        NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"CommentHeaderView" owner:self options:nil];
        UIView *mainView = [subviewArray objectAtIndex:0];
        [self addSubview:mainView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]){
        NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"CommentHeaderView" owner:self options:nil];
        UIView *mainView = [subviewArray objectAtIndex:0];
        mainView.frame = self.frame;
        [self addSubview:mainView];
    }
    return self;
}

@end
