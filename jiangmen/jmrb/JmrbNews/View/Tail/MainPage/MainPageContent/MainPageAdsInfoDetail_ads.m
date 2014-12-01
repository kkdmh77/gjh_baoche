//
//  MainPageNewInfoDetail.m
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-13.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import "MainPageAdsInfoDetail.h"
#import "YungShareManager.h"
#import "MPDiscussVC.h"

@interface MainPageAdsInfoDetail ()

- (void)goBack;

@end

@implementation MainPageAdsInfoDetail
@synthesize fontSlider, fontSlider1;
@synthesize delegate;
@synthesize fullTopView, fullTailView, halfTopView, halfTailView;
@synthesize newsTitle;
@synthesize newsArray;
@synthesize btnNext, btnNext1, btnPre, btnPre1;

- (void)dealloc {
    [_infoContent release];
    [self setNewsArray:nil];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    currentNewItem = 0;
//    UISwipeGestureRecognizer *swipGestureNext = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(clickNextNews:)];
//    [swipGestureNext setDirection:UISwipeGestureRecognizerDirectionLeft];
//    [self.view addGestureRecognizer:swipGestureNext];
//    [swipGestureNext release];
//    
//    UISwipeGestureRecognizer *swipGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(clickPreNews:)];
//    [swipGestureLeft setDirection:UISwipeGestureRecognizerDirectionRight];
//    [self.view addGestureRecognizer:swipGestureLeft];
//    [swipGestureLeft release];
}

#pragma mark - Private
- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Xib function
- (IBAction)dragSlider:(id)sender {
    UISlider *slider = (UISlider *)sender;
    [fontSlider setValue:slider.value];
    [fontSlider1 setValue:slider.value];
    NSInteger newFontSize = slider.value*2+15;
    if (fontSize != newFontSize) {
        fontSize = newFontSize;
        [_infoContent setTextViewFontSize:fontSize];
    }
}

- (IBAction)clickBack:(id)sender {
    if (delegate && [delegate respondsToSelector:@selector(MainPageAdsInfoDetailGoBack)]) {
        [delegate MainPageAdsInfoDetailGoBack];
    }
    [self goBack];
}

- (IBAction)clickFullScreen:(id)sender {
    [UIView animateWithDuration:.5 animations:^{
        [fullTopView setFrame:CGRectMake(0, 0, 320, 44)];
        [fullTailView setFrame:CGRectMake(0, 480-44, 320, 44)];
        [halfTopView setFrame:CGRectMake(0, -44, 320, 44)];
        [halfTailView setFrame:CGRectMake(0, 480, 320, 44)];
    }completion:^(BOOL finish) {
        
    }];
}

- (IBAction)clickHalfScreen:(id)sender {
    [UIView animateWithDuration:.5 animations:^{
        [fullTopView setFrame:CGRectMake(0, -44, 320, 44)];
        [fullTailView setFrame:CGRectMake(0, 480, 320, 44)];
        [halfTopView setFrame:CGRectMake(0, 0, 320, 44)];
        [halfTailView setFrame:CGRectMake(0, 480-44, 320, 44)];
    }completion:^(BOOL finish) {
        
    }];
}

- (IBAction)clickNextNews:(id)sender {
    if (currentNewItem == [newsArray count]-1) {
        return;
    }
    currentNewItem++;
    NSDictionary *itemDic = [newsArray objectAtIndex:currentNewItem];
    NSInteger item = [[itemDic objectForKey:@"ad_id"] intValue];
    MPAdsInfoDetailContent *infoContent = [[MPAdsInfoDetailContent alloc] initWithNibName:@"MPAdsInfoDetailContent" bundle:nil];
    [infoContent.view setCenter:CGPointMake(480, 240)];
    [self.view addSubview:infoContent.view];
    [self.view addSubview:fullTopView];
    [self.view addSubview:fullTailView];
    [self.view addSubview:halfTopView];
    [self.view addSubview:halfTailView];
    [infoContent setItemId:item];
    [infoContent loadNewsContent:item];
    [btnPre setEnabled:NO];
    [btnPre1 setEnabled:NO];
    [btnNext setEnabled:NO];
    [btnNext1 setEnabled:NO];
    [UIView animateWithDuration:.3 animations:^{
        [_infoContent.view setCenter:CGPointMake(-160, 240)];
        [infoContent.view setCenter:CGPointMake(160, 240)];
    }completion:^(BOOL finish) {
        [_infoContent.view removeFromSuperview];
        [_infoContent release];
        _infoContent = infoContent;
        if (currentNewItem == [newsArray count]-1) {
            [btnNext1 setEnabled:NO];
            [btnNext setEnabled:NO];
        }
        else {
            [btnNext1 setEnabled:YES];
            [btnNext setEnabled:YES];
            
        }
        if (currentNewItem == 0) {
            [btnPre1 setEnabled:NO];
            [btnPre setEnabled:NO];
        }
        else {
            [btnPre1 setEnabled:YES];
            [btnPre setEnabled:YES];
        }
    }];
}

