//
//  MainPageNavigationBar.m
//  ZhongShangPaper
//
//  Created by Danny Deng on 12-2-21.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import "MainPageNavigationBar.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageContant.h"
#import "ZSSourceModel.h"
#import "ZhongShangContant.h"
#import "WeatherParser.h"
#import "YahooWeather.h"
#import "CommonUtil.h"
#import "SetViewController.h"

@interface MainPageNavigationBar(Private)

- (void)refreshOrderSequence;
- (void)refreshNewsCategory;
- (void)clickBtn:(UIButton *)button;
//- (void)clickBackBtn;
- (void)getWeather;

@end

@implementation MainPageNavigationBar
@synthesize leftDirectImageView, rightDirectImageView;
@synthesize delegate;
@synthesize lblCurrentData, lblCurrentWeek;
@synthesize newsCategoryScrollView;
@synthesize weatherImageView, lblWeatherText, lblWeatherTemperature;
@synthesize bgBtnImageView;


#pragma mark - View lifecycle

- (void)dealloc {
    [_btnTagToNumDic release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isMoving = NO;
    
    [lblCurrentData setText:getStringFromDate(@"YYYY-MM-dd", [NSDate date])];
    [lblCurrentWeek setText:getWeekDaySymbol([NSDate date])];
    newsCategoryScrollView.showsVerticalScrollIndicator = NO;
    newsCategoryScrollView.showsHorizontalScrollIndicator = NO;
    
    [self performSelector:@selector(getWeather) withObject:nil afterDelay:.1];
    [lblWeatherText setAdjustsFontSizeToFitWidth:YES];
    [lblWeatherTemperature setAdjustsFontSizeToFitWidth:YES];
    
    [newsCategoryScrollView setDelegate:self];
    [leftDirectImageView setHidden:YES];
    [rightDirectImageView setHidden:YES];
    
    
    [lblCurrentData setHidden:YES];
    [lblCurrentWeek setHidden:YES];
    [lblWeatherText setHidden:YES];
    [lblWeatherTemperature setHidden:YES];
    [weatherImageView setHidden:YES];
    
    _btnTagToNumDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNewsCategory) name:Notification_getNewsType object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrderSequence) name:Notification_ChangeOrderSequence object:nil];
    
#ifdef NewsListIsHaveAds
    [bgBtnImageView setAlpha:0];
#endif
    
}

#pragma mark - public
- (void)initUIData {
    //[self refreshOrderSequence];
}

- (void)disPlayBtnLight {
    NSArray *btnArray = [newsCategoryScrollView subviews];
    for (id btn in btnArray) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [btn setSelected:NO];
        }
    }
}

#pragma mark  - Private
- (void)refreshOrderSequence {
    for (id btnView in [newsCategoryScrollView subviews]) {
        if ([btnView isKindOfClass:[UIButton class]]) {
            [btnView removeFromSuperview];
        }
    }
    NSInteger unitBetween = 3;
    NSInteger btnWidth = 47;
    NSMutableDictionary *allDic = [[ZSSourceModel defaultSource] newsTypeDataDic];
    NSDictionary *responseDic = [allDic objectForKey:@"response"];
    NSArray *itemArray = [responseDic objectForKey:@"item"];
    int count = [itemArray count];
    if (count > 6) {
        [newsCategoryScrollView setContentSize:CGSizeMake(count*(2*unitBetween+btnWidth), newsCategoryScrollView.frame.size.height)];
        [rightDirectImageView setHidden:NO];
    }
    else {
        [newsCategoryScrollView setContentSize:CGSizeMake(320, newsCategoryScrollView.frame.size.height)];
    }
    for (int i = 0; i < count; i++) {
        NSDictionary *itemDic = [itemArray objectAtIndex:i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:[itemDic objectForKey:@"newstype_name"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
#ifndef NewsListIsHaveAds
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
#else
        if (i != 0) {
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            [btn setBackgroundImage:[UIImage imageNamed:@"nav_selected_background"] forState:UIControlStateHighlighted];
        }
#endif
        
        [btn setTag:[[itemDic objectForKey:@"newstypeId"] intValue]];
        [_btnTagToNumDic setObject:[NSString stringWithFormat:@"%i",i] forKey:[[itemDic objectForKey:@"newstypeId"] stringValue]];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setFrame:CGRectMake(unitBetween + i*2*unitBetween + i*btnWidth, 4, btnWidth, 30)];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [newsCategoryScrollView addSubview:btn];
        if (i == 0) {
#ifndef NewsListIsHaveAds
            [btn setSelected:YES];
#endif
        }
    }
    [bgBtnImageView setCenter:CGPointMake(26, 19)];
    
    NSDictionary *firstItemDic = [itemArray objectAtIndex:0];
    NSArray *btnArray = [newsCategoryScrollView subviews];
    for (id btn in btnArray) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if ([btn isSelected]) {
                [btn setSelected:NO];
                if ([(UIButton *)btn tag] == [[firstItemDic objectForKey:@"newstypeId"] intValue]) {
                    [btn setSelected:YES];
                }
            }
        }
    }
