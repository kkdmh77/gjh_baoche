//
//  MainPageNewInfoDetail.m
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-13.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import "PictureNewInfoDetail.h"
#import "YungShareManager.h"
#import "PSDiscussVC.h"
#import "ZSSourceModel.h"
#import "MPDiscussVC.h"

@interface PictureNewInfoDetail ()

- (void)goBack;
- (void)refreshKeep;

@end

@implementation PictureNewInfoDetail
@synthesize btnKeep, btnKeep1;
@synthesize delegate;
@synthesize fullTopView, fullTailView, halfTopView, halfTailView;
@synthesize newsTitle,replayNumText;
@synthesize btnNext, btnNext1, btnPre, btnPre1;
@synthesize newsArray;
@synthesize fontSlider, fontSlider1;

- (void)dealloc {
    [self setNewsArray:nil];
    [_infoContent release];
    [_infoContent1 release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setHidesBottomBarWhenPushed:YES];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
//    NSNumber *readModel = [[NSUserDefaults standardUserDefaults] objectForKey:More_ReadModel];
//    if ([readModel boolValue]) {
//        [fullTopView setFrame:CGRectMake(0, 0, 320, 38)];
//        [fullTailView setFrame:CGRectMake(0, 480-38, 320, 38)];
//        [halfTopView setFrame:CGRectMake(0, -38, 320, 38)];
//        [halfTailView setFrame:CGRectMake(0, 480, 320, 38)];
//    }
//    else {
//        [fullTopView setFrame:CGRectMake(0, -38, 320, 38)];
//        [fullTailView setFrame:CGRectMake(0, 480, 320, 38)];
//        [halfTopView setFrame:CGRectMake(0, 0, 320, 38)];
//        [halfTailView setFrame:CGRectMake(0, 480-38, 320, 38)];
//    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    currentNewItem = 0;
    UISwipeGestureRecognizer *swipGestureNext = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(clickNextNews:)];
    [swipGestureNext setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipGestureNext];
    [swipGestureNext release];
    
    UISwipeGestureRecognizer *swipGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(clickPreNews:)];
    [swipGestureLeft setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipGestureLeft];
    [swipGestureLeft release];   
}

#pragma mark - Private
- (void)refreshKeep {
    NSDictionary *itemDic = [newsArray objectAtIndex:currentNewItem];
    NSInteger itemId = [[itemDic objectForKey:@"newsId"] intValue];
    NSMutableArray *keepArray = [[ZSSourceModel defaultSource] KeepArray];
    if (keepArray == nil) {
        keepArray = [NSMutableArray arrayWithCapacity:0];
    }
    [btnKeep setSelected:NO];
    [btnKeep1 setSelected:NO];
    for (int i = 0; i < [keepArray count]; i++) {
        NSMutableDictionary *dic = [keepArray objectAtIndex:i];
        NSInteger item_id = [[dic objectForKey:@"newsId"] intValue];
        if (item_id == itemId) {
            [btnKeep setSelected:YES];
            [btnKeep1 setSelected:YES];
            break;
        }
    }    
}

- (void)goBack{
    if (delegate && [delegate respondsToSelector:@selector(PictureNewInfoShowTarBar)]) {
        [delegate PictureNewInfoShowTarBar];
    }
    if (delegate && [delegate respondsToSelector:@selector(PictureNewInfoGoBack)]) {
        [delegate PictureNewInfoGoBack];
    }
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
    [_infoContent clearWebViewContent];
    [_infoContent1 clearWebViewContent];
    [self goBack];
}

- (IBAction)clickFullScreen:(id)sender {
    [UIView animateWithDuration:.5 animations:^{
        [fullTopView setFrame:CGRectMake(0, 0, 320, 38)];
        [fullTailView setFrame:CGRectMake(0, self.view.frame.size.height-38, 320, 38)];
        [halfTopView setFrame:CGRectMake(0, -38, 320, 38)];
        [halfTailView setFrame:CGRectMake(0, self.view.frame.size.height, 320, 38)];
    }completion:^(BOOL finish) {
        
    }];
}

