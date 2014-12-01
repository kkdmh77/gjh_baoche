//
//  MainPageVC.m
//  ZhongShangPaper
//
//  Created by Danny Deng on 12-2-20.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#define NewsContentTag 1000000
#import "MainPageVC.h"
#import "MoreOrderChannelVC.h"
#import "ZSSourceModel.h"
#import "ZSCommunicateModel.h"
#import "SetViewController.h"

@interface MainPageVC(Private)

- (void)receiveGetNewsType;

@end

@implementation MainPageVC
@synthesize delegate;

#pragma mark - Public
- (void)initUIDate {
    [_navigationBar initUIData];
}

#pragma mark - Private
- (void)receiveGetNewsType {
    NSMutableDictionary *allDic = [[ZSSourceModel defaultSource] newsTypeDataDic];
    NSDictionary *responseDic = [allDic objectForKey:@"response"];
    NSArray *itemArray = [responseDic objectForKey:@"item"];
    if ([itemArray count] > 0) {
        NSDictionary *itemDic = [itemArray objectAtIndex:0];
        firstId = [[itemDic objectForKey:@"newstypeId"] intValue];
        if (_firstNewsVC) {
            [_firstNewsVC.view removeFromSuperview];
            [_firstNewsVC release];
            _firstNewsVC = nil;
        }
        _firstNewsVC = [[MainPageFirstNewsListVC alloc] init];
        [_firstNewsVC setDelegate:self];
        [_firstNewsVC loadNewsList:firstId];
        [_firstNewsVC setisNeedLoadNextYes];
        [self.view addSubview:_firstNewsVC.view];
        [self.view addSubview:_navigationBar.view];
    }
}

#pragma mark - View lifecycle
- (void)dealloc {
    [titleString release];
    [_firstNewsVC release];
    [_secondNewsVC release];
    [_newInfo release];
    [_adsInfo release];
    [_navigationBar release];
    [typeArray release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveGetNewsType) name:Notification_getNewsType object:nil];
    
    _navigationBar = [[MainPageNavigationBar alloc] initWithNibName:@"MainPageNavigationBar" bundle:nil];
    [_navigationBar.view setFrame:CGRectMake(0, 0, _navigationBar.view.frame.size.width, _navigationBar.view.frame.size.height)];
    [_navigationBar setDelegate:self];
    
    [self.view addSubview:_navigationBar.view];
    _oldSelectItem = -1;
    typeArray =[[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNewsCategory) name:Notification_getNewsType object:nil];
    
}

- (void)refreshNewsCategory {
    
    NSMutableDictionary *allDic = [[ZSSourceModel defaultSource] newsTypeDataDic];
    NSDictionary *responseDic = [allDic objectForKey:@"response"];
    [typeArray setArray:[responseDic objectForKey:@"item"]];
    //NSMutableArray *itemArray = [responseDic objectForKey:@"item"];

}








#pragma mark - MainPageNavigationBarDelegate
- (void)MainPageNavigationBarSetTitleName:(NSString *)titleName {
    if (titleString) {
        [titleString release];
    }
    titleString = [titleName retain];
    [_secondNewsVC.lblTitle setText:titleName];
}

- (void)MainPageNavigationBarHideTarBar:(BOOL)isHide {
    if (delegate && [delegate respondsToSelector:@selector(mainPageHideTarBar:)]) {
        [delegate mainPageHideTarBar:isHide];
    }
}


- (void)MainPageNavigationBarClickItem:(NSInteger)item {
    currentId = item;
    [[ZSCommunicateModel defaultCommunicate] clearAllNewsList];
    //不保存列表
#ifndef NewsListIsHaveAds
    if (_firstNewsVC) {
        [_firstNewsVC.view removeFromSuperview];
        [_firstNewsVC release];
        _firstNewsVC = nil;
    }
#endif
    
    if (_secondNewsVC) {
        [_secondNewsVC.view removeFromSuperview];
        [_secondNewsVC release];
        _secondNewsVC = nil;
    }
    
    
#ifdef NewsListIsHaveAds
    
//    if (delegate && [delegate respondsToSelector:@selector(mainPageHideTarBar:)]) {
//        [delegate mainPageHideTarBar:YES];
//    }
    _secondNewsVC = [[MainPageSecondNewsListVC alloc] initWithNibName:@"MainPageSecondNewsListVC" bundle:nil];
    [_secondNewsVC setDelegate:self];
    [_secondNewsVC loadNewsList:item];
    if (_newInfo == nil) {
        _newInfo = [[MainPageNewInfoDetail alloc] initWithNibName:@"MainPageNewInfoDetail" bundle:nil];
    }
    [_newInfo setDelegate:_secondNewsVC];
    [self.navigationController pushViewController:_secondNewsVC animated:YES];
    
#else
    
    if (item == firstId) {
        _firstNewsVC = [[MainPageFirstNewsListVC alloc] init];
        [_firstNewsVC setDelegate:self];
        [_firstNewsVC loadNewsList:firstId];
        [self.view addSubview:_firstNewsVC.view];
        [self.view addSubview:_navigationBar.view];
    }
    else {
        _secondNewsVC = [[MainPageSecondNewsListVC alloc] initWithNibName:@"MainPageSecondNewsListVC" bundle:nil];
        [_secondNewsVC setDelegate:self];
        [_secondNewsVC loadNewsList:item];
        if (_newInfo == nil) {
            _newInfo = [[MainPageNewInfoDetail alloc] initWithNibName:@"MainPageNewInfoDetail" bundle:nil];
        }
        [_newInfo setDelegate:_secondNewsVC];
        [self.view addSubview:_secondNewsVC.view];
        [self.view addSubview:_navigationBar.view];
    }
    
#endif
}


