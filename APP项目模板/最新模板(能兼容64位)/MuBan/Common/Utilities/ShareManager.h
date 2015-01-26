//
//  NetRequestManager.h
//  websiteEmplate
//
//  Created by admin on 13-4-10.
//  Copyright (c) 2013年 龚俊慧. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

static NSString * const informationHeaderkey = @"informationHeaderkey";
static NSString * const informationTitlekey = @"informationTitlekey";
static NSString * const informationSubtitlekey = @"informationSubtitlekey";
static NSString * const informationContentkey = @"informationContentkey";
static NSString * const informationAppDownloadUrlkey = @"informationAppDownloadUrlkey";

@interface ShareManager : NSObject<UIActionSheetDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>

+ (ShareManager *)shareManager;

- (void)shareInformationWithContentDic:(NSDictionary *)contentDic rootViewController:(UIViewController *)viewController;

@end

