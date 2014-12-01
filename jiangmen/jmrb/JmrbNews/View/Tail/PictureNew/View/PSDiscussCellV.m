//
//  MPDiscussCellV.m
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PSDiscussCellV.h"

@implementation PSDiscussCellV
@synthesize height;

- (void)dealloc {
    [_lblAuther release];
    [_contentTextView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _lblAuther = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 25)];
        [_lblAuther setFont:[UIFont boldSystemFontOfSize:17]];
        [_lblAuther setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_lblAuther];
        
        _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 30, frame.size.width-20, 10)];
        [_contentTextView setBackgroundColor:[UIColor clearColor]];
        [_contentTextView setEditable:NO];
        [self addSubview:_contentTextView];
    }
    return self;
}

- (void)setText:(NSString *)auther Text:(NSString *)content {
    [_lblAuther setText:auther];
    [_contentTextView setText:content];
    CGSize size = _contentTextView.contentSize;
    [_contentTextView setFrame:CGRectMake(10, 30, size.width, size.height)];
    self.height = size.height+_contentTextView.frame.origin.y;
}

@end









