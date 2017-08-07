//
//  CommentSendController.m
//  Sephome
//
//  Created by swift on 14/12/9.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import "CommentSendController.h"
#import "PopupController.h"
#import <NerdyUI.h>
#import "LanguagesManager.h"
#import "HUDManager.h"

static const CGFloat btnWidthAndHeight = 35.0;
static const CGFloat viewBetweenSpaceValue = 10.0;

@interface CommentSendController () <PopupControllerDelegate, HPGrowingTextViewDelegate>
{
    SendCommentCompleteHandle   _completeHandle;
    PopupController             *_commentInputShowPop;
    HPGrowingTextView           *_inputTV;
    UIView                      *_containerView;
}

@property (nonatomic, copy) SendCommentCompleteHandle completeHandle;

@end

@implementation CommentSendController

DEF_SINGLETON(CommentSendController);

- (void)showCommentInputViewWithCompleteHandle:(SendCommentCompleteHandle)handle
{
    if (!_commentInputShowPop)
    {
        UIView *containerView = InsertView(nil, CGRectMake(0, 0, IPHONE_WIDTH, 0));
        containerView.backgroundColor = HEXCOLOR(0XECECEC);
        
        UIButton *cancelBtn = InsertImageButton(containerView,
                                                CGRectZero,
                                                1000,
                                                [UIImage imageWithColor:[UIColor yellowColor] size:CGSizeMake(1, 1)],
                                                nil,
                                                self,
                                                @selector(clickCancelBtn:));
        cancelBtn.makeCons(^{
            make.size.equal.constants(btnWidthAndHeight, btnWidthAndHeight);
            make.left.top.equal.superview.constants(viewBetweenSpaceValue);
        });
        
        UIButton *sendBtn = InsertImageButton(containerView,
                                              CGRectZero,
                                              1002,
                                              [UIImage imageWithColor:[UIColor redColor] size:CGSizeMake(1, 1)],
                                              nil,
                                              self,
                                              @selector(clickSendBtn:));
        sendBtn.makeCons(^{
            make.size.top.equal.view(cancelBtn);
            make.right.equal.superview.constants(-viewBetweenSpaceValue);
        });

        UILabel *titleLabel = InsertLabel(containerView,
                                          CGRectZero,
                                          NSTextAlignmentCenter,
                                          @"写评论",
                                          SP15Font,
                                          [UIColor blackColor],
                                          NO);
        titleLabel.makeCons(^{
            make.top.height.equal.view(cancelBtn);
            make.left.equal.view(cancelBtn).right.constants(viewBetweenSpaceValue);
            make.right.equal.view(sendBtn).left.constants(-viewBetweenSpaceValue);
        });
        
        // 输入控件
        HPGrowingTextView *inputTV = [[HPGrowingTextView alloc] initWithFrame:CGRectZero];
        // UITextView *inputTV = [[UITextView alloc] init];
        inputTV.delegate = self;
        inputTV.font = kCustomFont_Size(16);
        inputTV.textColor = Common_BlackColor;
        inputTV.maxNumberOfLines = 4;
        inputTV.minNumberOfLines = 1;
        inputTV.placeholder = @"请输入评论";
        [inputTV addBorderToViewWitBorderColor:[UIColor lightGrayColor]
                                   borderWidth:ThinLineWidth];
        inputTV.backgroundColor = [UIColor whiteColor];
        [containerView addSubview:inputTV];
        _inputTV = inputTV;
        
        inputTV.makeCons(^{
            make.left.right.bottom.superview.constants(viewBetweenSpaceValue, -viewBetweenSpaceValue, -viewBetweenSpaceValue);
            make.top.equal.view(cancelBtn).bottom.constants(viewBetweenSpaceValue);
        });
        
        _containerView = containerView;
        _commentInputShowPop = [[PopupController alloc] initWithContentView:_containerView];
        _commentInputShowPop.delegate = self;
        _commentInputShowPop.behavior = PopupBehavior_MessageBox;
    }
    self.completeHandle = handle;
    
    // 设置展示时的默认高度
    NSString *tempStr = @"设置inputTv初始高度的临时字符串";
    if (![_inputTV.text isValidString]) { // 没有输入文字时
        _inputTV.text = tempStr;
    } else { // 上一次有输入文字时
        NSString *preInputText = _inputTV.text;
        _inputTV.text = nil;
        _inputTV.text = preInputText;
    }
    
    CGFloat defaultHeight = [_containerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    _containerView.height = defaultHeight + _inputTV.height;
    
    // 如果没有输入文字，则计算完一行的默认高度后清空文字
    if ([_inputTV.text isEqualToString:tempStr]) {
        _inputTV.text = nil;
    }
    
    if (!_commentInputShowPop.contentView) {
        _commentInputShowPop.contentView = _containerView;
    }
    
    _completeHandle = [handle copy];
    
    [_commentInputShowPop showInView:[UIApplication sharedApplication].keyWindow
                        animatedType:PopAnimatedType_Input];
}

- (void)clickSendBtn:(UIButton *)sender
{
    if (![_inputTV.text isValidString]) {
        [HUDManager showAutoHideHUDWithToShowStr:@"发送的内容不能为空"
                                         HUDMode:MBProgressHUDModeText];
    } else {
        [_commentInputShowPop hide];

        [self performActionHandleWithType:SendCommentActionTypeToSend];
    }
}

- (void)clickCancelBtn:(UIButton *)sender
{
    [_commentInputShowPop hide];
    
    [self performActionHandleWithType:SendCommentActionTypeCancel];
}

- (void)performActionHandleWithType:(SendCommentActionType)type {
    if (_completeHandle) {
        _completeHandle(type, _inputTV.text);
    }
}

#pragma mark - HPGrowingTextViewDelegate methods

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height {
    CGFloat difHeight = height - _inputTV.height;
    _containerView.top -= difHeight;
    _containerView.height += difHeight;
}

/*
#pragma mark - PopupControllerDelegate methods

- (void) PopupControllerDidHidden:(PopupController *)aController {
    [self performActionHandleWithType:SendCommentActionTypeCancel];
}
*/

@end
