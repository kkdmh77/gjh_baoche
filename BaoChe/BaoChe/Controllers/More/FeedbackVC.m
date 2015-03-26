//
//  FeedbackVC.m
//  BaoChe
//
//  Created by swift on 15/3/25.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "FeedbackVC.h"
#import "SZTextView.h"
#import "BaseNetworkViewController+NetRequestManager.h"

@interface FeedbackVC ()

@property (weak, nonatomic) IBOutlet SZTextView *inputTextView;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

@implementation FeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////////////////////////

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:@"意见反馈"];
    [self setup];
}

- (void)setNetworkRequestStatusBlocks
{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (NetUserCenterRequestType_SendFeedback == request.tag)
        {
            [strongSelf showHUDInfoByString:@"反馈成功！"];
            [strongSelf backViewController];
        }
    }];
}

- (void)configureViewsProperties
{
    CGFloat inset = 10.0;
    if ([_inputTextView respondsToSelector:@selector(setTextContainerInset:)])
    {
        _inputTextView.textContainerInset = UIEdgeInsetsMake(inset, inset, inset, inset);
    }
    else
    {
        _inputTextView.contentInset = UIEdgeInsetsMake(inset, inset, inset, inset);
    }
    _inputTextView.placeholder = @"请输入您要反馈的内容";
    _inputTextView.backgroundColor = [UIColor whiteColor];
    [_inputTextView setRadius:3];
    
    _commitBtn.backgroundColor = Common_ThemeColor;
    [_commitBtn setRadius:3];
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

- (IBAction)clickCommitBtn:(id)sender
{
    if ([_inputTextView hasText])
    {
        [self sendRequest:[[self class] getRequestURLStr:NetUserCenterRequestType_SendFeedback]
             parameterDic:@{@"feedbackMessage": _inputTextView.text}
           requestHeaders:[UserInfoModel getRequestHeader_TokenDic]
        requestMethodType:RequestMethodType_POST
               requestTag:NetUserCenterRequestType_SendFeedback];
    }
    else
    {
        [self showHUDInfoByString:@"说点什么吧！"];
    }
}

@end
