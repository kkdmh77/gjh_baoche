//
//  PictureNewVC.m
//  ZhongShangPaper
//
//  Created by Danny Deng on 12-2-22.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import "PictureNewVC.h"
#import "ZSCommunicateModel.h"

@implementation PictureNewVC
@synthesize delegate;
@synthesize showView;
@synthesize btnShowModel;
@synthesize titileView;

#pragma mark - View lifecycle
- (void)dealloc {
    [_pictureShowView1 release];
    [_pictureShowView2 release];
    [super dealloc];
}

- (void)refreshPictureNews {
    [[ZSCommunicateModel defaultCommunicate] clearHotNewsList];
    [_pictureShowView1 clearPictureData];
    [_pictureShowView2 clearPictureData];
    
    NSMutableDictionary *dic = nil;
    dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:Web_getHotPictureNews forKey:Web_Key_urlString];
    [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
    [dic release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _pictureShowView1 = [[PictureShowView1VC alloc] initWithNibName:@"PictureShowView1VC" bundle:nil];
    [_pictureShowView1.view setFrame:CGRectMake(0, 0, _pictureShowView1.view.frame.size.width, _pictureShowView1.view.frame.size.height)];
    [_pictureShowView1 setDelegate:self];
    
    _pictureShowView2 = [[PictureShowView2VC alloc] initWithNibName:@"PictureShowView2VC" bundle:nil];
    [_pictureShowView2.view setFrame:CGRectMake(0, 0, _pictureShowView2.view.frame.size.width, _pictureShowView2.view.frame.size.height)];
    [_pictureShowView2 setDelegate:self];
    
    [showView addSubview:_pictureShowView1.view];
    [_pictureShowView1 setIsActive:YES];
    [_pictureShowView2 setIsActive:NO];
    
    UIImage *image = [UIImage imageNamed:@"nav_bg"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:CGRectMake(0, 0, 320, 38)];
    [self.view addSubview:imageView];
    [imageView release];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110, 6, 100, 21)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont boldSystemFontOfSize:20]];
    [label setText:@"图片新闻"];
    [self.view addSubview:label];
    [label release];
    
    UIButton *btnRefresh = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRefresh setFrame:CGRectMake(288, 5, 22, 22)];
    image = [UIImage imageNamed:@"refresh"];
    [btnRefresh setImage:image forState:UIControlStateNormal];
    image = [UIImage imageNamed:@"refresh_tapped"];
    [btnRefresh setImage:image forState:UIControlStateHighlighted];
    [self.view addSubview:btnRefresh];
    [btnRefresh addTarget:self action:@selector(refreshPictureNews) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - public
- (void)clickChangeModel:(id)sender {
    UIButton *btn  =(UIButton *)sender;
    if ([btn isSelected]) {
        [btn setSelected:NO];
        [showView addSubview:_pictureShowView1.view];
        [_pictureShowView1 setIsActive:YES];
        [_pictureShowView2 setIsActive:NO];
    }
    else {
        [btn setSelected:YES];
        [showView addSubview:_pictureShowView2.view];
        [_pictureShowView1 setIsActive:NO];
        [_pictureShowView2 setIsActive:YES];
    }
    [self refreshPictureNews];
}

#pragma mark - PictureShowViewDelegate
- (void)PictureShowViewClickNew:(NSInteger)newsId pictureNewsArray:(NSArray *)PNArray {
    if (delegate && [delegate respondsToSelector:@selector(PictureNewHideTarBar:)]) {
        [delegate PictureNewHideTarBar:YES];
    }
    PictureNewInfoDetail *pictureNewsInfo = [[PictureNewInfoDetail alloc] initWithNibName:@"PictureNewInfoDetail" bundle:nil];
    [self.navigationController pushViewController:pictureNewsInfo animated:YES];
    [pictureNewsInfo setDelegate:self];
    [pictureNewsInfo setNewsArray:PNArray];
    [pictureNewsInfo setNewsContent:newsId];
    [pictureNewsInfo initFrame];
    [pictureNewsInfo release];
}

#pragma mark - PictureNewInfoDetailDelegate
- (void)PictureNewInfoShowTarBar {
    if (delegate && [delegate respondsToSelector:@selector(PictureNewHideTarBar:)]) {
        [delegate PictureNewHideTarBar:NO];
    }
}

- (void)PictureNewInfoGoBack {
    [self.navigationController popViewControllerAnimated:YES];
}


@end



