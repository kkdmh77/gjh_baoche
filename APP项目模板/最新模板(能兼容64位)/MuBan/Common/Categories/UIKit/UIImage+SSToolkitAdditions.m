//
//  UIImage+SSToolkitAdditions.m
//  SSToolkit
//
//  Created by Sam Soffes on 11/17/09.
//  Copyright 2009-2011 Sam Soffes. All rights reserved.
//

#import "UIImage+SSToolkitAdditions.h"
#import "QuartzCore/QuartzCore.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (SSToolkitAdditions)

+ (UIImage *)imageNamed:(NSString *)imageName bundleName:(NSString *)bundleName {
	if (!bundleName) {
		return [UIImage imageNamed:imageName];
	}
	
	NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
	NSString *bundlePath = [resourcePath stringByAppendingPathComponent:bundleName];
	NSString *imagePath = [bundlePath stringByAppendingPathComponent:imageName];
	return [UIImage imageWithContentsOfFile:imagePath];
}

- (UIImage *)imageCroppedToRect:(CGRect)rect {
	// CGImageCreateWithImageInRect's `rect` parameter is in pixels of the image's coordinates system. Convert from points.
	CGFloat scale = self.scale;
	rect = CGRectMake(rect.origin.x * scale, rect.origin.y * scale, rect.size.width * scale, rect.size.height * scale);
	
	CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
	UIImage *cropped = [UIImage imageWithCGImage:imageRef scale:scale orientation:self.imageOrientation];
	CGImageRelease(imageRef);
	return cropped;
}


- (UIImage *)squareImage {
    CGSize imageSize = self.size;
    CGFloat shortestSide = fminf(imageSize.width, imageSize.height);
    CGFloat originX = imageSize.width <= imageSize.height ? 0 : ((imageSize.width - shortestSide) / 2);
    CGFloat originY = imageSize.height <= imageSize.width ? 0 : ((imageSize.height - shortestSide) / 2);
    
    return [self imageCroppedToRect:CGRectMake(originX, originY, shortestSide, shortestSide)];
}


- (NSInteger)rightCapWidth {
	return (NSInteger)self.size.width - (self.leftCapWidth + 1);
}


- (NSInteger)bottomCapHeight {
	return (NSInteger)self.size.height - (self.topCapHeight + 1);
}

- (UIImage*)gaussBlur:(CGFloat)blurLevel
{
    blurLevel = MIN(1.0, MAX(0.0, blurLevel));
    
    int boxSize = (int)(blurLevel * 0.1 * MIN(self.size.width, self.size.height));
    boxSize = boxSize - (boxSize % 2) + 1;
    
    NSData *imageData = UIImageJPEGRepresentation(self, 1);
    UIImage *tmpImage = [UIImage imageWithData:imageData];
    
    CGImageRef img = tmpImage.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    //create vImage_Buffer with data from CGImageRef
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    NSInteger windowR = boxSize/2;
    CGFloat sig2 = windowR / 3.0;
    if(windowR>0){ sig2 = -1/(2*sig2*sig2); }
    
    int16_t *kernel = (int16_t*)malloc(boxSize*sizeof(int16_t));
    int32_t  sum = 0;
    for(NSInteger i=0; i<boxSize; ++i){
        kernel[i] = 255*exp(sig2*(i-windowR)*(i-windowR));
        sum += kernel[i];
    }
    
    // convolution
    error = vImageConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, kernel, boxSize, 1, sum, NULL, kvImageEdgeExtend);
    error = vImageConvolve_ARGB8888(&outBuffer, &inBuffer, NULL, 0, 0, kernel, 1, boxSize, sum, NULL, kvImageEdgeExtend);
    outBuffer = inBuffer;
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGBitmapAlphaInfoMask & kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    
    return returnImage;
}

- (UIImage *) imageWithTintColor:(UIColor *)tintColor
{
    // We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    // Draw the tinted image in context
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

+ (UIImage *)grabScreenWithScale:(CGFloat)scale
{
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    //    UIGraphicsBeginImageContext(screenWindow.frame.size);
    UIGraphicsBeginImageContextWithOptions(screenWindow.frame.size, YES, scale);
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)grabImageWithView:(UIView *)view scale:(CGFloat)scale
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    return image;
}

+ (UIImage *)captureView:(UIView *)view frame:(CGRect)frame
{
    UIGraphicsBeginImageContext(view.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef ref = CGImageCreateWithImageInRect(img.CGImage, frame);
    UIImage *i = [UIImage imageWithCGImage:ref];
    CGImageRelease(ref);
    return i;
}

+ (UIImage *)mergeWithImage1:(UIImage*)image1 image2:(UIImage *)image2 frame1:(CGRect)frame1 frame2:(CGRect)frame2 size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image1 drawInRect:frame1 blendMode:kCGBlendModeLuminosity alpha:1.0];
    [image2 drawInRect:frame2 blendMode:kCGBlendModeLuminosity alpha:0.2];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)mask{
    CGImageRef imgRef = [image CGImage];
    CGImageRef maskRef = [mask CGImage];
    CGImageRef actualMask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                              CGImageGetHeight(maskRef),
                                              CGImageGetBitsPerComponent(maskRef),
                                              CGImageGetBitsPerPixel(maskRef),
                                              CGImageGetBytesPerRow(maskRef),
                                              CGImageGetDataProvider(maskRef), NULL, true);
    CGImageRef masked = CGImageCreateWithMask(imgRef, actualMask);
    UIImage *resultImg = [UIImage imageWithCGImage:masked];
    CGImageRelease(actualMask);
    CGImageRelease(masked);
    
    return resultImg;
}

+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

+(UIImage *)colorizeImage:(UIImage *)image withColor:(UIColor *)color
{
    UIGraphicsBeginImageContext(image.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSaveGState(ctx);
    CGContextClipToMask(ctx, area, image.CGImage);
    [color set];
    CGContextFillRect(ctx, area);
    CGContextRestoreGState(ctx);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextDrawImage(ctx, area, image.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}



+ (NSString *)contentTypeForImageData:(NSData *)data
{
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c)
    {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
}




@end
