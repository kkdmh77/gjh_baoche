//
//  PictureShowView2VC.m
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define btnTag  1000
#define PSV2CellTag  10000

#import "PictureShowView2VC.h"
#import "ZSSourceModel.h"
#import "ImageContant.h"
#import "ZSCommunicateModel.h"
#import "AppDelegate.h"

@interface PictureShowView2VC ()

- (void)refreshShowView;
- (void)clickPSV2Cell:(UIButton *)btn;

@end

@implementation PictureShowView2VC
@synthesize showScrollView;
@synthesize delegate;
@synthesize isActive;

- (void)dealloc {
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
    _pictureNewsArray = [[NSMutableArray alloc] init];
    imageQueue = [[ImageLoaderQueue alloc] initWithTarget:self];
    [showScrollView setDelegate:self];
    [self performSelector:@selector(refreshShowView) withObject:nil afterDelay:.1];
    //    [self refreshShowView];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate startLoading];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshShowView) name:Notification_getHotPictureNews object:nil];
}

#pragma mark - Public
- (void)clearPictureData {
    if (showScrollView) {
        [showScrollView scrollRectToVisible:CGRectMake(0, 0, 320, 480) animated:NO];
    }
}

#pragma mark - Private
- (void)clickPSV2Cell:(UIButton *)btn {
    NSDictionary *itemDic = [_pictureNewsArray objectAtIndex:btn.tag-btnTag];
    NSInteger newsId = [[itemDic objectForKey:@"newsId"] intValue];
    if (delegate && [delegate respondsToSelector:@selector(PictureShowViewClickNew:pictureNewsArray:)]) {
        [delegate PictureShowViewClickNew:newsId pictureNewsArray:_pictureNewsArray];
    }
}

- (void)refreshShowView {
    @synchronized ([PictureShowView2VC class]) {
        if (!isActive) {
            return;
        }
        if (!_pictureNewsArray) {
            return;
        }
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate stopLoading];
        NSInteger oldImageCount = [_pictureNewsArray count];
        NSInteger cellBetweenWidth = 20;
        NSInteger cellBetweenHeight = 20;
        CGSize size = CGSizeMake(130, 130);
        [_pictureNewsArray removeAllObjects];
        [_pictureNewsArray addObjectsFromArray:[[ZSSourceModel defaultSource] hotPictureDic]];
        if ([_pictureNewsArray count] == 0) {
            return;
        }
        for (int i = oldImageCount; i < [_pictureNewsArray count]; i++) {
            @try{
            NSDictionary *itemDic = [_pictureNewsArray objectAtIndex:i];
            NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@",[itemDic objectForKey:@"newsIcon"]];
            UIImage *image = nil;
            image = [imageQueue getImageForURL:urlString];
            [urlString appendFormat:@"?%f", 1000*[[NSDate date] timeIntervalSince1970]];
            if (image == nil) {
                image = [UIImage imageByName:@"home_image_loading" withExtend:@"png"];
                [imageQueue addOperationToQueueWithURL:urlString atIndex:i];
            }
            PSV2Cell *cell = [[PSV2Cell alloc] initWithNibName:@"PSV2Cell" bundle:nil];
            size = cell.view.frame.size;
            [cell.view setFrame:CGRectMake(cellBetweenWidth + i%2*(cellBetweenWidth+size.width), cellBetweenHeight + i/2*(cellBetweenHeight+size.height), size.width, size.height)];
            [cell.lblTitle setText:[itemDic objectForKey:@"newsTitle"]];
            [cell setImage:image];
            [cell.view setTag:i+PSV2CellTag];
            [showScrollView addSubview:cell.view];
            [cell release];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(cellBetweenWidth + i%2*(cellBetweenWidth+size.width), cellBetweenHeight + i/2*(cellBetweenHeight+size.height), size.width, size.height)];
            [btn setTag:btnTag+i];
            [btn addTarget:self action:@selector(clickPSV2Cell:) forControlEvents:UIControlEventTouchUpInside];
            [showScrollView addSubview:btn];
            }@catch (NSException * e){}
        }
        [showScrollView setContentSize:CGSizeMake(320, cellBetweenHeight+size.height + ([_pictureNewsArray count]-1)/2*(cellBetweenHeight+size.height) + 50)];
        CGSize contentSize = [showScrollView contentSize];
        if (contentSize.height < 480) {
            [showScrollView setContentSize:CGSizeMake(320, 480)];
        }
        isLoading = NO;
    }
}

#pragma mark - ImageLoaderQueueDelegate
- (void)imageOperationCompleted:(UIImage *)_image atIndex:(NSInteger)_index {
    if (_index > [_pictureNewsArray count] - 1) {
        return ;
    }
    //删除某个元素
    UIView *view = [showScrollView viewWithTag:_index+PSV2CellTag];
    [view removeFromSuperview];
    //删除某个元素前面的按钮
    view = [showScrollView viewWithTag:_index+btnTag];
    [view removeFromSuperview];
    
    NSInteger cellBetweenWidth = 20;
    NSInteger cellBetweenHeight = 20;
    NSDictionary *itemDic = [_pictureNewsArray objectAtIndex:_index];
    PSV2Cell *cell = [[PSV2Cell alloc] initWithNibName:@"PSV2Cell" bundle:nil];
    CGSize size = cell.view.frame.size;
    [cell.view setFrame:CGRectMake(cellBetweenWidth + _index%2*(cellBetweenWidth+size.width), cellBetweenHeight + _index/2*(cellBetweenHeight+size.height), size.width, size.height)];
    [cell.lblTitle setText:[itemDic objectForKey:@"newsTitle"]];
    [cell setImage:_image];
    [cell.view setTag:_index+PSV2CellTag];
    [showScrollView addSubview:cell.view];
    [cell release];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(cellBetweenWidth + _index%2*(cellBetweenWidth+size.width), cellBetweenHeight + _index/2*(cellBetweenHeight+size.height), size.width, size.height)];
    [btn setTag:btnTag+_index];
    [btn addTarget:self action:@selector(clickPSV2Cell:) forControlEvents:UIControlEventTouchUpInside];
    [showScrollView addSubview:btn];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isLoading) {
        return;
    }
    CGPoint point = [scrollView contentOffset];
    if (point.y > scrollView.contentSize.height - scrollView.frame.size.height) {
        isLoading = YES;
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
        [dic setObject:Web_getHotPictureNews forKey:Web_Key_urlString];
        [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
        [dic release];    
    }
}

@end
