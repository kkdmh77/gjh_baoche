//
//  OrderWriteTabHeaderView.m
//  BaoChe
//
//  Created by 龚 俊慧 on 14/12/22.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import "OrderInfoView.h"

@interface OrderInfoView ()

@end

@implementation OrderInfoView

static CGFloat defaultViewHeight = 0;

- (void)awakeFromNib
{
    [self setup];
}

- (void)configureViewsProperties
{
   
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

+ (CGFloat)getViewHeight
{
    if (0 == defaultViewHeight)
    {
        OrderInfoView *view = [self loadFromNib];
        defaultViewHeight = view.boundsHeight;
    }
    return defaultViewHeight;
}

@end

#pragma mark - OrderContactInfoView -----------------------------

@interface OrderContactInfoView ()

@end

@implementation OrderContactInfoView

static CGFloat defaultContactViewHeight = 0;

- (void)awakeFromNib
{
    [self setup];
}

- (void)configureViewsProperties
{
    
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

+ (CGFloat)getViewHeight
{
    if (0 == defaultContactViewHeight)
    {
        OrderInfoView *view = [self loadFromNib];
        defaultContactViewHeight = view.boundsHeight;
    }
    return defaultContactViewHeight;
}

@end

