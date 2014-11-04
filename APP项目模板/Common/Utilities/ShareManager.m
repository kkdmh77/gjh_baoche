//
//  NetRequestManager.m
//  websiteEmplate
//
//  Created by admin on 13-4-10.
//  Copyright (c) 2013年 龚俊慧. All rights reserved.
//

#import "ShareManager.h"
#import "ShareEditVC.h"

static ShareManager *staticShareManager;

@interface ShareManager ()

@property (nonatomic,strong) NSDictionary *shareContentDic;
@property (nonatomic,strong) UIViewController *rootViewController;

@end

@implementation ShareManager

@synthesize shareContentDic;
@synthesize rootViewController;

+ (ShareManager *)shareManager
{
    if (!staticShareManager)
        staticShareManager = [[ShareManager alloc] init];
    
    return staticShareManager;
}

- (void)shareInformationWithContentDic:(NSDictionary *)contentDic rootViewController:(UIViewController *)viewController
{
    self.shareContentDic = contentDic;
    self.rootViewController = viewController;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:Cancel destructiveButtonTitle:nil otherButtonTitles:Email,Message,SinaWeibo, nil];
    [actionSheet showInView:viewController.view];
}

#pragma mark - UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *clickedBtnTitleStr = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    NSString *headerStr = [self.shareContentDic objectForKey:informationHeaderkey];
    NSString *titleStr = [self.shareContentDic objectForKey:informationTitlekey];
    NSString *subtitleStr = [self.shareContentDic objectForKey:informationSubtitlekey];
    NSString *contentStr = [self.shareContentDic objectForKey:informationContentkey];
    NSString *appDownloadUrlStr = [self.shareContentDic objectForKey:informationAppDownloadUrlkey];
    
    if ([clickedBtnTitleStr isEqualToString:Email])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        if (mail)
        {
            mail.modalTransitionStyle = UIModalPresentationFullScreen;//效果
            mail.mailComposeDelegate = self;
            [mail setSubject:@"政民通分享"];//设置主题
            
            NSMutableString *mailContentStr = [NSMutableString string];
            
            if (titleStr)
                [mailContentStr appendFormat:@"<p>%@</p>",titleStr];
            if (subtitleStr)
                [mailContentStr appendFormat:@"<p>%@</p>",subtitleStr];
            if (contentStr)
                [mailContentStr appendString:contentStr];
            
            [mail setMessageBody:mailContentStr isHTML:YES];
            [mail setToRecipients:[NSArray arrayWithObjects:@"收件人邮箱",nil]]; //设置收件人，可以设置多人
            
            [self.rootViewController presentModalViewController:mail animated:YES];
        }
        else
            SimpleAlert(AlertTitle, @"本机没有设置邮箱账号,请设置后再发送邮件!", 1000, nil, nil, Confirm);
        
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://admin@hzlzh.com"]];//真机才能调用
    }
    else if ([clickedBtnTitleStr isEqualToString:Message])
    {
        MFMessageComposeViewController *message = [[MFMessageComposeViewController alloc] init];
        message.modalTransitionStyle = UIModalPresentationFullScreen;//效果
        message.messageComposeDelegate = self;
        message.body = [NSString stringWithFormat:@"%@\n%@\n%@",headerStr,titleStr,appDownloadUrlStr];
        message.recipients = [NSArray arrayWithObjects:@"10086",@"10010",nil];
        
        if (message)
            [self.rootViewController presentModalViewController:message animated:YES];
        
//        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"sms://10000"]];
    }
    else if ([clickedBtnTitleStr isEqualToString:SinaWeibo])
    {
        ShareEditVC *shareEditVC = [[ShareEditVC alloc] init];
        shareEditVC.sharePlatformNameStr = SinaWeibo;
        
        NSDictionary *shareInfoDic = nil;
        
        if (titleStr && contentStr)
            shareInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@%@|%@|%@",headerStr,titleStr,contentStr,appDownloadUrlStr],Share_Content_Text_key, nil];
        
        shareEditVC.shareContentDic = shareInfoDic;
        
        UINavigationController *shareEditNav = [[UINavigationController alloc] initWithRootViewController:shareEditVC];
        [self.rootViewController presentModalViewController:shareEditNav animated:YES];
    }
}

#pragma mark - MFMailComposeViewControllerDelegate methods
    
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissModalViewControllerAnimated:YES];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissModalViewControllerAnimated:YES];
}
    
@end
