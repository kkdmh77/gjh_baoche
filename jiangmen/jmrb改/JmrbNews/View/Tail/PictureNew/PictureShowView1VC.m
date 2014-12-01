//
//  PictureShowView1VC.m
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PictureShowView1VC.h"
#import "ZSSourceModel.h"
#import "ImageContant.h"
#import "ZSCommunicateModel.h"
#import "AppDelegate.h"

@interface PictureShowView1VC ()

- (void)refreshShowView;
- (UIImage *)createPictureImage:(UIImage *)picImage;

@end

@implementation PictureShowView1VC
@synthesize lblTitle, tvContent;
@synthesize delegate;
@synthesize isActive;

- (void)dealloc {
    [covers release];
    [titles release];
    [contents release];
    [imageQueue prepareRelease];
    [imageQueue setTarget:nil];
    [imageQueue release];
    [_pictureNewsArray release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    whichItem = 0;
    imageQueue = [[ImageLoaderQueue alloc] initWithTarget:self];
    [self.tvContent setEditable:NO];
    _pictureNewsArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self performSelector:@selector(refreshShowView) withObject:nil afterDelay:.1];
    //    [self refreshShowView];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate startLoading];
    
//    _openFlowView = [[OpenFlowView alloc] initWithFrame:CGRectMake(0, 70, 320, 400)];
//    [_openFlowView setGestureMoveMultiple:2];
//    [_openFlowView setImageFrameColor:[UIColor colorWithWhite:1 alpha:.3]];
//    [_openFlowView setImageWidth:270 imageHeight:180];
//    [_openFlowView setCurrentIndex:0];
//    [_openFlowView setImageHaveFrame:YES];
//    [_openFlowView setDistanceBetweenImages:250];
//    [_openFlowView setClipsToBounds:YES];
//    [_openFlowView setImageBgParametersHaveBg:YES showImageBgAll:NO DistanceBetweenImageWithBg:10 imageBgLight:.5];
//    [self.view addSubview:_openFlowView];
//    [_openFlowView setDelegate:self];
    
    urlDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshShowView) name:Notification_getHotPictureNews object:nil];
}

#pragma mark - Public
- (void)clearPictureData {
//    if (_openFlowView) {
//        [_openFlowView setCurrentIndex:0];
//        [_openFlowView setImagesNumber:0];
//    }
    if (_pictureNewsArray) {
        [_pictureNewsArray removeAllObjects];
    }
    whichItem = 0;
}

