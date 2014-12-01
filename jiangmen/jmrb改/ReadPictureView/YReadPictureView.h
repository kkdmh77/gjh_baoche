//
//  YReadPictureView.h
//  YReadPicture
//
//  Created by COMMINICATIONS GUANGXIN on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YReadPictureViewDelegate;

@interface YReadPictureView : UIView {
    BOOL out_isMoving;
    NSInteger out_currentImageIndex;
    NSInteger out_number;
    NSInteger out_distanceBetweenImage;
    UIImageView *out_oldImageView, *out_newImageView;
    UILabel *out_oldImagelaber, *out_newImagelaber;
}

@property (nonatomic, assign) id<YReadPictureViewDelegate> delegate;
@property (nonatomic, retain) UIPageControl *pageViewControl;

- (void)setCurrentIndex:(NSInteger)in_index;
- (void)setImage:(UIImage *)in_image ForIndex:(NSInteger)in_index;
- (void)setTitleText:(NSString *)in_title ForIndex:(NSInteger)in_index;
- (void)setImageNumber:(NSInteger)in_number;
- (void)setImagesBetweenDistance:(NSInteger)in_distance;
- (void)reloadData;

@end

@protocol YReadPictureViewDelegate <NSObject>
@required
- (void)YReadPictureView:(YReadPictureView *)in_readPictureView requestImageForIndex:(NSInteger)in_index;

@optional

- (void)YReadPictureView:(YReadPictureView *)in_readPictureView clickImageForIndex:(NSInteger)in_index;

@end
