//
//  ATBLibs+UIImage.m
//  ATBLibs
//
//  Created by HJC on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ATBLibs+UIImage.h"

static CGContextRef _newBitmapContext(CGSize size)
{
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    size_t imgWith = (size_t)(size.width + 0.5);
	size_t imgHeight = (size_t)(size.height + 0.5);
	size_t bytesPerRow = imgWith * 4;
    
	CGContextRef context = CGBitmapContextCreate(
												 NULL, 
												 imgWith, 
												 imgHeight,
												 8, 
												 bytesPerRow,
												 colorSpaceRef, 
												 (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
    CGColorSpaceRelease(colorSpaceRef);
    return context;
}


@implementation UIImage(ATBLibsAddtions)

- (UIImage *)createCornerRadius:(CGFloat)cornerRadius
{
    CGFloat w = self.size.width;
    CGFloat h = self.size.height;
    CGFloat scale = [UIScreen mainScreen].scale;
    // 防止圆角半径小于0，或者大于宽/高中较小值的一半。
    if (cornerRadius < 0)
        cornerRadius = 0;
    else if (cornerRadius > MIN(w, h))
        cornerRadius = MIN(w, h) / 2.;
    
    UIImage *image = nil;
    CGRect imageFrame = CGRectMake(0., 0., w, h);
    UIGraphicsBeginImageContextWithOptions(self.size, NO, scale);
    [[UIBezierPath bezierPathWithRoundedRect:imageFrame cornerRadius:cornerRadius] addClip];
    [self drawInRect:imageFrame];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage*) transToBitmapImage
{
    return [self transToBitmapImageWithSize:self.size];
}

- (UIImage *)resize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*) transToBitmapImageWithSize:(CGSize)size
{
	CGContextRef context = _newBitmapContext(size);
	
	CGRect drawRect = CGRectMake(0, 0, size.width, size.height);
	CGContextDrawImage(context, drawRect, self.CGImage);
	
	CGImageRef imgRef = CGBitmapContextCreateImage(context);
	UIImage* image = [UIImage imageWithCGImage:imgRef];
	
	CGContextRelease(context);
	CGImageRelease(imgRef);	
	
	return image;
}




- (UIImage*) transToGrayImage
{
    CGSize size = [self size];
    int width = size.width;
    int height = size.height;
	
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
	
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
	
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace, 
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
	
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
	
    const NSInteger redIndex = 3;
    const NSInteger greenIndex = 2;
    const NSInteger blueIndex = 1;
    for (int y = 0; y < height; y++)
    {
        for (int x = 0; x < width; x++)
        {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
			
            // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
            uint32_t gray = 0.3 * rgbaPixel[redIndex] + 0.59 * rgbaPixel[greenIndex] + 0.11 * rgbaPixel[blueIndex];
			
            // set the pixels to gray
            rgbaPixel[redIndex] = gray;
            rgbaPixel[greenIndex] = gray;
            rgbaPixel[blueIndex] = gray;
        }
    }
	
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef image = CGBitmapContextCreateImage(context);
	
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
	
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:image];
	
    // we're done with image now too
    CGImageRelease(image);
	
    return resultUIImage;
}




+ (UIImage*) imageNamed:(NSString *)name useCache:(BOOL)useCache
{
    if (useCache)
    {
        return [UIImage imageNamed:name];
    }
    
    CGFloat screenScale = 1.0f;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
    {
        screenScale = [UIScreen mainScreen].scale;
    }
    
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString* path = nil; 
    if (screenScale > 1.0f)
    {
        NSString* pathExtension = [name pathExtension];
        NSString* name2x = [name stringByAppendingString:@"@2x"];
        name2x = [name2x stringByAppendingPathExtension:pathExtension];
        
        path = [resourcePath stringByAppendingPathComponent:name2x]; 
        
        BOOL isDirectory = NO; 
        if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory] 
            || isDirectory)
        {
            path = [resourcePath stringByAppendingPathComponent:name];
        }
    }
    else
    {
        path = [resourcePath stringByAppendingPathComponent:name];
    }
    
    return [UIImage imageWithContentsOfFile:path];
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    return [self imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage*) imageWithColor:(UIColor*)color size:(CGSize)size
{
    CGContextRef context = _newBitmapContext(size);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    UIImage* img = [UIImage imageWithCGImage:imgRef];
    
    CGContextRelease(context);
    CGImageRelease(imgRef);
    
    return img;
}




- (UIImage*) imageInRect:(CGRect)rect
{
    CGImageRef imgRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage* image = [UIImage imageWithCGImage:imgRef];
    CGImageRelease(imgRef);
    return image;
}



- (UIImage*) imageByKeepingDrawBlock:(void(^)(CGContextRef context, CGRect rect))block
{
    CGContextRef context = _newBitmapContext(self.size);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    block(context, rect);
    CGImageRef clipImage = CGBitmapContextCreateImage(context);
    
    CGContextClearRect(context, rect);
    CGContextClipToMask(context, rect, clipImage);
    CGContextDrawImage(context, rect, self.CGImage);
    CGImageRelease(clipImage);
    
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
	UIImage* image = [UIImage imageWithCGImage:imgRef];
    
    CGContextRelease(context);
	CGImageRelease(imgRef);	
    
    return image;
}


- (UIImage*) imageByClearingDrawBlock:(void(^)(CGContextRef context, CGRect rect))block
{
    CGContextRef context = _newBitmapContext(self.size);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextDrawImage(context, rect, self.CGImage);
    CGContextSetBlendMode(context, kCGBlendModeClear);
    block(context, rect);
    
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
	UIImage* image = [UIImage imageWithCGImage:imgRef];
    
    CGContextRelease(context);
	CGImageRelease(imgRef);	
    
    return image;
}


@end
