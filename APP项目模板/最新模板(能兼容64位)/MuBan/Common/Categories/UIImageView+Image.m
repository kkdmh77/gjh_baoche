//
//  UIImageView+Image.m
//  o2o
//
//  Created by swift on 14-7-14.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "UIImageView+Image.h"

@implementation UIImageView (Image)

#if NS_BLOCKS_AVAILABLE
- (void)gjh_setImageWithURL:(NSURL *)url
                    success:(void (^)(UIImage *))success
{
    [self gjh_setImageWithURL:url
               imageShowStyle:ImageShowStyle_AutoResizing
                      success:success
                      failure:nil];
}

- (void)gjh_setImageWithURL:(NSURL *)url
             imageShowStyle:(ImageShowStyle)style
                    success:(void (^)(UIImage *))success
                    failure:(void (^)(NSError *))failure
{
    [self gjh_setImageWithURL:url
             placeholderImage:[UIImage imageNamed:@""]
               imageShowStyle:style
                      success:success
                      failure:failure];
}

- (void)gjh_setImageWithURL:(NSURL *)url
           placeholderImage:(UIImage *)placeholder
             imageShowStyle:(ImageShowStyle)style
                    success:(void (^)(UIImage *))success
                    failure:(void (^)(NSError *))failure
{
    [self gjh_setImageWithURL:url
             placeholderImage:placeholder
               imageShowStyle:style
                      options:YYWebImageOptionSetImageWithFadeAnimation
                      success:success
                      failure:failure];
}

- (void)gjh_setImageWithURL:(NSURL *)url
           placeholderImage:(UIImage *)placeholder
             imageShowStyle:(ImageShowStyle)style
                    options:(YYWebImageOptions)options
                    success:(void (^)(UIImage *))success
                    failure:(void (^)(NSError *))failure
{
    [self gjh_setImageWithURL:url
             placeholderImage:placeholder
               imageShowStyle:style
                      options:options
                    transform:nil
                      success:success
                      failure:failure];
}

- (void)gjh_setImageWithURL:(NSURL *)url
           placeholderImage:(UIImage *)placeholder
             imageShowStyle:(ImageShowStyle)style
                    options:(YYWebImageOptions)options
                  transform:(YYWebImageTransformBlock)transform
                    success:(void (^)(UIImage *image))success
                    failure:(void (^)(NSError *error))failure
{
    self.contentMode = UIViewContentModeCenter;

    @weakify(self)
    [self setImageWithURL:url
              placeholder:placeholder
                  options:options
                 progress:nil
                transform:transform
               completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (image && !error) {
            switch (style) {
                case ImageShowStyle_AutoResizing: {
                weak_self.contentMode = UIViewContentModeScaleAspectFit;
            }
                break;
            case ImageShowStyle_Square: {
                weak_self.contentMode = UIViewContentModeScaleToFill;
                image = [image squareImage];
            }
                break;
            case ImageShowStyle_None: {
                // do nothing
                weak_self.contentMode = UIViewContentModeScaleToFill;
            }
                break;
            default:
                break;
        }
        
        weak_self.image = image;
        [weak_self setNeedsLayout];

        // 回调
        if (success) success(image);
        } else {
            if (failure) failure(error);
        }
    }];
}

#endif

- (void)gjh_cancelCurrentImageLoad
{
    [self cancelCurrentImageRequest];
}

@end
