//
//  ShareManager.m
//  JmrbNews
//
//  Created by swift on 15/1/9.
//
//

#import "ShareManager.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDK/ISSShareViewDelegate.h>
#import <ShareSDK/ISSViewDelegate.h>

@interface ShareManager () <ISSShareViewDelegate, ISSViewDelegate>

@end

@implementation ShareManager

DEF_SINGLETON(ShareManager);

#pragma mark - custom methods

- (void)shareNewsWithContent:(NSString *)content NewsId:(NSInteger)newsId imageUrlStr:(NSString *)urlStr title:(NSString *)title showCollectBtn:(BOOL)showCollect sender:(id)sender
{
    /*
     // 定义菜单分享列表
     NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeTwitter, ShareTypeFacebook, ShareTypeSinaWeibo, ShareTypeTencentWeibo, ShareTypeRenren, ShareTypeKaixin, ShareTypeSohuWeibo, ShareType163Weibo, nil];
     */
    
    // 创建分享内容
    id<ISSContent> publishContent = [ShareSDK content:[content isAbsoluteValid] ? content : kNewsShareUrlStr
                                       defaultContent:@""
                                                image:nil
                                                title:@"分享"
                                                  url:@"http://www.mob.com"
                                          description:NSLocalizedString(@"TEXT_TEST_MSG", @"这是一条测试信息")
                                            mediaType:SSPublishContentMediaTypeNews];
    // 创建容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    /*
     id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
     allowCallback:YES
     authViewStyle:SSAuthViewStyleFullScreenPopup
     viewDelegate:self
     authManagerViewDelegate:self];
     // 在授权页面中添加关注官方微博
     [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
     [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
     SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
     [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
     SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
     nil]];
     */
    
    /*
     id<ISSShareOptions> shareOptions = [ShareSDK simpleShareOptionsWithTitle:NSLocalizedString(@"TEXT_SHARE_TITLE", @"内容分享")
     shareViewDelegate:self];
     */
    
    //自定义菜单项
    id<ISSShareActionSheetItem> collectItem = [ShareSDK shareActionSheetItemWithTitle:@"收藏"
                                                                                 icon:[UIImage imageNamed:@"gerenzhongxing_normal"]
                                                                         clickHandler:^{
                                                                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TEXT_TIPS", @"提示")
                                                                                                                                 message:NSLocalizedString(@"TEXT_CUSTOM_ITEM_1_CLICK", @"自定义项1被点击了!")
                                                                                                                                delegate:nil
                                                                                                                       cancelButtonTitle:NSLocalizedString(@"TEXT_OK", @"确定")
                                                                                                                       otherButtonTitles:nil];
                                                                             [alertView show];
                                                                         }];
    
    NSArray *shareList = nil;
    if (showCollect)
    {
        shareList = [ShareSDK customShareListWithType:
                     collectItem,
                     SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                     SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                     SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                     SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                     SHARE_TYPE_NUMBER(ShareTypeQQ),
                     SHARE_TYPE_NUMBER(ShareTypeQQSpace),
                     nil];
    }
    else
    {
        shareList = [ShareSDK customShareListWithType:
                     SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                     SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                     SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                     SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                     SHARE_TYPE_NUMBER(ShareTypeQQ),
                     SHARE_TYPE_NUMBER(ShareTypeQQSpace),
                     nil];
    }
    
    //显示分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:[ShareSDK defaultShareOptionsWithTitle:@"分享这条新闻"
                                                          oneKeyShareList:nil
                                                           qqButtonHidden:YES
                                                    wxSessionButtonHidden:YES
                                                   wxTimelineButtonHidden:YES
                                                     showKeyboardOnAppear:NO
                                                        shareViewDelegate:self
                                                      friendsViewDelegate:self
                                                    picViewerViewDelegate:self]
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSPublishContentStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功"));
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
}

#pragma mark - ISSShareViewDelegate methods

- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType
{
    // 修改分享编辑框的标题栏颜色
    if (IOS7)
    {
        viewController.navigationController.navigationBar.barTintColor = Common_BlueColor;
    }
    else
    {
        viewController.navigationController.navigationBar.tintColor = Common_BlueColor;
    }
}

@end