#ifndef NewsListIsHaveAds
    if (delegate && [delegate respondsToSelector:@selector(MainPageNavigationBarClickItem:)]) {
        [delegate MainPageNavigationBarClickItem:[[firstItemDic objectForKey:@"newstypeId"] intValue]];
    }
#endif
    NSInteger selectNum = 0;
    [bgBtnImageView setCenter:CGPointMake(unitBetween + selectNum*2*unitBetween + selectNum*btnWidth + btnWidth*1.0/2.0, 19)];
}

- (void)getWeather {
#ifdef Web_Connect_Have
    YahooWeather *weatherParser = [[YahooWeather alloc] init];
    [weatherParser startXMLParser];
    if (weatherParser._dayWeather.lowTemperature && [weatherParser._dayWeather.lowTemperature length] > 0) {
        NSString *temperature = [NSString stringWithFormat:@"%@˚C~%@˚C",weatherParser._dayWeather.lowTemperature, weatherParser._dayWeather.highTemperature];
        [lblWeatherTemperature setText:temperature];
        [lblWeatherText setText:weatherParser._dayWeather.textTemperature];
        UIImage *image = [UIImage imageByName:weatherParser._dayWeather.imageName withExtend:@"png"];
        [weatherImageView setImage:image];
        [[NSUserDefaults standardUserDefaults] setObject:temperature forKey:Weather_Tempature_Number];
        [[NSUserDefaults standardUserDefaults] setObject:weatherParser._dayWeather.textTemperature forKey:Weather_Tempature_Text];
        [[NSUserDefaults standardUserDefaults] setObject:weatherParser._dayWeather.imageName forKey:Weather_Code];
    }
    else {
        NSString *temperatureNum = [[NSUserDefaults standardUserDefaults] objectForKey:Weather_Tempature_Number];
        NSString *temperatureText = [[NSUserDefaults standardUserDefaults] objectForKey:Weather_Tempature_Text];
        NSString *imageCode = [[NSUserDefaults standardUserDefaults] objectForKey:Weather_Code];
        if ([temperatureNum length] > 0) {
            [lblWeatherText setText:temperatureText];
            [lblWeatherTemperature setText:temperatureNum];
            UIImage *image = [UIImage imageByName:imageCode withExtend:@"png"];
            [weatherImageView setImage:image];
        }
    }
    [weatherParser release];
#endif
}

- (void)refreshNewsCategory {
    for (id btnView in [newsCategoryScrollView subviews]) {
        if ([btnView isKindOfClass:[UIButton class]]) {
            [btnView removeFromSuperview];
        }
    }
    NSInteger unitBetween = 3;
    NSInteger btnWidth = 47;
    NSMutableDictionary *allDic = [[ZSSourceModel defaultSource] newsTypeDataDic];
    NSDictionary *responseDic = [allDic objectForKey:@"response"];
    NSMutableArray *itemArray = [responseDic objectForKey:@"item"];
    int count = [itemArray count];
    if (count > 6) {
        [newsCategoryScrollView setContentSize:CGSizeMake(count*(2*unitBetween+btnWidth), newsCategoryScrollView.frame.size.height)];
        [rightDirectImageView setHidden:NO];
    }
    else {
        [newsCategoryScrollView setContentSize:CGSizeMake(320, newsCategoryScrollView.frame.size.height)];
    }
    for (int i = 0; i < count; i++) {
        NSDictionary *itemDic = [itemArray objectAtIndex:i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:[itemDic objectForKey:@"newstypeName"] forState:UIControlStateNormal];
        [btn setTitleColor:[CommonUtil colorWithHexString:@"#6a6969"] forState:UIControlStateNormal];
        
#ifndef NewsListIsHaveAds
        [btn setTitleColor:[CommonUtil colorWithHexString:@"#242424"]  forState:UIControlStateHighlighted];
        [btn setTitleColor:[CommonUtil colorWithHexString:@"#242424"]  forState:UIControlStateSelected];
#else
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            [btn setBackgroundImage:[UIImage imageNamed:@"nav_selected_background"] forState:UIControlStateHighlighted];
#endif
        
        [btn setTag:[[itemDic objectForKey:@"newstypeId"] intValue]];
        [_btnTagToNumDic setObject:[NSString stringWithFormat:@"%i",i] forKey:[[itemDic objectForKey:@"newstypeId"] stringValue]];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setFrame:CGRectMake(unitBetween + i*2*unitBetween + i*btnWidth, 4, btnWidth, 30)];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [newsCategoryScrollView addSubview:btn];
        if (i == 0) {
            [btn setSelected:YES];
        }
    }
    [bgBtnImageView setCenter:CGPointMake(26, 19)];
}



