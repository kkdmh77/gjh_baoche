//
//  ShareManager.h
//  JmrbNews
//
//  Created by swift on 15/1/9.
//
//

#import <Foundation/Foundation.h>
#import "UMSocial.h"

@interface ShareManager : NSObject<UMSocialUIDelegate>

AS_SINGLETON(ShareManager);

/**
 @ 方法描述    分享
 @ 输入参数    url: 分享的URL, insetImage: 分享对话框的缩略图, contentImage: 内容大图, presentedController: 触发方法的控制器
 @ 返回值      void
 @ 创建人      龚俊慧
 @ 创建时间    2015-01-28
 */
- (void)shareWithContent:(NSString *)content
                   title:(NSString *)title
                     url:(NSString *)urlStr
              insetImage:(UIImage *)insetImage
            contentImage:(UIImage *)contentImage
     presentedController:(UIViewController *)presentedController;


/**
 @ 方法描述    第三方平台登录
 @ 输入参数    snsNames 你要分享到的sns平台类型，该NSArray值是`UMSocialSnsPlatformManager.h`定义的平台名的字符串常量，有UMShareToSina，UMShareToTencent，UMShareToRenren，UMShareToDouban，UMShareToQzone，UMShareToEmail，UMShareToSms等
 @ 输入参数    presentingController 点击后弹出的分享页面或者授权页面所在的UIViewController对象
 @ 返回值      void
 @ 创建人      龚俊慧
 @ 创建时间    2016-03-14
 */
- (void)thirdPartyLoginWithSnsName:(NSString *)snsName
              presentingController:(UIViewController *)presentingController
             loginSuccessedHandler:(void (^) (UMSocialAccountEntity *accountEntity))loginSuccessedHandler;

@end
