//
//  ShareManager.m
//  JmrbNews
//
//  Created by swift on 15/1/9.
//
//

#import "ShareManager.h"
#import <MagicalRecord/MagicalRecord.h>
#import "InterfaceHUDManager.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboSDK.h"
#import <UShareUI/UShareUI.h>

@interface ShareManager ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, strong) id insetImage;
@property (nonatomic, strong) id contentImage;

@end

@implementation ShareManager

DEF_SINGLETON(ShareManager);

#pragma mark - custom methods

- (void)shareWithContent:(NSString *)content presentedController:(UIViewController *)presentedController completion:(void (^)(UMSocialShareResponse *, NSError *))completion
{
    [self shareWithContent:content
                     title:nil
                       url:nil
                insetImage:nil
              contentImage:nil
       presentedController:presentedController
                completion:completion];
}

- (void)shareWithContent:(NSString *)content title:(NSString *)title url:(NSString *)urlStr insetImage:(id)insetImage contentImage:(id)contentImage presentedController:(UIViewController *)presentedController completion:(void (^) (UMSocialShareResponse *result, NSError *error))completion
{
    self.title = title;
    self.content = content;
    self.urlStr = urlStr;
    self.insetImage = insetImage;
    self.contentImage = contentImage;
    
    NSMutableArray *types = [NSMutableArray arrayWithObject:@(UMSocialPlatformType_Email)];
    if ([WeiboSDK isWeiboAppInstalled]) {
        [types insertObject:@(UMSocialPlatformType_Sina) atIndex:0];
    }
    if ([QQApiInterface isQQInstalled]) {
        [types insertObject:@(UMSocialPlatformType_Qzone) atIndex:0];
        [types insertObject:@(UMSocialPlatformType_QQ) atIndex:0];
    }
    if ([WXApi isWXAppInstalled]) {
        [types insertObject:@(UMSocialPlatformType_WechatTimeLine) atIndex:0];
        [types insertObject:@(UMSocialPlatformType_WechatSession) atIndex:0];
    }
    [UMSocialUIManager setPreDefinePlatforms:types];
    
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    
    WEAKSELF
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [weakSelf shareWithPlatformType:platformType
                    presentedController:presentedController
                             completion:completion];
    }];
}

- (void)shareWithPlatformType:(UMSocialPlatformType)platformType presentedController:(UIViewController *)presentedController completion:(void (^) (UMSocialShareResponse *result, NSError *error))completion
{
    NSString *title = _title;
    if (![title isValidString]) {
        title = APP_NAME;
    }
    NSString *contentText = _content;
    if (![contentText isValidString]) {
        contentText = LocalizedStr(Share_App_Content); // SHARE_TEXT;
    }
    id insetImage = _insetImage;
    if (!insetImage) {
        insetImage = [UIImage imageNamed:@"home_page_book_delete"];
    }
    id contentImage = _contentImage;
    NSString *targetUrlStr = [_urlStr isValidString] ? _urlStr : @"";
    
    // 配置分享内容
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareObject *shareObject = nil;
    
    if (contentImage) {
        messageObject.text = [contentText stringByAppendingString:targetUrlStr];
        UMShareImageObject *imageObject = [UMShareImageObject shareObjectWithTitle:title
                                                                             descr:nil
                                                                         thumImage:insetImage];
        imageObject.shareImage = contentImage;
        shareObject = imageObject;
    } else if ([targetUrlStr isValidString]) {
        messageObject.text = contentText;
        UMShareWebpageObject *webpageObject = [UMShareWebpageObject shareObjectWithTitle:title
                                                                                   descr:nil
                                                                               thumImage:insetImage];
        webpageObject.webpageUrl = targetUrlStr;
        shareObject = webpageObject;
    } else {
        messageObject.text = contentText;
    }
    messageObject.shareObject = shareObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType
                                        messageObject:messageObject
                                currentViewController:presentedController
                                           completion:^(id result, NSError *error) {
        if (completion) {
           if (!error && [result isKindOfClass:[UMSocialShareResponse class]]) {
               completion(result, nil);
           } else {
               NSError *err = error ? error : [NSError errorWithDomain:@"UM_Share_Error_Domain"
                                                                  code:1400
                                                              userInfo:@{NSLocalizedDescriptionKey: @"友盟分享错误"}];
               completion(nil, err);
           }
        }
    }];
}

- (void)thirdPartyLoginWithSnsName:(UMSocialPlatformType)platformType presentingController:(UIViewController *)presentingController completion:(void (^)(UMSocialUserInfoResponse *, NSError *))completion
{
    [[UMSocialManager defaultManager] cancelAuthWithPlatform:platformType completion:^(id result, NSError *error) {
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:presentingController completion:^(id result, NSError *error) {
            if (completion) {
                if (!error && [result isKindOfClass:[UMSocialUserInfoResponse class]]) {
                    completion(result, nil);
                } else {
                    NSError *err = error ? error : [NSError errorWithDomain:@"UM_Auth_Error_Domain"
                                                                       code:1401
                                                                   userInfo:@{NSLocalizedDescriptionKey: @"友盟获取第三方平台信息错误"}];
                    completion(nil, err);
                }
            }
        }];
    }];
}

@end
