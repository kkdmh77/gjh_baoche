//
//  PSV2Cell.m
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PSV2Cell.h"

@interface PSV2Cell ()

- (UIImage *)createPictureImage:(UIImage *)picImage;

@end

@implementation PSV2Cell
@synthesize imageView;
@synthesize lblTitle;

#pragma mark - Private
- (UIImage *)createPictureImage:(UIImage *)picImage {
    CGSize size = picImage.size;
    CGFloat imageWidth = self.imageView.frame.size.width * 2;
    CGFloat imageHeight = self.imageView.frame.size.height * 2;    
    if (size.width < imageWidth || size.height < imageHeight) {
        imageWidth = self.imageView.frame.size.width;
        imageHeight = self.imageView.frame.size.height;
    }
    UIGraphicsBeginImageContext(CGSizeMake(imageWidth, imageHeight));
    CGFloat souXiao=1;
    if (size.width/imageWidth > size.height/imageHeight) {
        if (size.width>imageWidth) {
            souXiao = size.width/imageWidth;
        }
    }
    else {
        if (size.height>imageWidth) {
            souXiao = size.height/imageHeight;
        }
    }
    size.width = size.width/souXiao;
    size.height = size.height/souXiao;
    [picImage drawInRect:CGRectMake((imageWidth-size.width)/2, (imageHeight-size.height)/2, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - System
- (void)dealloc {
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)setImage:(UIImage *)in_image {
    UIImage *newImage = [self createPictureImage:in_image];
    [self.imageView setImage:newImage];
}

@end