- (void)clickBtn:(UIButton *)button {
    if (_isMoving) {
        return;
    }
    _isMoving = YES;
    NSArray *btnArray = [newsCategoryScrollView subviews];
    for (id btn in btnArray) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if ([btn isSelected]) {
                [btn setSelected:NO];
            }
            
        }
    }
#ifndef NewsListIsHaveAds
    [button setSelected:YES];
#endif
    NSMutableDictionary *allDic = [[ZSSourceModel defaultSource] newsTypeDataDic];
    NSDictionary *responseDic = [allDic objectForKey:@"response"];
    NSArray *itemArray = [responseDic objectForKey:@"item"];
    NSInteger unitBetween = 3;
    NSInteger btnWidth = 47;
    NSInteger selectNum = [[_btnTagToNumDic objectForKey:[NSString stringWithFormat:@"%i",button.tag]] intValue];
    if (selectNum >= [itemArray count]) {
        return;
    }
    if (delegate && [delegate respondsToSelector:@selector(MainPageNavigationBarClickItem:)]) {
        [delegate MainPageNavigationBarClickItem:button.tag];
    }
    [UIView animateWithDuration:.2 animations:^{
        [bgBtnImageView setCenter:CGPointMake(unitBetween-1 + selectNum*2*unitBetween + selectNum*btnWidth + btnWidth*1.0/2.0, 18)];
    }completion:^(BOOL finish) {
        _isMoving = NO;
    }];
    
    if (delegate && [delegate respondsToSelector:@selector(MainPageNavigationBarSetTitleName:)]) {
        NSDictionary *itemDic = [itemArray objectAtIndex:selectNum];
        [delegate MainPageNavigationBarSetTitleName:[itemDic objectForKey:@"newstypeOrderName"]];
    }
}


- (void)GestureChangeItem:(NSInteger) itemid rightorleft:(NSInteger) rightorleft{
    if (_isMoving) {
        return;
    }
   // _isMoving = YES;
    NSArray *btnArray = [newsCategoryScrollView subviews];
    for (id btn in btnArray) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if ([btn isSelected]) {
                [btn setSelected:NO];
            }
            if([btn tag]==itemid){
                [btn setSelected:YES];
            }
        }
    }
    
    
    NSInteger unitBetween = 3;
    NSInteger btnWidth = 47;
    
    NSInteger selectNum = [[_btnTagToNumDic objectForKey:[NSString stringWithFormat:@"%i",itemid]] intValue];
    
    CGPoint currentcgpoint= [newsCategoryScrollView contentOffset];
    CGSize  currentsize = [newsCategoryScrollView contentSize];

    NSInteger cunertleg = unitBetween-1 + selectNum*2*unitBetween + selectNum*btnWidth;
    if (cunertleg+btnWidth>320 && currentsize.width>currentcgpoint.x+320 && rightorleft==0) {
        [newsCategoryScrollView setContentOffset:CGPointMake(currentcgpoint.x+2*unitBetween+btnWidth, 0) animated:YES];
    }else if(cunertleg<currentcgpoint.x && rightorleft==1){
        [newsCategoryScrollView setContentOffset:CGPointMake(currentcgpoint.x-2*unitBetween-btnWidth, 0) animated:YES];
    }
     //newsCategoryScrollView contentInset
    
    [UIView animateWithDuration:.2 animations:^{
        [bgBtnImageView setCenter:CGPointMake(unitBetween-1 + selectNum*2*unitBetween + selectNum*btnWidth + btnWidth*1.0/2.0, 18)];
    }completion:^(BOOL finish) {
        _isMoving = NO;
    }];
}

- (IBAction)clickSet:(id)sender{

    if (delegate && [delegate respondsToSelector:@selector(MainPageNavigationBarSet)]) {
       
        [delegate MainPageNavigationBarSet];
        
    }
    
    
}

#pragma ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint point = [scrollView contentOffset];
    CGSize size = [scrollView contentSize];
    if (point.x < 20) {
        [leftDirectImageView setHidden:YES];
    }
    else {
        [leftDirectImageView setHidden:NO];
    }
    
    if (size.width - point.x-320 <20) {
        [rightDirectImageView setHidden:YES];
    }
    else {
        [rightDirectImageView setHidden:NO];
    }
}

@end
