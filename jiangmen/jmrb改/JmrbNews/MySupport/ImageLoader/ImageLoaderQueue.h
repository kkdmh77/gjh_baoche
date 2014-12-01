//
//  ImageLoaderQueue.h
//
//  Created by Jason Wang on 4/16/11.
//  Copyright 2011 Jason Wang. All rights reserved.
//

#define ImageLoader_Cache_Image //Cache Image In NSMutableDictionary

@protocol ImageLoaderQueueDelegate;

@interface ImageLoaderQueue : NSObject {
    id<ImageLoaderQueueDelegate> target;
    
    @private
        NSOperationQueue *_imageOperationQueue;
        NSMutableDictionary *_operationDictionary;
//        NSMutableDictionary *_imagesDictionary;
        
        BOOL _isCancel;
}

@property(nonatomic,assign) id<ImageLoaderQueueDelegate> target;

#pragma mark - NSObject lifecycle

- (id)initWithTarget:(id<ImageLoaderQueueDelegate>)_target;

#pragma mark - Public

- (UIImage *)getImageForURL:(NSString *)_url;

- (void)cancelQueue;

- (void)prepareRelease;

- (void)addOperationToQueueWithURL:(NSString *)_url atIndex:(NSInteger)_index;

@end

@protocol ImageLoaderQueueDelegate <NSObject>

- (void)imageOperationCompleted:(UIImage *)_image atIndex:(NSInteger)_index;

@optional
- (void)imageOperationWrongImagePath:(NSInteger)_index;

@end
