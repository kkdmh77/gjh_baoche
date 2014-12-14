//
//  AllBusList_HeaderView.m
//  BaoChe
//
//  Created by swift on 14/12/14.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import "AllBusList_HeaderView.h"

@interface AllBusList_HeaderView ()

@property (weak, nonatomic) IBOutlet UIButton *preDayBtn;
@property (weak, nonatomic) IBOutlet UIButton *curShowDayBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextDayBtn;

@end

@implementation AllBusList_HeaderView

- (void)awakeFromNib
{
    [self setup];
}

#pragma mark - custom methods

- (void)configureViewsProperties
{
    for (UIView *view in self.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)view;
            
            btn.titleLabel.font = SP14Font;
            [btn setTitleColor:Common_GrayColor forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(clickOperationBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    // 分割线
    [self addLineWithPosition:ViewDrawLinePostionType_Bottom
                                lineColor:CellSeparatorColor
                                lineWidth:LineWidth];
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

- (void)clickOperationBtn:(UIButton *)sender
{
    AllBusListHeaderViewOperationType type;
    
    if (sender == _preDayBtn)
    {
        type = AllBusListHeaderViewOperationType_PreDay;
    }
    else if (sender == _curShowDayBtn)
    {
        type = AllBusListHeaderViewOperationType_CurShowDay;
    }
    else
    {
        type = AllBusListHeaderViewOperationType_NextDay;
    }
    
    if (_operationType) _operationType(self, type);
}

- (void)setCurShowDateBtnTitle:(NSString *)title
{
    [_curShowDayBtn setTitle:title forState:UIControlStateNormal];
}

- (NSString *)curShowDateBtnTitle
{
    return [_curShowDayBtn titleForState:UIControlStateNormal];
}

@end
