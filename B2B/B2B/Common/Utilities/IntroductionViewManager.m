//
//  IntroductionViewManager.m
//  offlineTemplate
//
//  Created by admin on 13-12-04.
//  Copyright (c) 2013年 龚俊慧. All rights reserved.
//

#import "IntroductionViewManager.h"
#import "AppDelegate.h"

static MYBlurIntroductionView *staticIntroductionView;

@interface IntroductionViewManager ()

@property (nonatomic, strong) NSArray *imgsSourceArray;

@end

@implementation IntroductionViewManager

DEF_SINGLETON(IntroductionViewManager);

- (void)showIntroductionViewWithImgSource:(NSArray *)localImgsSourceArray superView:(UIView *)superView
{
    if (superView && localImgsSourceArray && 0 != localImgsSourceArray.count)
    {
        self.imgsSourceArray = localImgsSourceArray;
        
        NSMutableArray *totalPanelArray = [NSMutableArray arrayWithCapacity:localImgsSourceArray.count];
        
        for (int i = 0; i < localImgsSourceArray.count; i++)
        {
            MYIntroductionPanel *panel = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT) fullImage:[UIImage imageNamed:[localImgsSourceArray objectAtIndex:i]]];
            
            [totalPanelArray addObject:panel];
            
            // 最后一张指引页,加上开始btn
            if (i == (localImgsSourceArray.count - 1))
            {
                UIButton *skipBtn = InsertImageButton(panel,
                                                      CGRectMake(0, 0, 150, 53),
                                                      1000,
                                                      [UIImage imageNamed:@"btn_normal"],
                                                      [UIImage imageNamed:@"btn_pressed"],
                                                      self,
                                                      @selector(clickSkipBtn:));
                skipBtn.center = CGPointMake(panel.center.x, IPHONE_HEIGHT - (IPHONE_HEIGHT / 480) * 100 - 53 / 2);
            }
        }
        
        staticIntroductionView = [[MYBlurIntroductionView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT)];
        staticIntroductionView.delegate = self;
        staticIntroductionView.MasterScrollView.backgroundColor = [UIColor whiteColor];
        staticIntroductionView.LeftSkipButton.hidden = YES;
        // staticIntroductionView.RightSkipButton.hidden = YES;
        [staticIntroductionView.RightSkipButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [staticIntroductionView.RightSkipButton setTitle:@"跳过" forState:UIControlStateNormal];
        staticIntroductionView.PageControl.hidden = YES;
        staticIntroductionView.alpha = 0.0;
        [staticIntroductionView buildIntroductionWithPanels:totalPanelArray];
        
        [SharedAppDelegate.window addSubview:staticIntroductionView];
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            staticIntroductionView.alpha = 1.0;
            
            // [UIApplication sharedApplication].statusBarHidden = YES;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)clickSkipBtn:(id)sender
{
    [staticIntroductionView didPressSkipButton];
}

#pragma mark - MYIntroductionDelegate methods

- (void)introduction:(MYBlurIntroductionView *)introductionView didFinishWithType:(MYFinishType)finishType
{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        // [UIApplication sharedApplication].statusBarHidden = NO;
        
        introductionView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        [introductionView removeFromSuperview];
    }];
}

- (void)introduction:(MYBlurIntroductionView *)introductionView didChangeToPanel:(MYIntroductionPanel *)panel withIndex:(NSInteger)panelIndex
{
    if (panelIndex == _imgsSourceArray.count - 1) {
        staticIntroductionView.RightSkipButton.hidden = YES;
    } else {
        staticIntroductionView.RightSkipButton.hidden = NO;
    }
}

@end
