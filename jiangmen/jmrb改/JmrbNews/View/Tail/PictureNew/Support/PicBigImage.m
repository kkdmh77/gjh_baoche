//
//  MPBigImage.m
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PicBigImage.h"
#define ActivityTag    100

@interface PicBigImage ()

@end

@implementation PicBigImage
@synthesize delegate;

- (void)dealloc {
    //[readPictureView release];
    [imageURLArray release];
    [imageQueue prepareRelease];
    [imageQueue setTarget:nil];
    [imageQueue release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    imageQueue = [[ImageLoaderQueue alloc] initWithTarget:self];
//    readPictureView = [[YReadPictureView alloc] initWithFrame:self.view.bounds];
//    [readPictureView setDelegate:self];
//    [self.view addSubview:readPictureView];
    imageURLArray = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)setImageArray:(NSArray *)imageArray {
    [imageURLArray removeAllObjects];
    [imageURLArray addObjectsFromArray:imageArray];
//    [readPictureView setImageNumber:[imageArray count]];
//    [readPictureView setCurrentIndex:0];
//    [readPictureView reloadData];
}

#pragma mark - ImageQueueDelegate
//- (void)imageOperationCompleted:(UIImage *)_image atIndex:(NSInteger)_index {
//    [readPictureView setImage:_image ForIndex:_index];
//}
//
//#pragma mark - YReadPictureViewDelegate
//- (void)YReadPictureView:(YReadPictureView *)in_readPictureView requestImageForIndex:(NSInteger)in_index {
//    UIImage *image = [imageQueue getImageForURL:[imageURLArray objectAtIndex:in_index]];
//    if (image) {
//        [readPictureView setImage:image ForIndex:in_index];
//    }
//    else {
//        [imageQueue addOperationToQueueWithURL:[imageURLArray objectAtIndex:in_index] atIndex:in_index];
//    }
//}
//
//- (void)YReadPictureView:(YReadPictureView *)in_readPictureView clickImageForIndex:(NSInteger)in_index {
//    if (delegate && [delegate respondsToSelector:@selector(PicBigImageCloseBigImageView)]) {
//        [delegate PicBigImageCloseBigImageView];
//    }    
//}

@end