#pragma mark - Private
- (UIImage *)createPictureImage:(UIImage *)picImage {
    CGFloat imageWidth = 300; 
    UIGraphicsBeginImageContext(CGSizeMake(imageWidth, imageWidth));
    CGSize size = picImage.size;
    CGFloat souXiao=1;
    if (size.width>size.height) {
        if (size.width>imageWidth) {
            souXiao = size.width/imageWidth;
        }
    }
    else {
        if (size.height>imageWidth) {
            souXiao = size.height/imageWidth;
        }
    }
    size.width = size.width/souXiao;
    size.height = size.height/souXiao;
    [picImage drawInRect:CGRectMake((imageWidth-size.width)/2, (imageWidth-size.height)/2, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)refreshShowView {
    @synchronized ([PictureShowView1VC class]) {
        if (!_pictureNewsArray) {
            return;
        }
        requestNum = 0;
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate stopLoading];
        if ([_pictureNewsArray count] == [[[ZSSourceModel defaultSource] hotPictureDic] count]) {
            return;
        }
        [_pictureNewsArray removeAllObjects];
        [_pictureNewsArray addObjectsFromArray:[[ZSSourceModel defaultSource] hotPictureDic]];
        if ([_pictureNewsArray count] == 0) {
            return;
        }
        if (covers) {
            [covers removeAllObjects];
        }
        else {
            covers = [[NSMutableArray alloc] init];
        }
        
        if (titles) {
            [titles removeAllObjects];
        }
        else {
            titles = [[NSMutableArray alloc] init];
        }
        
        if (contents) {
            [contents removeAllObjects];
        }
        else {
            contents = [[NSMutableArray alloc] init];
        }
        for (int i = 0; i < [_pictureNewsArray count]; i++) {
            NSDictionary *itemDic = [_pictureNewsArray objectAtIndex:i];
            NSString *urlString = [itemDic objectForKey:@"newsIcon_t"];
            [urlDic setObject:urlString forKey:[NSString stringWithFormat:@"%i",i]];
            UIImage *image = [imageQueue getImageForURL:urlString];
            if (image) {
                [covers addObject:image];
            }
            else {
                image = [UIImage imageByName:@"home_image_loading" withExtend:@"png"];
                [imageQueue addOperationToQueueWithURL:urlString atIndex:i];
                [covers addObject:image];
            }
            NSString *titleItemString = [itemDic objectForKey:@"newsTitle"];
            NSString *contentItemString = [itemDic objectForKey:@"news_synopsis"];
            if ([titleItemString isKindOfClass:[NSString class]] && titleItemString && [titleItemString length] > 0) {
                [titles addObject:titleItemString];
            }
            else {
                [titles addObject:@""];
            }
            if ([contentItemString isKindOfClass:[NSString class]] && contentItemString && [contentItemString length] > 0) {
                [contents addObject:contentItemString];
            }
            else {
                [contents addObject:@""];
            }
        }
        
//        [_openFlowView setImagesNumber:[_pictureNewsArray count]];
//        [_openFlowView reloadData];
        
        [self.lblTitle setText:[titles objectAtIndex:whichItem]];
        [self.tvContent setText:[contents objectAtIndex:whichItem]];
        
        [self.view addSubview:lblTitle];
        [self.view addSubview:tvContent];
        isLoading = NO;
    }
}

#pragma mark - ImageLoaderQueueDelegate
- (void)imageOperationWrongImagePath:(NSInteger)_index {
    if (_index < [_pictureNewsArray count]) {
        NSDictionary *itemDic = [_pictureNewsArray objectAtIndex:_index];
        NSString *urlString = [itemDic objectForKey:@"newsIcon"];
        NSString *oldUrlString = [urlDic objectForKey:[NSString stringWithFormat:@"%i",_index]];
        if (oldUrlString != nil && ![oldUrlString isEqualToString:urlString]) {
            [urlDic setObject:urlString forKey:[NSString stringWithFormat:@"%i",_index]];
            UIImage *image = [imageQueue getImageForURL:urlString];
            if (image) {
                [covers replaceObjectAtIndex:_index withObject:image];
            }
            else {
                [imageQueue addOperationToQueueWithURL:urlString atIndex:_index];
            }
        }
    }
}

- (void)imageOperationCompleted:(UIImage *)_image atIndex:(NSInteger)_index {
    @synchronized ([PictureShowView1VC class]) {
        if (_index < [covers count]) {
            [covers replaceObjectAtIndex:_index withObject:_image];   
            //[_openFlowView setIndexImage:_image forIndex:_index];
        }
    }
}

#pragma mark - OpenFlowDelegate 
//- (void)openFlowView:(OpenFlowView *) in_openFlowView singleClickIndex:(NSInteger) in_Index {
//    NSDictionary *itemDic = [_pictureNewsArray objectAtIndex:whichItem];
//    NSInteger newsId = [[itemDic objectForKey:@"newsId"] intValue];
//    if (delegate && [delegate respondsToSelector:@selector(PictureShowViewClickNew:pictureNewsArray:)]) {
//        [delegate PictureShowViewClickNew:newsId pictureNewsArray:_pictureNewsArray];
//    }
//}
//
//- (void)openFlowView:(OpenFlowView *)in_OpenFlowView SelectedDidChange:(NSInteger)in_Index {
//    whichItem = in_Index;
//    [self.lblTitle setText:[titles objectAtIndex:in_Index]];
//    [self.tvContent setText:[contents objectAtIndex:in_Index]];
//    if (in_Index == [_pictureNewsArray count]-1) {
//        if (isLoading) {
//            return;
//        }
//        isLoading = YES;
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
//        [dic setObject:Web_getHotPictureNews forKey:Web_Key_urlString];
//        [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
//        [dic release];
//    }
//}
//
//- (void)openFlowView:(OpenFlowView *) in_OpenFlowView requestImageForIndex:(NSInteger) in_Index {
//    UIImage *whichImg = [covers objectAtIndex:in_Index];
//    if (whichImg == nil) {
//        whichImg = [UIImage imageByName:@"home_image_loading" withExtend:@"png"];
//    }
//    [_openFlowView setIndexImage:whichImg forIndex:in_Index];
//}

@end




