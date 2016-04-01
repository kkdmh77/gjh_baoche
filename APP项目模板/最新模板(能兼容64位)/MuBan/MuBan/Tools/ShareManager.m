//
//  ShareManager.m
//  JmrbNews
//
//  Created by swift on 15/1/9.
//
//

#import "ShareManager.h"
#import "CoreData+MagicalRecord.h"
#import "InterfaceHUDManager.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>

@interface ShareManager ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, strong) UIImage *insetImage;
@property (nonatomic, strong) UIImage *contentImage;

@end

@implementation ShareManager

DEF_SINGLETON(ShareManager);

#pragma mark - custom methods

- (void)shareWithContent:(NSString *)content title:(NSString *)title url:(NSString *)urlStr insetImage:(UIImage *)insetImage contentImage:(UIImage *)contentImage presentedController:(UIViewController *)presentedController
{
    self.title = title;
    self.content = content;
    self.urlStr = urlStr;
    self.insetImage = insetImage;
    self.contentImage = contentImage;
    
    NSMutableArray *platformNames = [NSMutableArray arrayWithObjects:UMShareToSina, nil];
    if ([WXApi isWXAppInstalled])
    {
        [platformNames insertObject:UMShareToWechatSession atIndex:0];
        [platformNames insertObject:UMShareToWechatTimeline atIndex:1];
    }
    if ([QQApiInterface isQQInstalled])
    {
        [platformNames addObjectsFromArray:@[UMShareToQQ, UMShareToQzone]];
    }
    
    [UMSocialSnsService presentSnsIconSheetView:presentedController
                                         appKey:kUMengAppKey
                                      shareText:SHARE_TEXT
                                     shareImage:[UIImage imageNamed:@"share_image"]
                                shareToSnsNames:platformNames
                                       delegate:self];
    
}

- (void)thirdPartyLoginWithSnsName:(NSString *)snsName presentingController:(UIViewController *)presentingController loginSuccessedHandler:(void (^)(UMSocialAccountEntity *))loginSuccessedHandler
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
    
    snsPlatform.loginClickHandler(presentingController, [UMSocialControllerService defaultControllerService], YES, ^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsName];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            if (loginSuccessedHandler) {
                loginSuccessedHandler(snsAccount);
            }
        }
    });
}

-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    NSString *title = _title;
    if (![title isAbsoluteValid]) {
        title = @"快快查字典";
    }
    NSString *content = _content;
    if (![content isAbsoluteValid]){
        content = SHARE_TEXT;
    }
    UIImage *insetImage = _insetImage;
    if (!insetImage) {
        insetImage = [UIImage imageNamed:@"share_image"];
    }
    UIImage *contentImage = _contentImage;
    NSString *targetUrlStr = _urlStr;
    
    if (platformName == UMShareToSina) {
        socialData.title = title;
        socialData.shareText = content;
        socialData.shareImage = insetImage;
        
        socialData.extConfig.sinaData.shareText = [content stringByAppendingString:targetUrlStr];
        socialData.extConfig.sinaData.shareImage = contentImage;
    }
    else if (platformName == UMShareToTencent) {
        socialData.title = title;
        socialData.shareText = content;
        socialData.shareImage = insetImage;
        
        socialData.extConfig.tencentData.title = title;
        socialData.extConfig.tencentData.shareText = [content stringByAppendingString:targetUrlStr];
        socialData.extConfig.tencentData.shareImage = contentImage;
    }
    else if (platformName == UMShareToQQ) {
        socialData.title = title;
        socialData.shareText = content;
        socialData.shareImage = insetImage;
        
        socialData.extConfig.qqData.title = title;
        socialData.extConfig.qqData.shareText = content;
        socialData.extConfig.qqData.shareImage = contentImage;
        if (contentImage) {
            socialData.extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
        }
        
        socialData.extConfig.qqData.url = targetUrlStr;
    }
    else if (platformName == UMShareToWechatSession) {
        socialData.title = title;
        socialData.shareText = content;
        socialData.shareImage = insetImage;

        socialData.extConfig.wechatSessionData.title = title;
        socialData.extConfig.wechatSessionData.shareText = content;
        socialData.extConfig.wechatSessionData.shareImage = contentImage;
        if (contentImage) {
            socialData.extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeImage;
        }
        
        socialData.extConfig.wechatSessionData.url = targetUrlStr;
    }
    else if (platformName == UMShareToWechatTimeline) {
        socialData.title = title;
        socialData.shareText = content;
        socialData.shareImage = insetImage;
        
        socialData.extConfig.wechatTimelineData.title = title;
        socialData.extConfig.wechatTimelineData.shareText = content;
        socialData.extConfig.wechatTimelineData.shareImage = contentImage;
        if (contentImage) {
            socialData.extConfig.wechatTimelineData.wxMessageType = UMSocialWXMessageTypeImage;
        }
        
        socialData.extConfig.wechatTimelineData.url = targetUrlStr;
    }
    else if (platformName == UMShareToQzone) {
        socialData.title = title;
        socialData.shareText = content;
        socialData.shareImage = insetImage;
        
        socialData.extConfig.qzoneData.title = title;
        socialData.extConfig.qzoneData.shareText = content;
        socialData.extConfig.qzoneData.shareImage = contentImage;
        
        socialData.extConfig.qzoneData.url = targetUrlStr;
    }
}

@end
