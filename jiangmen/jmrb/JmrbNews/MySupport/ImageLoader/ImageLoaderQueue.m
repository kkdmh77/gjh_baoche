//
//  ImageLoaderQueue.m
//
//  Created by Jason Wang on 4/16/11.
//  Copyright 2011 Jason Wang. All rights reserved.
//

#define DEFAULT_MAX_OPERATION_COUNT 3

#import "ImageLoaderQueue.h"
#import "ZSSourceModel.h"

@implementation ImageLoaderQueue

@synthesize target;

#pragma mark - Public

CG_INLINE  BOOL createImageFile(NSString * _fileName, UIImage *_image, BOOL _overwirte) {
    NSURL *url = [NSURL URLWithString:_fileName];
    _fileName = [url relativePath];
    
    NSInteger nameStart=0;
    NSInteger length = [_fileName length];
    for (nameStart = length - 1; nameStart >= 0 ; nameStart--) {
        if ([_fileName characterAtIndex:nameStart] == '/') {
            break;
        }
    }
    NSString *fileName = [_fileName substringFromIndex:nameStart+1];
    NSData *_data = nil;
    if ([fileName hasSuffix:@"jpg"]) {
        _data = UIImageJPEGRepresentation(_image, 1);
    }
    else {
        _data = UIImagePNGRepresentation(_image);
    }
    NSString *_filePath;
    BOOL result;
    
     NSString * strDic = [NSString stringWithFormat:@"%@/Library/%@/",
              NSHomeDirectory(),
              [[NSBundle mainBundle] bundleIdentifier]];
    
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSMutableString *ZSRBfilePath = [NSMutableString stringWithFormat:@"%@", [searchPaths objectAtIndex:0]];
    [ZSRBfilePath appendString:fileName_ZhongShanRiBao_PNG];
    if (![[NSFileManager defaultManager] fileExistsAtPath:ZSRBfilePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:ZSRBfilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
//    NSString *searchPaths = NSTemporaryDirectory();
//    NSString *ZSRBfilePath = [NSString stringWithFormat:@"%@/ZhongShanRiBao",searchPaths];
    if (![[NSFileManager defaultManager] fileExistsAtPath:ZSRBfilePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:ZSRBfilePath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    _filePath = [NSString stringWithFormat:@"%@/%@",ZSRBfilePath,fileName];
	if ([[NSFileManager defaultManager] fileExistsAtPath:_filePath isDirectory:NO]) {
		if (_overwirte) {
			if (![[NSFileManager defaultManager] removeItemAtPath:_filePath error:NULL])
				return NO;
		}
	}
    result = [[NSFileManager defaultManager] createFileAtPath:_filePath contents:nil attributes:nil];
    id handle = [NSFileHandle fileHandleForWritingAtPath:_filePath];
    [handle writeData:_data];
	return result;
}

CG_INLINE  UIImage* readImageFile(NSString * _fileName) {
    NSInteger nameStart=0;
    NSInteger length = [_fileName length];
    for (nameStart = length - 1; nameStart >= 0 ; nameStart--) {
        if ([_fileName characterAtIndex:nameStart] == '/') {
            break;
        }
    }
    NSString *fileName = [_fileName substringFromIndex:nameStart+1];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    UIImage *image;
    
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSMutableString *ZSRBfilePath = [NSMutableString stringWithFormat:@"%@", [searchPaths objectAtIndex:0]];
    [ZSRBfilePath appendString:fileName_ZhongShanRiBao_PNG];

//    NSMutableString *ZSRBfilePath = NSTemporaryDirectory();
//    [ZSRBfilePath appendString:@"ZhongShanRiBao"];
    NSString *_filePath;
    _filePath = [NSString stringWithFormat:@"%@/%@",ZSRBfilePath, fileName];
    if (![fileManager fileExistsAtPath:_filePath]) {
        return nil;
    }
    id handle = [NSFileHandle fileHandleForReadingAtPath:_filePath];
    image = [UIImage imageWithData:[handle readDataToEndOfFile]];
    return image;
}

- (UIImage *)getImageForURL:(NSString *)_url {
    UIImage *image = readImageFile(_url);
    if (image) {
        return image;
    }
//    if (_imagesDictionary) {
//        return [_imagesDictionary objectForKey:_url];
//    }
    return nil;
}

- (void)cancelQueue {
    _isCancel = YES;
    if (_imageOperationQueue) {
        [_imageOperationQueue cancelAllOperations];
        [_imageOperationQueue release];
        _imageOperationQueue = nil;
    }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
    
    if (_operationDictionary) {
        [_operationDictionary removeAllObjects];
    }
}

- (void)prepareRelease {
    [self cancelQueue];
//    if (_imagesDictionary) {
//        [_imagesDictionary removeAllObjects];
//    }
}

- (void)addOperationToQueueWithURL:(NSString *)_url atIndex:(NSInteger)_index {
    NSString *urlString = [_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    _url = urlString;
//    _url = [NSString stringWithUTF8String:_url];
    
    NSMutableArray *targetOperationArray = [_operationDictionary objectForKey:_url];
    NSNumber *indexNum = [NSNumber numberWithInt:_index];
    if (targetOperationArray) {
//        if ([targetOperationArray containsObject:indexNum]) 
//            return;
//        
//        [targetOperationArray addObject:indexNum];
//        return;
    }
    
    targetOperationArray = [NSMutableArray arrayWithObjects:indexNum, nil];
    [_operationDictionary setObject:targetOperationArray forKey:_url];
    
    if (!_imageOperationQueue) {
        _imageOperationQueue = [[NSOperationQueue alloc] init];
        [_imageOperationQueue setMaxConcurrentOperationCount:DEFAULT_MAX_OPERATION_COUNT];
    }
    
    [_imageOperationQueue addOperationWithBlock:^{
        if (!_isCancel &&_imageOperationQueue && [_imageOperationQueue isKindOfClass:[NSOperationQueue class]]) {
            
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            
            NSError *error = nil;
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_url] options:NSDataReadingUncached error:&error];
            double oldDownLoadData = [[ZSSourceModel defaultSource] downLoadSummary];
            [[ZSSourceModel defaultSource] setDownLoadSummary:[imageData length]*1.0/1000.0+oldDownLoadData];
            if (!error && !_isCancel) {
                UIImage *image = [UIImage imageWithData:imageData];
                
                if (image && !_isCancel) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                        
#ifdef ImageLoader_Cache_Image
                        createImageFile(_url, image, YES);
//                        if (_imagesDictionary) {
//                            [_imagesDictionary setObject:image forKey:_url];
//                        }
#endif
                        if (_operationDictionary) {
                            NSArray *tempOperationArray = [_operationDictionary objectForKey:_url];
                            for (NSNumber *number in tempOperationArray) {
                                NSInteger index = [number intValue];
                                if (self.target && [self.target respondsToSelector:@selector(imageOperationCompleted:atIndex:)]) {
                                    [self.target imageOperationCompleted:image atIndex:index];
                                }
                            }
                            [_operationDictionary removeObjectForKey:_url];
                        }
                    }];
                }
                else {
                    if (self.target && [self.target respondsToSelector:@selector(imageOperationWrongImagePath:)]) {
                        [self.target imageOperationWrongImagePath:_index];
                    }
                }
            }
            else {
                if (self.target && [self.target respondsToSelector:@selector(imageOperationWrongImagePath:)]) {
                    [self.target imageOperationWrongImagePath:_index];
                }
            }
            [pool drain];
        }
        
    }];
}

#pragma mark - NSObject lifecycle

- (id)initWithTarget:(id<ImageLoaderQueueDelegate>)_target {
	self = [super init];
	if (self != nil) {
		// initialize stuff here
        
        self.target = _target;
        
//        _imagesDictionary = [[NSMutableDictionary alloc] init];
        _operationDictionary = [[NSMutableDictionary alloc] init];
        
        _isCancel = NO;
        
	}    
	return self;
}

- (void)dealloc {
    [self prepareRelease];
    if (_operationDictionary) {
        [_operationDictionary release];
        _operationDictionary = nil;
    }
//    [_imagesDictionary release];
    [super dealloc];
}

@end
