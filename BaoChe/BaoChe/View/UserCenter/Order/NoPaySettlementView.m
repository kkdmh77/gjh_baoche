//
//  SettlementView.m
//  BaoChe
//
//  Created by 龚 俊慧 on 15/1/4.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "NoPaySettlementView.h"
#import "NSMutableAttributedString+NimbusAttributedLabel.h"

@interface NoPaySettlementView ()
{
    
}

@property (weak, nonatomic) IBOutlet UIButton *cancelOrderBtn;
@property (weak, nonatomic) IBOutlet UIButton *settlementBtn;

@property (weak, nonatomic) IBOutlet UILabel *orderAlreadyCancelLabel;

@end

@implementation NoPaySettlementView

- (void)awakeFromNib
{
    [self setup];
}

#pragma mark - custom methods

- (void)configureViewsProperties
{
    [self addLineWithPosition:ViewDrawLinePostionType_Top
                    lineColor:CellSeparatorColor
                    lineWidth:LineWidth];
    
    _cancelOrderBtn.backgroundColor = Common_GrayColor;
    _settlementBtn.backgroundColor = Common_ThemeColor;
    
    _orderAlreadyCancelLabel.backgroundColor = Common_GrayColor;
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
    
    self.type = ViewType_OrderNoPay;
}

- (IBAction)clickSettlementBtn:(UIButton *)sender
{
    if (_operationHandle)
    {
        if (sender == _settlementBtn)
        {
           _operationHandle(self, NoPaySettlementViewOperationType_Settlement, sender);
        }
        else if (sender == _cancelOrderBtn)
        {
            _operationHandle(self, NoPaySettlementViewOperationType_CancelOrder, sender);
        }
    }
}

- (void)setType:(ViewType)type
{
    if (type == ViewType_OrderNoPay)
    {
        _cancelOrderBtn.hidden = NO;
        _settlementBtn.hidden = NO;
        
        _orderAlreadyCancelLabel.hidden = YES;
    }
    else
    {
        _cancelOrderBtn.hidden = YES;
        _settlementBtn.hidden = YES;
        
        _orderAlreadyCancelLabel.hidden = NO;
    }
}

@end
