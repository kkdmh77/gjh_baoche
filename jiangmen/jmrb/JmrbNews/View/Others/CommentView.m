//
//  CommentView.m
//  JmrbNews
//
//  Created by swift on 14/12/21.
//
//

#import "CommentView.h"

@interface CommentView ()

@property (weak, nonatomic) IBOutlet UILabel *inputActionLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@end

@implementation CommentView

- (void)awakeFromNib
{
    [self setup];
}

////////////////////////////////////////////////////////////////////////////////

- (void)configureViewsProperties
{
    [_inputActionLabel addBorderToViewWitBorderColor:CellSeparatorColor borderWidth:LineWidth];
    [_inputActionLabel setRadius:4];
    [_inputActionLabel addTarget:self action:@selector(operationInputAction:)];
    
    [_rightBtn addBorderToViewWitBorderColor:CellSeparatorColor borderWidth:LineWidth];
    [_rightBtn setRadius:4];
    [_rightBtn setTitleColor:Common_BlueColor forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    // 分割线
    [self addLineWithPosition:ViewDrawLinePostionType_Top lineColor:CellSeparatorColor lineWidth:LineWidth];
    [self addLineWithPosition:ViewDrawLinePostionType_Bottom lineColor:CellSeparatorColor lineWidth:LineWidth];
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

- (void)setRightBtnTitle:(NSString *)title
{
    [_rightBtn setTitle:title forState:UIControlStateNormal];
    
    [_rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@([title stringSizeWithFont:_rightBtn.titleLabel.font].width + 30));
    }];
}

- (void)operationInputAction:(UITapGestureRecognizer *)gesture
{
    if (_operationHandle) _operationHandle(self, CommentViewOperationType_Input);
}

- (void)clickRightBtn:(UIButton *)sender
{
    if (_operationHandle) _operationHandle(self, CommentViewOperationType_RightBtn);
}

@end