- (void)MainPageNavigationBarSet{
//    CATransition *transition = [CATransition animation];
//    transition.duration = 1;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromTop;
//    transition.delegate = self;
//    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    SetViewController  *setviewcontroller=[[SetViewController alloc] init];
    [self.navigationController pushViewController:setviewcontroller animated:YES];
   // [self.navigationController popViewControllerAnimated:YES];
    
    
}

#pragma mark - MainPageFirstNewsListDelegate
- (void)MainPageFirstNewsListSetNewsInfoArray:(NSArray *)firstNewsArray {
    if (_newInfo == nil) {
        _newInfo = [[MainPageNewInfoDetail alloc] initWithNibName:@"MainPageNewInfoDetail" bundle:nil];
    }
    if (_firstNewsVC) {
        [_newInfo setDelegate:_firstNewsVC];
    }
    [_newInfo setNewsArray:firstNewsArray];
}

- (void)MainPageFirstNewsListClickNewsItem:(NSInteger)item type:(NSInteger)type{
    if (delegate && [delegate respondsToSelector:@selector(mainPageHideTarBar:)]) {
        [delegate mainPageHideTarBar:YES];
    }
    if (_newInfo == nil) {
        _newInfo = [[MainPageNewInfoDetail alloc] initWithNibName:@"MainPageNewInfoDetail" bundle:nil];
    }
    if (_firstNewsVC) {
        [_newInfo setDelegate:_firstNewsVC];
    }
    [self.navigationController pushViewController:_newInfo animated:YES];
    [_newInfo initFrame];
    [_newInfo setNewsContent:item];
    NSMutableDictionary *allDic = [[ZSSourceModel defaultSource] newsTypeDataDic];
    if(type==1){
         [_newInfo.newsTitle setText:@"焦点新闻"];
    }else{
        NSDictionary *responseDic = [allDic objectForKey:@"response"];
        NSArray *itemArray = [responseDic objectForKey:@"item"];
        NSDictionary *itemDic = [itemArray objectAtIndex:0];
        [_newInfo.newsTitle setText:[itemDic objectForKey:@"newstypeOrderName"]];
    }
   
    //[_newInfo.replayNumText setText:[itemDic objectForKey:@"commCount"]];
}

- (void)MainPageFirstNewsListClickAds:(NSInteger)item {
    if (delegate && [delegate respondsToSelector:@selector(mainPageHideTarBar:)]) {
        [delegate mainPageHideTarBar:YES];
    }
    if (_adsInfo == nil) {
        _adsInfo = [[MainPageAdsInfoDetail alloc] initWithNibName:@"MainPageAdsInfoDetail" bundle:nil];
    }
    [_adsInfo setDelegate:self];
    [self.navigationController pushViewController:_adsInfo animated:YES];
    [_adsInfo initFrame];
    [_adsInfo setNewsContent:item];
}

- (void)MainPageFirstNewsListAdsArray:(NSArray *)adsArray {
    if (_adsInfo == nil) {
        _adsInfo = [[MainPageAdsInfoDetail alloc] initWithNibName:@"MainPageAdsInfoDetail" bundle:nil];
    }
    [_adsInfo setDelegate:self];
    [_adsInfo initFrame];
    [_adsInfo setNewsArray:adsArray];
}


- (void) MainPageFirstNewsListChange{
    
    int newtypeid=currentId;
    
    if (newtypeid==0) {
        newtypeid=[[[typeArray objectAtIndex:1] objectForKey:@"newstypeId"] intValue];
        //[_navigationBar GestureChangeItem:newtypeid];
        [_navigationBar GestureChangeItem:newtypeid rightorleft:0];
        [self MainPageNavigationBarClickItem:newtypeid];
        
    }else{
        for (int i = 0; i < typeArray.count-1; i++) {
            NSDictionary *itemDic = [typeArray objectAtIndex:i];
            if (currentId==[[itemDic objectForKey:@"newstypeId"] intValue] && typeArray.count >i) {
                newtypeid = [[[typeArray objectAtIndex:i+1] objectForKey:@"newstypeId"] intValue];
                //[_navigationBar GestureChangeItem:newtypeid];
                [_navigationBar GestureChangeItem:newtypeid rightorleft:0];
                [self MainPageNavigationBarClickItem:newtypeid];
                currentId=newtypeid;
                break;
            }
            
        }
    }
//    currentId
   
    
   
}

