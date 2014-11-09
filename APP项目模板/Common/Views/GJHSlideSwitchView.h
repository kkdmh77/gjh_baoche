//
//  GJHSlideSwitchView.h
//  zmt
//
//  Created by apple on 14-3-10.
//  Copyright (c) 2014年 com.ygsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat kHeightOfTopScrollView = 38.0f;
static const CGFloat kWidthOfButtonMargin = 35.0f;
static const CGFloat kFontSizeOfTabButton = 17.0f;
static const NSUInteger kTagOfRightSideButton = 999;
static const CGFloat kHeightOfShadowImageView = 3.0f;

@protocol GJHSlideSwitchViewDelegate;

@interface GJHSlideSwitchView : UIView <UIScrollViewDelegate>
{
    UIScrollView *_topScrollView;                   // 顶部页签视图
    
    BOOL _isBuildUI;                                // 是否建立了ui
    
    NSInteger _userSelectedChannelID;               // 点击按钮选择名字ID
    
    UIImageView *_shadowImageView;
    UIImage *_shadowImage;
    
    UIColor *_tabItemNormalColor;                   // 正常时tab文字颜色
    UIColor *_tabItemSelectedColor;                 // 选中时tab文字颜色
    UIImage *_tabItemNormalBackgroundImage;         // 正常时tab的背景
    UIImage *_tabItemSelectedBackgroundImage;       // 选中时tab的背景
    
    UIButton *_rigthSideButton;                     // 右侧按钮
}

@property (nonatomic, strong) NSArray *titlesArray; // 顶部页签视图的标题数组
@property (nonatomic, strong) NSMutableArray *topScrollBtnsArray; // 顶部页签视图的子视图数组
@property (nonatomic, strong) UIScrollView *topScrollView;
@property (nonatomic, strong) UIColor *topScrollViewBackgroundColor; // 顶部页签视图背景颜色
@property (nonatomic, assign) NSInteger userSelectedChannelID;
@property (nonatomic, assign) id<GJHSlideSwitchViewDelegate> slideSwitchViewDelegate;
@property (nonatomic, strong) UIColor *tabItemNormalColor;
@property (nonatomic, strong) UIColor *tabItemSelectedColor;
@property (nonatomic, strong) UIImage *tabItemNormalBackgroundImage;
@property (nonatomic, strong) UIImage *tabItemSelectedBackgroundImage;
@property (nonatomic, strong) UIImage *shadowImage;
@property (nonatomic, strong) UIButton *rigthSideButton;

@property (nonatomic, assign) BOOL isTabItemEqualWidthInFullScreenWidth; // 顶部标签子视图是否等宽且只限制在屏幕宽度中显示(scrollview不横向滚动) default is NO

/*!
 * @method 初始化
 * @abstract
 * @discussion
 * @param frame 标题数组
 * @result
 */
- (id)initWithFrame:(CGRect)frame titlesArray:(NSArray *)titles;

/*!
 * @method 创建子视图UI
 * @abstract
 * @discussion
 * @param
 * @result
 */
- (void)buildUI;

/*!
 * @method 指定滑动到某一个tab按钮
 * @abstract
 * @discussion
 * @param 目标index
 * @result
 */
- (void)scrollToIndex:(int)index;

@end

@protocol GJHSlideSwitchViewDelegate <NSObject>

@optional

/*!
 * @method 点击tab
 * @abstract
 * @discussion
 * @param tab索引
 * @result
 */
- (void)slideSwitchView:(GJHSlideSwitchView *)view didselectTab:(NSUInteger)number;

@end
