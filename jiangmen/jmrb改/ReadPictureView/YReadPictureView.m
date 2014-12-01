//
//  YReadPictureView.m
//  YReadPicture
//
//  Created by COMMINICATIONS GUANGXIN on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YReadPictureView.h"
@interface YReadPictureView (private)

- (void)preInitParameters;
- (void)showNextPicture;
- (void)showPrePicture;
- (void)clickPageControl;
- (void)clickImage;

@end

@implementation YReadPictureView
@synthesize delegate;
@synthesize pageViewControl;

#pragma mark - system
- (void)dealloc {
    [self setPageViewControl:nil];
    [out_oldImageView release];
    [out_newImageView release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        [self preInitParameters];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self preInitParameters];
    }
    return self;
}

#pragma mark - Private
- (void)clickImage {
    if (delegate && [delegate respondsToSelector:@selector(YReadPictureView:clickImageForIndex:)]) {
        [delegate YReadPictureView:self clickImageForIndex:out_currentImageIndex];
    }
}

- (void)clickPageControl {
    if ([self.pageViewControl currentPage] > out_currentImageIndex) {
        [self showNextPicture];
    } 
    if ([self.pageViewControl currentPage] < out_currentImageIndex) {
        [self showPrePicture];
    }
}

- (void)preInitParameters {
    [self setClipsToBounds:YES];
    out_isMoving = NO;
    out_number = 0;
    out_distanceBetweenImage = 0;
    out_currentImageIndex = 0;
    out_oldImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    out_newImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
    [out_oldImageView setContentMode:UIViewContentModeScaleAspectFit];
    [out_newImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:out_oldImageView];
    [self addSubview:out_newImageView];
    
    UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clickBtn setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-40)];
    [clickBtn addTarget:self action:@selector(clickImage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:clickBtn];
    
    UISwipeGestureRecognizer *swipGestureNext = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showNextPicture)];
    [swipGestureNext setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self addGestureRecognizer:swipGestureNext];
    [swipGestureNext release];
    
    UISwipeGestureRecognizer *swipGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showPrePicture)];
    [swipGestureLeft setDirection:UISwipeGestureRecognizerDirectionRight];
    [self addGestureRecognizer:swipGestureLeft];
    [swipGestureLeft release];

    UIPageControl *pageView = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height-40, self.frame.size.width, 36)];
    [self setPageViewControl:pageView];
    [pageView release];
    [self addSubview:self.pageViewControl];
    
    
    out_oldImagelaber=[[UILabel alloc] initWithFrame:self.bounds];
    out_newImagelaber = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
    
    
//    UIView *titleviewbg=[[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-40, self.frame.size.width, 36)];
//    [titleviewbg setBackgroundColor:[UIColor redColor]];
//    [self addSubview:titleviewbg];
    
    [pageView release];
    
    [pageViewControl addTarget:self action:@selector(clickPageControl) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showNextPicture {
    if (out_isMoving || out_currentImageIndex >= out_number-1) {
        return;
    }
    if (delegate && [delegate respondsToSelector:@selector(YReadPictureView:requestImageForIndex:)]) {
        [delegate YReadPictureView:self requestImageForIndex:out_currentImageIndex+1];
    }
    out_isMoving = YES;
    [out_newImageView setCenter:CGPointMake(self.frame.size.width*1.5+out_distanceBetweenImage, self.frame.size.height/2)];
    [UIView animateWithDuration:.3 animations:^{
        [out_newImageView setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
        [out_oldImageView setCenter:CGPointMake(-self.frame.size.width*1.5-out_distanceBetweenImage, self.frame.size.height/2)];
    }completion:^(BOOL finish) {    
        out_isMoving = NO;
        UIImageView *imageView = out_oldImageView;
        out_oldImageView = out_newImageView;
        out_newImageView = imageView;
        out_currentImageIndex++;
        [self.pageViewControl setCurrentPage:out_currentImageIndex];
    }];
}

- (void)showPrePicture {
    if (out_isMoving || out_currentImageIndex <= 0) {
        return;
    }
    if (delegate && [delegate respondsToSelector:@selector(YReadPictureView:requestImageForIndex:)]) {
        [delegate YReadPictureView:self requestImageForIndex:out_currentImageIndex-1];
    }
    out_isMoving = YES;
    [out_newImageView setCenter:CGPointMake(-self.frame.size.width*1.5-out_distanceBetweenImage, self.frame.size.height/2)];
    [UIView animateWithDuration:.3 animations:^{
        [out_newImageView setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
        [out_oldImageView setCenter:CGPointMake(self.frame.size.width*1.5+out_distanceBetweenImage, self.frame.size.height/2)];
    }completion:^(BOOL finish) {
        out_isMoving = NO;
        UIImageView *imageView = out_oldImageView;
        out_oldImageView = out_newImageView;
        out_newImageView = imageView;
        out_currentImageIndex--;
        [self.pageViewControl setCurrentPage:out_currentImageIndex];
    }];

}

#pragma mark - public
- (void)setCurrentIndex:(NSInteger)in_index {
    out_currentImageIndex = in_index;
    [self.pageViewControl setCurrentPage:0];
}

- (void)setImage:(UIImage *)in_image ForIndex:(NSInteger)in_index {
    if (out_currentImageIndex == in_index) {
        [out_oldImageView setImage:in_image];
    }
    if (abs(out_currentImageIndex - in_index) == 1) {
        [out_newImageView setImage:in_image];
    }
}

- (void)setTitleText:(NSString *)in_title ForIndex:(NSInteger)in_index{
    if (out_currentImageIndex == in_index) {
        [out_oldImagelaber setText:in_title];
    }
    if (abs(out_currentImageIndex - in_index) == 1) {
        [out_oldImagelaber setText:in_title];
    }
}

- (void)setImageNumber:(NSInteger)in_number {
    out_number = in_number;
    [self.pageViewControl setNumberOfPages:in_number];
}

- (void)setImagesBetweenDistance:(NSInteger)in_distance {
    out_distanceBetweenImage = in_distance;
}

- (void)reloadData {
    [out_oldImageView setImage:nil];
    if (delegate && [delegate respondsToSelector:@selector(YReadPictureView:requestImageForIndex:)]) {
        [delegate YReadPictureView:self requestImageForIndex:out_currentImageIndex];
    }
}

@end













