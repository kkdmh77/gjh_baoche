//
//  DismissAnimator.m
//  ViewControllersTransition
//
//  Created by YouXianMing on 15/7/21.
//  Copyright (c) 2015年 YouXianMing. All rights reserved.
//

#import "DismissAnimator.h"
#import "GJHSlideSwitchView.h"
#import "BaseTabBarVC.h"

@implementation DismissAnimator

- (void)animateTransitionEvent {
    CGFloat topImageHeight = STATUS_BAR_HEIGHT + NAV_BAR_HEIGHT + kDefaultSlideSwitchViewHeight;
    UIImage *tempImage = [UIImage grabImageWithView:self.fromViewController.view scale:2];
    
    CGRect topImageRect = CGRectMake(0, 0, tempImage.size.width, topImageHeight);
    CGRect bottomImageRect = CGRectMake(0, topImageHeight, tempImage.size.width, tempImage.size.height - topImageHeight);
    
    UIImage *topImage = [tempImage imageCroppedToRect:topImageRect];
    UIImage *bottomImage = [tempImage imageCroppedToRect:bottomImageRect];
    
    UIImageView *topImageView  = [[UIImageView alloc] initWithFrame:topImageRect];
    topImageView.image = topImage;
    UIImageView *bottomImageView = [[UIImageView alloc] initWithFrame:bottomImageRect];
    bottomImageView.image = bottomImage;
    
    [self.containerView addSubview:self.toViewController.view];
    self.toViewController.view.transform = CGAffineTransformMakeScale(0.95, 0.95);
    
    [self.containerView addSubview:topImageView];
    [self.containerView addSubview:bottomImageView];
    
    [UIView animateWithDuration:self.transitionDuration
                          delay:0.0f
         usingSpringWithDamping:1.0f initialSpringVelocity:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
         topImageView.frameOriginY = -topImageHeight;
         bottomImageView.frameOriginY = self.containerView.frameHeight;
             
         self.toViewController.view.transform = CGAffineTransformMakeScale(1, 1);
     } completion:^(BOOL finished) {
         self.toViewController.view.alpha = 1;

         [topImageView removeFromSuperview];
         [bottomImageView removeFromSuperview];

         [self completeTransition];
     }];
}

@end
