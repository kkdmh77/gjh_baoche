//
//  DownLoadManager.h
//  KKDictionary
//
//  Created by KungJack on 12/8/14.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFDownloadRequestOperation.h"

#define DOWN_LOAD_FILEING       @"DOWN_LOAD_FILEING"
#define DOWN_LOAD_PAUSE         @"DOWN_LOAD_PAUSE"
#define DOWN_LOAD_SUCCESS       @"DOWN_LOAD_SUCCESS"
#define DOWN_LOAD_ERROR         @"DOWN_LOAD_ERROR"

#define DOWN_LOAD_SUCCESS_HAVE_NEXT  @"DOWN_LOAD_SUCCESS_HAVE_NEXT"
#define DOWN_LOAD_ERROR_HAVE_NEXT    @"DOWN_LOAD_ERROR_HAVE_NEXT"

@interface DownLoadManager : NSObject

AS_SINGLETON(DownLoadManager);

@property (nonatomic, strong) NSMutableDictionary<NSString *, AFDownloadRequestOperation *> *currentDownLoad;

- (void)startDownLoadFileWithURLString:(NSString *)urlString;

- (void)startDownLoadFileWithURLString:(NSString *)urlString
                                isNext:(BOOL)isNext;

- (void)startDownLoadFileWithURLString:(NSString *)urlString
                                isNext:(BOOL)isNext
                               isPatch:(BOOL)isPatch;

@end