#pragma mark - MainPageSecondNewsListVCDelegate
#ifdef NewsListIsHaveAds
- (void)MainPageSecondNewsListHideTarBar:(BOOL)isHide {
    if (delegate && [delegate respondsToSelector:@selector(mainPageHideTarBar:)]) {
        [delegate mainPageHideTarBar:isHide];
    }
}

- (void)MainPageSecondNewsListGoBack {
    if (delegate && [delegate respondsToSelector:@selector(mainPageHideTarBar:)]) {
        [delegate mainPageHideTarBar:NO];
    }
    [self.navigationController popViewControllerAnimated:YES];
    [_navigationBar disPlayBtnLight];
    [[ZSCommunicateModel defaultCommunicate] clearAllNewsList];
    [_secondNewsVC release];
    _secondNewsVC = nil;
    [_firstNewsVC loadNewsList:firstId];
}
#endif

- (void)MainPageInfoDetailBack {
    [_newInfo release];
    _newInfo = nil;
#ifdef NewsListIsHaveAds
    if (!_secondNewsVC && delegate && [delegate respondsToSelector:@selector(mainPageHideTarBar:)]) {
        [delegate mainPageHideTarBar:NO];
    }
#else
    if (delegate && [delegate respondsToSelector:@selector(mainPageHideTarBar:)]) {
        [delegate mainPageHideTarBar:NO];
    }
#endif
}

- (void)MainPageSecondNewsListGotoNewDetail:(NSInteger) itemId {
    if (delegate && [delegate respondsToSelector:@selector(mainPageHideTarBar:)]) {
        [delegate mainPageHideTarBar:YES];
    }
    if (_newInfo == nil) {
        _newInfo = [[MainPageNewInfoDetail alloc] initWithNibName:@"MainPageNewInfoDetail" bundle:nil];
    }
    if (_secondNewsVC) {
        [_newInfo setDelegate:_secondNewsVC];
    }
    [self.navigationController pushViewController:_newInfo animated:YES];
    [_newInfo initFrame];
    [_newInfo setNewsContent:itemId];
    [_newInfo.newsTitle setText:titleString];
}

- (void)MainPageSecondNewsListSetNewsInfoArray:(NSArray *)secondNewsArray {
    if (_newInfo == nil) {
        _newInfo = [[MainPageNewInfoDetail alloc] initWithNibName:@"MainPageNewInfoDetail" bundle:nil];
    }
    if (_secondNewsVC) {
        [_newInfo setDelegate:_secondNewsVC];
    }
    [_newInfo setNewsArray:secondNewsArray];
}


- (void)MainPageSecondNewsListChange{
    int newtypeid=currentId;
    
    if (newtypeid==0) {
        newtypeid=[[[typeArray objectAtIndex:1] objectForKey:@"newstypeId"] intValue];
        [_navigationBar GestureChangeItem:newtypeid rightorleft:0];
        [self MainPageNavigationBarClickItem:newtypeid];
        
    }else{
        for (int i = 0; i < typeArray.count-1; i++) {
            NSDictionary *itemDic = [typeArray objectAtIndex:i];
            if (currentId==[[itemDic objectForKey:@"newstypeId"] intValue] && typeArray.count >i) {
                newtypeid = [[[typeArray objectAtIndex:i+1] objectForKey:@"newstypeId"] intValue];
                [_navigationBar GestureChangeItem:newtypeid rightorleft:0];
                [self MainPageNavigationBarClickItem:newtypeid];
                currentId=newtypeid;
                break;
            }
            
        }
    }
}

- (void)MainPageSecondNewsListChangeBack{
    int newtypeid=currentId;
    for (int i = 1; i < typeArray.count; i++) {
        NSDictionary *itemDic = [typeArray objectAtIndex:i];
        if (currentId==[[itemDic objectForKey:@"newstypeId"] intValue]) {
            newtypeid = [[[typeArray objectAtIndex:i-1] objectForKey:@"newstypeId"] intValue];
            //[_navigationBar GestureChangeItem:newtypeid];
            [_navigationBar GestureChangeItem:newtypeid rightorleft:1];
            [self MainPageNavigationBarClickItem:newtypeid];
            currentId=newtypeid;
            break;
        }
        
    }

}

#pragma mark - MainPageAdsInfoDetailDelegate
- (void)MainPageAdsInfoDetailGoBack {
    [_adsInfo release];
    _adsInfo = nil;
    if (delegate && [delegate respondsToSelector:@selector(mainPageHideTarBar:)]) {
        [delegate mainPageHideTarBar:NO];
    }
}




@end
