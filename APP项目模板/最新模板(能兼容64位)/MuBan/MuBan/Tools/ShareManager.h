//
//  ShareManager.h
//  JmrbNews
//
//  Created by swift on 15/1/9.
//
//

#import <Foundation/Foundation.h>
#import <UMSocialCore/UMSocialCore.h>

@interface ShareManager : NSObject

AS_SINGLETON(ShareManager);

/**
 @ 方法描述    分享
 @ 输入参数    content: 分享正文, presentedController: 触发方法的控制器
 @ 返回值      void
 @ 创建人      龚俊慧
 @ 创建时间    2015-01-28
 */
- (void)shareWithContent:(NSString *)content
     presentedController:(UIViewController *)presentedController
              completion:(void (^) (UMSocialShareResponse *result, NSError *error))completion;

/**
 @ 方法描述    分享(就算全参数传入，在不同平台的展示效果会不一样)
 @ 输入参数    content: 分享正文, url: 分享的URL, insetImage: 缩略图（UIImage或者NSData类型，或者image_url）, contentImage: 图片内容（可以是UIImage类对象，也可以是NSdata类对象，也可以是图片链接imageUrl NSString类对象）, presentedController: 触发方法的控制器
 @ 返回值      void
 @ 创建人      龚俊慧
 @ 创建时间    2015-01-28
 */
- (void)shareWithContent:(NSString *)content
                   title:(NSString *)title
                     url:(NSString *)urlStr
              insetImage:(id)insetImage
            contentImage:(id)contentImage
     presentedController:(UIViewController *)presentedController
              completion:(void (^) (UMSocialShareResponse *result, NSError *error))completion;

/**
 @ 方法描述    第三方平台登录
 @ 输入参数    UMSocialPlatformType 你要分享到的sns平台类型
 @ 输入参数    presentingController 点击后弹出的分享页面或者授权页面所在的UIViewController对象
 @ 返回值      void
 @ 创建人      龚俊慧
 @ 创建时间    2016-03-14
 */
- (void)thirdPartyLoginWithSnsName:(UMSocialPlatformType)platformType
              presentingController:(UIViewController *)presentingController
                        completion:(void (^) (UMSocialUserInfoResponse *result, NSError *error))completion;

@end
