//
//  PassengersCell.m
//  BaoChe
//
//  Created by 龚 俊慧 on 14/12/20.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import "PassengersCell.h"

@interface PassengersCell ()

@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *IDCardLabel;
@property (weak, nonatomic) IBOutlet UIButton *operationBtn;

@end

@implementation PassengersCell

static CGFloat defaultCellHeight = 0;

- (void)awakeFromNib
{
    [self setup];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureViewsProperties
{
    _contactLabel.textColor = Common_BlackColor;
    _IDCardLabel.textColor = Common_GrayColor;
    
    // 分割线
    [self.contentView addLineWithPosition:ViewDrawLinePostionType_Bottom
                                lineColor:CellSeparatorColor
                                lineWidth:LineWidth];
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
    
    self.btnType = OperationButType_Delete;
}

- (void)setBtnType:(OperationButType)btnType
{
    _btnType = btnType;
    
    UIColor *BGColor = nil;
    NSString *titleStr = nil;
    UIColor *titleColor = nil;
    UIImage *image = nil;
    CGFloat width = 0;
    
    _operationBtn.hidden = NO;
    
    if (btnType == OperationButType_NoOperation)
    {
        _operationBtn.hidden = YES;
        
        return;
    }
    else if (btnType == OperationButType_Delete)
    {
        _operationBtn.userInteractionEnabled = YES;
        
        BGColor = [UIColor clearColor];
        titleStr = nil;
        titleColor = nil;
        image = [UIImage imageNamed:@"shanchu"];
        width = 30;
    }
    else if (btnType == OperationButType_DetailOrder_ToRefundTicket)
    {
        _operationBtn.userInteractionEnabled = YES;
        
        BGColor = Common_LiteBlueColor;
        titleStr = @"退票";
        titleColor = [UIColor whiteColor];
        image = nil;
        width = 65;
    }
    else if (btnType == OperationButType_DetailOrder_DoingRefundTicket)
    {
        _operationBtn.userInteractionEnabled = NO;
        
        BGColor = [UIColor lightGrayColor];
        titleStr = @"退票中";
        titleColor = [UIColor whiteColor];
        image = nil;
        width = 65;
    }
    else if (btnType == OperationButType_DetailOrder_AlreadyRefundTicket)
    {
        _operationBtn.userInteractionEnabled = NO;
        
        BGColor = [UIColor lightGrayColor];
        titleStr = @"已退票";
        titleColor = [UIColor whiteColor];
        image = nil;
        width = 65;
    }
    else if (btnType == OperationButType_DetailOrder_GetTicket)
    {
        _operationBtn.userInteractionEnabled = NO;
        
        BGColor = [UIColor lightGrayColor];
        titleStr = @"已出票";
        titleColor = [UIColor whiteColor];
        image = nil;
        width = 65;
    }
    else if (btnType == OperationButType_DetailOrder_AlreadyMiss)
    {
        _operationBtn.userInteractionEnabled = NO;
        
        BGColor = [UIColor lightGrayColor];
        titleStr = @"已错过";
        titleColor = [UIColor whiteColor];
        image = nil;
        width = 65;
    }
    
    [_operationBtn setBackgroundImage:image forState:UIControlStateNormal];
    [_operationBtn setTitleColor:titleColor forState:UIControlStateNormal];
    _operationBtn.titleLabel.font = SP15Font;
    [_operationBtn setTitle:titleStr forState:UIControlStateNormal];
    _operationBtn.backgroundColor = BGColor;
    [_operationBtn setRadius:4];
    
    [_operationBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
    }];
}

- (IBAction)clickOperationBtn:(UIButton *)sender
{
    if (_operationHandle) _operationHandle(self, _btnType, sender);
}

////////////////////////////////////////////////////////////////////////////////

+ (CGFloat)getCellHeight
{
    if (0 == defaultCellHeight)
    {
        PassengersCell *cell = [self loadFromNib];
        defaultCellHeight= cell.boundsHeight    ;
    }
    return defaultCellHeight;
}

- (void)loadCellShowDataWithItemEntity:(PassengersEntity *)entity
{
    _contactLabel.text = entity.nameStr;
    _IDCardLabel.text = entity.mobilePhoneStr;
}

@end
