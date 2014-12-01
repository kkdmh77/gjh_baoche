//
//  NewsCell.m
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-9.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import "NewsCell.h"

@implementation NewsCell 
@synthesize newsImageView, newsTitle, newsDetailTitle,newstypeImageView,newsReplayView;

- (UIImage *)createPictureImage:(UIImage *)picImage {
    CGSize size = picImage.size;
    CGFloat imageWidth = self.newsImageView.frame.size.width * 2;
    CGFloat imageHeight = self.newsImageView.frame.size.height * 2;    
    if (size.width < imageWidth || size.height < imageHeight) {
        imageWidth = self.newsImageView.frame.size.width;
        imageHeight = self.newsImageView.frame.size.height; 
    }
    UIGraphicsBeginImageContext(CGSizeMake(imageWidth, imageHeight));
    CGFloat souXiao=1;
    if (size.width/imageWidth < size.height/imageHeight) {
        if (size.width>imageWidth) {
            souXiao = size.width/imageWidth;
        }
    }
    else {
        if (size.height>imageWidth) {
            souXiao = size.height/imageHeight;
        }
    }
    if (souXiao > 1) {
        size.width = size.width/souXiao;
        size.height = size.height/souXiao;
    }
    [picImage drawInRect:CGRectMake((imageWidth-size.width)/2, (imageHeight-size.height)/2, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)setCellImage:(UIImage *)in_image {
    UIImage *newImage = [self createPictureImage:in_image];
    [self.newsImageView setImage:newImage];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}

@end
