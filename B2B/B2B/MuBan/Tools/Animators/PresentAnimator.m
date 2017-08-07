//
//  PresentAnimator.m
//  ViewControllersTransition
//
//  Created by YouXianMing on 15/7/21.
//  Copyright (c) 2015年 YouXianMing. All rights reserved.
//

#import "PresentAnimator.h"
#import "GJHSlideSwitchView.h"

@implementation PresentAnimator

- (void)animateTransitionEvent {
    CGFloat topImageOriginHeight = STATUS_BAR_HEIGHT + NAV_BAR_HEIGHT + kDefaultSlideSwitchViewHeight;
    CGFloat topImageHeight = NAV_BAR_HEIGHT + kDefaultSlideSwitchViewHeight;
    UIImage *tempImage = [UIImage grabImageWithView:self.toViewController.view scale:2];
    
    CGRect topImageRect = CGRectMake(0, 0, tempImage.size.width, topImageHeight);
    CGRect bottomImageRect = CGRectMake(0, topImageHeight + 32, tempImage.size.width, tempImage.size.height - topImageHeight - 32);
    
    UIImage *topImage = [tempImage imageCroppedToRect:topImageRect];
    UIImage *bottomImage = [tempImage imageCroppedToRect:bottomImageRect];
    
    UIImageView *topImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, tempImage.size.width, topImageHeight)];
    topImageView.autoresizingMask = UIViewAutoresizingNone;
    topImageView.image = topImage;
    
    UIImageView *bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tempImage.size.width, tempImage.size.height - topImageHeight - 32)];
    bottomImageView.autoresizingMask = UIViewAutoresizingNone;
    bottomImageView.image = bottomImage;

    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tempImage.size.width, topImageOriginHeight)];
    topView.autoresizingMask = UIViewAutoresizingNone;
    topView.backgroundColor = [DKNightVersionManager currentThemeVersion] == DKThemeVersionNight ? Common_ThemeColor_Night : Common_ThemeColor;
    [topView addSubview:topImageView];
    
    UIImageView *bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, topImageOriginHeight, tempImage.size.width, tempImage.size.height - topImageOriginHeight)];
    bottomView.autoresizingMask = UIViewAutoresizingNone;
    bottomView.image = [bottomImage imageCroppedToRect:CGRectMake(bottomImage.size.width - 2, bottomImage.size.height - 2, 2, 2)];
    [bottomView addSubview:bottomImageView];
    
    [self.containerView addSubview:self.toViewController.view];
    self.toViewController.view.alpha = 0.f;
    
    self.fromViewController.view.transform = CGAffineTransformMakeScale(1, 1);

    topView.frameOriginY = -topImageOriginHeight;
    bottomView.frameOriginY = self.containerView.frameHeight;
    [self.containerView addSubview:topView];
    [self.containerView addSubview:bottomView];
    
    [UIView animateWithDuration:self.transitionDuration
                          delay:0.0f
         usingSpringWithDamping:0.9f initialSpringVelocity:0.85f options:UIViewAnimationOptionCurveEaseIn animations:^{
         topView.frameOriginY = 0;
         bottomView.frameOriginY = topImageOriginHeight;
             
         self.fromViewController.view.transform = CGAffineTransformMakeScale(0.95, 0.95);
     } completion:^(BOOL finished) {
         self.toViewController.view.alpha = 1.f;

         [topView removeFromSuperview];
         [bottomView removeFromSuperview];
         [self completeTransition];
     }];
}

@end
