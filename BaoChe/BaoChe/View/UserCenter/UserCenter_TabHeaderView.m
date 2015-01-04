//
//  UserCenter_TabHeaderView.m
//  BaoChe
//
//  Created by 龚 俊慧 on 14/12/20.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import "UserCenter_TabHeaderView.h"

@interface UserCenter_TabHeaderView ()

// 登录后相关
@property (weak, nonatomic) IBOutlet UIView *userInfoBGView;
@property (weak, nonatomic) IBOutlet UIButton *userHeaderImageBtn;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobilePhoneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

// 未登录相关
@property (weak, nonatomic) IBOutlet UIView *notLoginBGView;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginAndRegisterBtn;

// 我的订单
@property (weak, nonatomic) IBOutlet UIButton *myOrderBtn;
@property (weak, nonatomic) IBOutlet UILabel *checkOrderDescLabel;

// 待送货
@property (weak, nonatomic) IBOutlet UIButton *noTransportBtn;
@property (weak, nonatomic) IBOutlet UIButton *noTransportDescBtn;
// 送货中
@property (weak, nonatomic) IBOutlet UIButton *transportingBtn;
@property (weak, nonatomic) IBOutlet UIButton *transportingDescBtn;
// 已完成
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UIButton *doneDescBtn;

@end

@implementation UserCenter_TabHeaderView

static CGFloat defaultViewHeight = 0;

- (void)awakeFromNib
{
    [self setup];
}

- (void)configureViewsProperties
{
    UIColor *blackColor = Common_BlackColor;
    UIColor *grayColor = Common_GrayColor;
    
    // 分割线
    [self addLineWithPosition:ViewDrawLinePostionType_Bottom
                    lineColor:CellSeparatorColor
                    lineWidth:LineWidth];
    [_userInfoBGView addLineWithPosition:ViewDrawLinePostionType_Bottom
                           lineColor:CellSeparatorColor
                           lineWidth:LineWidth];
    [_myOrderBtn addLineWithPosition:ViewDrawLinePostionType_Bottom
                    lineColor:CellSeparatorColor
                    lineWidth:LineWidth];
    
    _userInfoBGView.backgroundColor = HEXCOLOR(0XF5FAFD);
    _userNameLabel.textColor = blackColor;
    _mobilePhoneNumLabel.textColor = Common_ThemeColor;
    _addressLabel.textColor = HEXCOLOR(0X4F5256);
    
    _notLoginBGView.backgroundColor = HEXCOLOR(0XF5FAFD);
    _notLoginBGView.alpha = 1;
    [_loginAndRegisterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _loginAndRegisterBtn.backgroundColor = Common_ThemeColor;
    [_loginAndRegisterBtn setRadius:4];
    
    _myOrderBtn.backgroundColor = [UIColor whiteColor];
    [_myOrderBtn setTitleColor:blackColor forState:UIControlStateNormal];
    _checkOrderDescLabel.textColor = grayColor;
    
    [_noTransportDescBtn setTitleColor:grayColor forState:UIControlStateNormal];
    [_transportingDescBtn setTitleColor:grayColor forState:UIControlStateNormal];
    [_doneDescBtn setTitleColor:grayColor forState:UIControlStateNormal];
    
    // 约束
    CGFloat btnBetweenSpace = (IPHONE_WIDTH - _noTransportBtn.boundsWidth * 3 - 30 * 2) / 2;
    [_noTransportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_transportingBtn.mas_left).with.offset(@(-btnBetweenSpace));
    }];
    [_transportingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_doneBtn.mas_left).with.offset(@(-btnBetweenSpace));
    }];
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
    
    self.viewType = UserCenterHeaderViewType_NotLogin;
}

- (void)setViewType:(UserCenterHeaderViewType)viewType
{
    if (UserCenterHeaderViewType_Logined == viewType)
    {
        _userInfoBGView.hidden = NO;
        _notLoginBGView.hidden = YES;
    }
    else
    {
        _userInfoBGView.hidden = YES;
        _notLoginBGView.hidden = NO;
    }
}

- (IBAction)clickUserHeaderImageBtn:(UIButton *)sender
{
    if (_operationHandle) _operationHandle(self, UserCenterTabHeaderViewOperationType_UserHeaderImageBtn, sender);
}

- (IBAction)clickCheckOrderBtn:(UIButton *)sender
{
    if (_operationHandle) _operationHandle(self, UserCenterTabHeaderViewOperationType_CheckAllOrder, sender);
}

- (IBAction)clickLoginAndRegisterBtn:(UIButton *)sender
{
    if (_operationHandle) _operationHandle(self, UserCenterTabHeaderViewOperationType_LoginAndRegister, sender);
}

///////////////////////////////////////////////////////////////////

+ (CGFloat)getViewHeight
{
    return 155;
    
    /*
    if (0 == defaultViewHeight)
    {
        UserCenter_TabHeaderView *view = [self loadFromNib];
        defaultViewHeight= view.boundsHeight    ;
    }
    return defaultViewHeight;
     */
}
@end

#pragma mark - //////////////////////////////////////////////////////////

@interface UserCenter_TabSectionHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *titileLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@end

@implementation UserCenter_TabSectionHeaderView

- (void)awakeFromNib
{
    [self setup];
}

- (void)configureViewsProperties
{
    _titileLabel.textColor = Common_BlackColor;
    [_addBtn setTitleColor:Common_ThemeColor forState:UIControlStateNormal];
    
    // 分割线
    [self addLineWithPosition:ViewDrawLinePostionType_Bottom
                                lineColor:CellSeparatorColor
                                lineWidth:LineWidth];
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
    
    self.canOperation = YES;
}

- (void)setCanOperation:(BOOL)canOperation
{
    _canOperation = canOperation;
    
    if (_canOperation)
    {
        self.userInteractionEnabled = YES;
        _addBtn.hidden = NO;
        _arrowImageView.hidden = NO;
    }
    else
    {
        self.userInteractionEnabled = NO;
        _addBtn.hidden = YES;
        _arrowImageView.hidden = YES;
    }
}

- (void)setTitleString:(NSString *)title
{
    _titileLabel.text = title;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    [UIView animateWithDuration:0.25
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         if (self.selected)
                         {
                             _arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
                         }
                         else
                         {
                             _arrowImageView.transform = CGAffineTransformIdentity;
                         }
    }];
}

@end
