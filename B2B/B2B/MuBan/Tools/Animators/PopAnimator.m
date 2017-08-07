//
//  PopAnimator.m
//  ViewControllersTransition
//
//  Created by YouXianMing on 15/7/21.
//  Copyright (c) 2015年 YouXianMing. All rights reserved.
//

#import "PopAnimator.h"
#import "GJHSlideSwitchView.h"

@implementation PopAnimator

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
    
    //    [topImageView addBorderToViewWitBorderColor:[UIColor redColor] borderWidth:5];
    //    [bottomImageView addBorderToViewWitBorderColor:[UIColor blueColor] borderWidth:5];
    
    [self.containerView addSubview:self.toViewController.view];
    
//    topImageView.frameOriginY = -topImageHeight;
//    bottomImageView.frameOriginY = self.containerView.frameHeight;
    [self.containerView addSubview:topImageView];
    [self.containerView addSubview:bottomImageView];
    
    self.toViewController.view.alpha = 0.f;
    
    [UIView animateWithDuration:.5
                          delay:0.0f
         usingSpringWithDamping:1 initialSpringVelocity:0.f options:0 animations:^{
             
             topImageView.frameOriginY = -topImageHeight;
             bottomImageView.frameOriginY = self.containerView.frameHeight;
             
             self.fromViewController.view.alpha = 0.f;
             self.toViewController.view.alpha   = 1.f;
             
     } completion:^(BOOL finished) {
         
         [topImageView removeFromSuperview];
         [bottomImageView removeFromSuperview];
         [self completeTransition];
     }];
}

@end