- (IBAction)clickHalfScreen:(id)sender {
    [UIView animateWithDuration:.5 animations:^{
        [fullTopView setFrame:CGRectMake(0, -38, 320, 38)];
        [fullTailView setFrame:CGRectMake(0, self.view.frame.size.height, 320, 38)];
        [halfTopView setFrame:CGRectMake(0, 0, 320, 38)];
        [halfTailView setFrame:CGRectMake(0, self.view.frame.size.height-38, 320, 38)];
    }completion:^(BOOL finish) {
        
    }];
}

- (IBAction)clickNextNews:(id)sender {
    if (currentNewItem == [newsArray count]-1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"已经是最后一页" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    currentNewItem++;
    NSDictionary *itemDic = [newsArray objectAtIndex:currentNewItem];
    NSInteger item = [[itemDic objectForKey:@"newsId"] intValue];
    if (iPhone5) {
        [_infoContent1.view setCenter:CGPointMake(568, 284)];
    }else{
        [_infoContent1.view setCenter:CGPointMake(480, 240)];
    }
    //[_infoContent1.view setCenter:CGPointMake(480, 240)];
    [self.view addSubview:_infoContent1.view];
    [self.view addSubview:fullTopView];
    [self.view addSubview:fullTailView];
    [self.view addSubview:halfTopView];
    [self.view addSubview:halfTailView];
    
    [btnPre setEnabled:NO];
    [btnPre1 setEnabled:NO];
    [btnNext setEnabled:NO];
    [btnNext1 setEnabled:NO];
    [UIView animateWithDuration:.3 animations:^{
        if (iPhone5) {
            [_infoContent.view setCenter:CGPointMake(-160, 284)];
            [_infoContent1.view setCenter:CGPointMake(160, 284)];
        }else{
            [_infoContent.view setCenter:CGPointMake(-160, 240)];
            [_infoContent1.view setCenter:CGPointMake(160, 240)];
        }
//        [_infoContent.view setCenter:CGPointMake(-160, 240)];
//        [_infoContent1.view setCenter:CGPointMake(160, 240)];
    }completion:^(BOOL finish) {
        MPNewInfoDetailContent *infoContent = _infoContent;
        _infoContent = _infoContent1;
        _infoContent1 = infoContent;
        [_infoContent setIsNeedLoad:YES];
        [_infoContent1 setIsNeedLoad:NO];
        [_infoContent1 clearWebViewContent];
        [_infoContent setItemId:item];
        [_infoContent loadNewsContent:item];
        [replayNumText setText:[[itemDic objectForKey:@"commCount"] stringValue]];
        if ([_infoContent isEqual:_infoContent1]) {
            NSLog(@"isEqual");
        }
        [btnPre setEnabled:YES];
        [btnPre1 setEnabled:YES];
        [btnNext setEnabled:YES];
        [btnNext1 setEnabled:YES];
    }];
    [self refreshKeep];
}

- (IBAction)clickPreNews:(id)sender {
    if (currentNewItem == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"已经是第一页" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    currentNewItem--;
    NSDictionary *itemDic = [newsArray objectAtIndex:currentNewItem];
    NSInteger item = [[itemDic objectForKey:@"newsId"] intValue];
    if (iPhone5) {
        [_infoContent1.view setCenter:CGPointMake(-160, 284)];
    }else{
        [_infoContent1.view setCenter:CGPointMake(-160, 240)];
    }
    //[_infoContent1.view setCenter:CGPointMake(-160, 240)];
    [self.view addSubview:_infoContent1.view];
    [self.view addSubview:fullTopView];
    [self.view addSubview:fullTailView];
    [self.view addSubview:halfTopView];
    [self.view addSubview:halfTailView];
    
    [btnPre setEnabled:NO];
    [btnPre1 setEnabled:NO];
    [btnNext setEnabled:NO];
    [btnNext1 setEnabled:NO];
    [UIView animateWithDuration:.3 animations:^{
        if (iPhone5) {
            [_infoContent.view setCenter:CGPointMake(568, 284)];
            [_infoContent1.view setCenter:CGPointMake(160, 284)];
        }else{
            [_infoContent.view setCenter:CGPointMake(480, 240)];
            [_infoContent1.view setCenter:CGPointMake(160, 240)];
        }
//        [_infoContent.view setCenter:CGPointMake(480, 240)];
//        [_infoContent1.view setCenter:CGPointMake(160, 240)];
    }completion:^(BOOL finish) {
        MPNewInfoDetailContent *infoContent = _infoContent;
        _infoContent = _infoContent1;
        _infoContent1 = infoContent;
        [_infoContent setIsNeedLoad:YES];
        [_infoContent1 setIsNeedLoad:NO];
        [_infoContent1 clearWebViewContent];
        [_infoContent setItemId:item];
        [_infoContent loadNewsContent:item];
        [replayNumText setText:[[itemDic objectForKey:@"commCount"] stringValue]];
        [btnPre setEnabled:YES];
        [btnPre1 setEnabled:YES];
        [btnNext setEnabled:YES];
        [btnNext1 setEnabled:YES];
    }];
    [self refreshKeep];
}

- (IBAction)clickShare:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享到新浪微博", nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

- (IBAction)clickDiscuss:(id)sender {
    MPDiscussVC *discuss = [[MPDiscussVC alloc] initWithNibName:@"MPDiscussVC" bundle:nil];
    [self.navigationController pushViewController:discuss animated:YES];
    NSDictionary *itemDic = [newsArray objectAtIndex:currentNewItem];
    NSInteger item = [[itemDic objectForKey:@"newsId"] intValue];
    [discuss setNewsIdDiscuss:item];
    
    [discuss release];

}

- (IBAction)clickDiscussSend:(id)sender {
    MPDiscussVC *discuss = [[MPDiscussVC alloc] initWithNibName:@"MPDiscussVC" bundle:nil];
    [self.navigationController pushViewController:discuss animated:YES];
    NSDictionary *itemDic = [newsArray objectAtIndex:currentNewItem];
    NSInteger item = [[itemDic objectForKey:@"newsId"] intValue];
    [discuss setNewsIdDiscuss:item];
    [discuss otherDiscuss];
    [discuss release];
    
}


- (IBAction)clickKeep:(id)sender {
    if (newsArray == nil) {
        return;
    }
    NSMutableArray *keepArray = [[ZSSourceModel defaultSource] KeepArray];
    NSMutableDictionary *newKeepDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSDictionary *itemDic = [newsArray objectAtIndex:currentNewItem];
    if (itemDic == nil) {
        return;
    }
    NSInteger itemId = [[itemDic objectForKey:@"newsId"] intValue];
    if (keepArray == nil) {
        keepArray = [NSMutableArray arrayWithCapacity:0];
    }
    for (int i = 0; i < [keepArray count]; i++) {
        NSMutableDictionary *dic = [keepArray objectAtIndex:i];
        NSInteger item_id = [[dic objectForKey:@"newsId"] intValue];
        if (item_id == itemId) {
            [keepArray removeObjectAtIndex:i];
            [btnKeep setSelected:NO];
            [btnKeep1 setSelected:NO];
            return;
        }
    }
    NSMutableArray *newsPictureArray = [[ZSSourceModel defaultSource] hotPictureDic];
    NSMutableDictionary *newsdataDic = nil;
    for (int i = 0; i < [newsPictureArray count]; i++) {
        newsdataDic = [newsPictureArray objectAtIndex:i];
        NSInteger newsId = [[newsdataDic objectForKey:@"newsId"] intValue];
        if (newsId == itemId) {
            [newKeepDic setObject:[NSString stringWithFormat:@"%i",itemId] forKey:@"newsId"];
            [newKeepDic setObject:[newsdataDic objectForKey:@"newsTitle"] forKey:@"newsTitle"];
            [keepArray insertObject:newKeepDic atIndex:0];
            [[ZSSourceModel defaultSource] setKeepArray:keepArray];
            [btnKeep setSelected:YES];
            [btnKeep1 setSelected:YES];
            break;
        }
    }
}

#pragma mark - Public
- (void)setNewsContent:(NSInteger ) itemId {
    NSMutableArray *keepArray = [[ZSSourceModel defaultSource] KeepArray];
    if (keepArray == nil) {
        keepArray = [NSMutableArray arrayWithCapacity:0];
    }
    [btnKeep setSelected:NO];
    [btnKeep1 setSelected:NO];
    for (int i = 0; i < [keepArray count]; i++) {
        NSMutableDictionary *dic = [keepArray objectAtIndex:i];
        NSInteger item_id = [[dic objectForKey:@"newsId"] intValue];
        if (item_id == itemId) {
            [btnKeep setSelected:YES];
            [btnKeep1 setSelected:YES];
            break;
        }
    }
    if (_infoContent1) {
        [_infoContent1.view removeFromSuperview];
        [_infoContent1 release];
    }
    _infoContent1 = [[MPNewInfoDetailContent alloc] initWithNibName:@"PictureNewInfoDetailContent" bundle:nil];
    if (iPhone5) {
        [_infoContent1.view setFrame:CGRectMake(0, -50, 320, 568)];
    }
    if (iPhone5) {
        [_infoContent1.view setCenter:CGPointMake(-160, 284)];
    }else{
        [_infoContent1.view setCenter:CGPointMake(-160, 240)];
    }
    //[_infoContent1.view setCenter:CGPointMake(-160, 240)];
    
    if (_infoContent) {
        [_infoContent.view removeFromSuperview];
        [_infoContent release];
    }
    _infoContent = [[MPNewInfoDetailContent alloc] initWithNibName:@"PictureNewInfoDetailContent" bundle:nil];
    if (iPhone5) {
        [_infoContent.view setFrame:CGRectMake(0, -50, 320, 568)];
    }
    [_infoContent setItemId:itemId];
    
    [self.view addSubview:_infoContent.view];
    [self.view addSubview:fullTopView];
    [self.view addSubview:fullTailView];
    [self.view addSubview:halfTopView];
    [self.view addSubview:halfTailView];
    [_infoContent loadNewsContent:itemId];
    for (int i = 0 ; i < [newsArray count]; i++) {
        NSDictionary *itemDic = [newsArray objectAtIndex:i];
        NSInteger item = [[itemDic objectForKey:@"newsId"] intValue];
        if (item == itemId) {
            [replayNumText setText:[[itemDic objectForKey:@"commCount"] stringValue]];
            currentNewItem = i;
            break;
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSMutableDictionary *newsdataDic = [[ZSSourceModel defaultSource] newsDataDic];
    NSDictionary *myItemDic = [newsArray objectAtIndex:currentNewItem];
    if (myItemDic == nil) {
        return;
    }
    NSDictionary *allDic = newsdataDic;
    NSString *summaryString = [allDic objectForKey:@"newsAbstract"];
    NSString *urlString = [allDic objectForKey:@"newsUrl"];
    if (![urlString isKindOfClass:[NSString class]]) {
        urlString = @"";
    }
    YungShareManager *shareVC = [YungShareManager defaultShare];
    [shareVC shareImage:[NSString stringWithFormat:@"%@%@",summaryString,urlString] Image:nil];
}

- (void)initFrame {
    NSNumber *readModel = [[NSUserDefaults standardUserDefaults] objectForKey:More_ReadModel];
    if ([readModel boolValue]) {
        [fullTopView setFrame:CGRectMake(0, 0, 320, 38)];
        [fullTailView setFrame:CGRectMake(0, 480-38, 320, 38)];
        [halfTopView setFrame:CGRectMake(0, -38, 320, 38)];
        [halfTailView setFrame:CGRectMake(0, 480, 320, 38)];
    }
    else {
        [fullTopView setFrame:CGRectMake(0, -38, 320, 38)];
        //[fullTailView setFrame:CGRectMake(0, 480, 320, 38)];
        [halfTopView setFrame:CGRectMake(0, 0, 320, 38)];
        //[halfTailView setFrame:CGRectMake(0, 480-38, 320, 38)];
        if (iPhone5) {
            [fullTailView setFrame:CGRectMake(0, 568, 320, 44)];
            [halfTailView setFrame:CGRectMake(0, 568-44, 320, 44)];
        }else{
            [fullTailView setFrame:CGRectMake(0, 480, 320, 44)];
            [halfTailView setFrame:CGRectMake(0, 480-44, 320, 44)];
            
        }
    }
}

@end