- (IBAction)clickPreNews:(id)sender {
    if (currentNewItem == 0) {
        return;
    }
    currentNewItem--;
    NSDictionary *itemDic = [newsArray objectAtIndex:currentNewItem];
    NSInteger item = [[itemDic objectForKey:@"ad_id"] intValue];
    MPAdsInfoDetailContent *infoContent = [[MPAdsInfoDetailContent alloc] initWithNibName:@"MPAdsInfoDetailContent" bundle:nil];
    [infoContent.view setCenter:CGPointMake(-160, 240)];
    [self.view addSubview:infoContent.view];
    [self.view addSubview:fullTopView];
    [self.view addSubview:fullTailView];
    [self.view addSubview:halfTopView];
    [self.view addSubview:halfTailView];
    [infoContent setItemId:item];
    [infoContent loadNewsContent:item];
    [btnPre setEnabled:NO];
    [btnPre1 setEnabled:NO];
    [btnNext setEnabled:NO];
    [btnNext1 setEnabled:NO];
    [UIView animateWithDuration:.3 animations:^{
        [_infoContent.view setCenter:CGPointMake(480, 240)];
        [infoContent.view setCenter:CGPointMake(160, 240)];
    }completion:^(BOOL finish) {
        [_infoContent.view removeFromSuperview];
        [_infoContent release];
        _infoContent = infoContent;
        if (currentNewItem == [newsArray count]-1) {
            [btnNext1 setEnabled:NO];
            [btnNext setEnabled:NO];
        }
        else {
            [btnNext1 setEnabled:YES];
            [btnNext setEnabled:YES];
            
        }
        if (currentNewItem == 0) {
            [btnPre1 setEnabled:NO];
            [btnPre setEnabled:NO];
        }
        else {
            [btnPre1 setEnabled:YES];
            [btnPre setEnabled:YES];
        }
    }];
}

- (IBAction)clickShare:(id)sender {
    YungShareManager *shareVC = [YungShareManager defaultShare];
    [shareVC shareImage:@"我找到一个很好用的中山新闻哟" Image:nil];
}

- (IBAction)clickDiscuss:(id)sender {
//    MPDiscussVC *discuss = [[MPDiscussVC alloc] initWithNibName:@"MPDiscussVC" bundle:nil];
//    [self.navigationController pushViewController:discuss animated:YES];
//    NSDictionary *itemDic = [newsArray objectAtIndex:currentNewItem];
//    NSInteger item = [[itemDic objectForKey:@"newsId"] intValue];
//    [discuss setNewsIdDiscuss:item];
//    [discuss release];
}

#pragma mark - Public
- (void)initFrame {
    NSNumber *readModel = [[NSUserDefaults standardUserDefaults] objectForKey:More_ReadModel];
    if ([readModel boolValue]) {
        [fullTopView setFrame:CGRectMake(0, 0, 320, 44)];
        [fullTailView setFrame:CGRectMake(0, 480-44, 320, 44)];
        [halfTopView setFrame:CGRectMake(0, -44, 320, 44)];
        [halfTailView setFrame:CGRectMake(0, 480, 320, 44)];
    }
    else {
        [fullTopView setFrame:CGRectMake(0, -44, 320, 44)];
        [fullTailView setFrame:CGRectMake(0, 480, 320, 44)];
        [halfTopView setFrame:CGRectMake(0, 0, 320, 44)];
        [halfTailView setFrame:CGRectMake(0, 480-44, 320, 44)];
    }
}

- (void)setNewsContent:(NSInteger ) itemId {
    if (_infoContent) {
        [_infoContent.view removeFromSuperview];
        [_infoContent release];
    }
    _infoContent = [[MPAdsInfoDetailContent alloc] initWithNibName:@"MPAdsInfoDetailContent" bundle:nil];
    [_infoContent setItemId:itemId];
    [self.view addSubview:_infoContent.view];
    [self.view addSubview:fullTopView];
    [self.view addSubview:fullTailView];
    [self.view addSubview:halfTopView];
    [self.view addSubview:halfTailView];
    [_infoContent loadNewsContent:itemId];
    for (int i = 0 ; i < [newsArray count]; i++) {
        NSDictionary *itemDic = [newsArray objectAtIndex:i];
        NSInteger item = [[itemDic objectForKey:@"ad_id"] intValue];
        if (item == itemId) {
            currentNewItem = i;
            break;
        }
    }
    if (currentNewItem == [newsArray count]-1) {
        [btnNext1 setEnabled:NO];
        [btnNext setEnabled:NO];
    }
    if (currentNewItem == 0) {
        [btnPre1 setEnabled:NO];
        [btnPre setEnabled:NO];
    }
}
@end
