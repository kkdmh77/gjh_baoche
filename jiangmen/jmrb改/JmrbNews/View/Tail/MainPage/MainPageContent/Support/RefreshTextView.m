//
//  RefreshTextView.m
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-4-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RefreshTextView.h"

@interface RefreshTextView ()

@end

@implementation RefreshTextView
@synthesize lblText,imageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.lblText setAdjustsFontSizeToFitWidth:YES];
    [self.imageView setTransform:CGAffineTransformMakeRotation(M_PI)];
}

@end
