//
//  MainPageNavigationBar.h
//  ZhongShangPaper
//
//  Created by Danny Deng on 12-2-21.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MainPageNavigationBarDelegate;

@interface MainPageNavigationBar : UIViewController<UIScrollViewDelegate> {
    NSMutableDictionary *_btnTagToNumDic;
    BOOL _isMoving;
}

@property (nonatomic, assign) id<MainPageNavigationBarDelegate> delegate;
@property (nonatomic, assign) IBOutlet UILabel *lblCurrentData;
@property (nonatomic, assign) IBOutlet UILabel *lblCurrentWeek;
@property (nonatomic, assign) IBOutlet UIScrollView *newsCategoryScrollView;
@property (nonatomic, assign) IBOutlet UIImageView *weatherImageView;
@property (nonatomic, assign) IBOutlet UILabel *lblWeatherText, *lblWeatherTemperature;
@property (nonatomic, assign) IBOutlet UIImageView *leftDirectImageView, *rightDirectImageView;
@property (nonatomic, assign) IBOutlet UIImageView *bgBtnImageView;

- (IBAction)clickSet:(id)sender;

- (void)disPlayBtnLight;
- (void)initUIData;
- (void)GestureChangeItem:(NSInteger) itemid rightorleft:(NSInteger) rightorleft;

@end

@protocol MainPageNavigationBarDelegate <NSObject>

@optional
- (void)MainPageNavigationBarClickItem:(NSInteger) item;
- (void)MainPageNavigationBarHideTarBar:(BOOL) isHide;
//- (void)MainPageNavigationBarClickBack;
- (void)MainPageNavigationBarSetTitleName:(NSString *)titleName;
- (void)MainPageNavigationBarSet;


@end
