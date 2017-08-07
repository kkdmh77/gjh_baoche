//
//  ProductViewController.m
//  MuBan
//
//  Created by 龚 俊慧 on 2017/3/31.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import "ProductViewController.h"
#import <JZNavigationExtension/JZNavigationExtension.h>
#import "GCDThread.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "UITool.h"
#import <NerdyUI.h>
#import "UIButton+Badge.h"

static NSInteger _staticMsgCount = 0;
static NSInteger _staticCartCount = 0;

@interface ProductViewController ()

@property (nonatomic, assign) ProNavLevel navLevel; ///< 导航栏的级别

@end

@implementation ProductViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.navLevel = ProNavLevelOne;
        
        self.loadUrlStr = @"http://120.76.188.84:8085/plugin/testAppNAV.html";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupPDRUI];
    [self setup];
}

- (void)dealloc {
    [[PDRCore Instance] setContainerView:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setup {
    self.jz_navigationBarBackgroundAlpha = 0.5;
    
    [self configureOneLevelNavAttributesWithSearchBarTitle:nil];
}

- (void)clearNavAttributes {
    self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.titleView = nil;
}

- (void)configureOneLevelNavAttributesWithSearchBarTitle:(NSString *)title {
    self.navLevel = ProNavLevelOne;
    [self clearNavAttributes];
    
    // search bar
    @weakify(self)
    UIButton *searchBtn = [self setupNavSearchBarWithActionHandle:^(id sender) {
        
    }];
    [searchBtn setTitle:title forState:UIControlStateNormal];
    
    // navigation item
    [self configureBarbuttonItemsByPosition:BarbuttonItemPosition_Left
                                 normalImgs:@[@"nav_scan_white"]
                            highlightedImgs:@[@"nav_scan_white"]
                                    actions:@[^(id sender){
        [UITool pushToScanViewControllerWtihCompleteHandle:^(NSString *resultStr) {
            NSString *function = Str(@"qrCallBack('%@')", resultStr);
            
            [weak_self.appFrame evaluateJavaScript:function
                                 completionHandler:^(id obj, NSError *error) {
                                     
            }];
        }];
    }]];
    
    [self configureBarbuttonItemsByPosition:BarbuttonItemPosition_Right
                                 normalImgs:@[@"nav_message", @"nav_shop_cart"]
                            highlightedImgs:@[@"nav_message", @"nav_shop_cart"]
                                    actions:@[^(id sender){
        // 消息
    }, ^(id sedner) {
        // 购物车
    }]];
    
    self.msgCount = _staticMsgCount;
    self.cartCount = _staticCartCount;
}

- (void)configureTwoLevelNavAttributesWithMenuDics:(NSArray<NSDictionary *> *)menuDics hasSearchBar:(BOOL)hasSearchBar searchBarTitle:(NSString *)title {
    self.navLevel = ProNavLevelTwo;
    [self clearNavAttributes];
    
    // search bar
    @weakify(self)
    if (hasSearchBar) {
         UIButton *searchBtn = [self setupNavSearchBarWithActionHandle:^(id sender) {
             
         }];
        [searchBtn setTitle:title forState:UIControlStateNormal];
    } else {
        self.navigationItem.titleView = nil;
    }
    
    // navigation item
    [self configureBarbuttonItemsByPosition:BarbuttonItemPosition_Right
                                 normalImgs:@[@"nav_more", @"nav_shop_cart"]
                            highlightedImgs:@[@"nav_more", @"nav_shop_cart"]
                                    actions:@[^(id sender){
        // 下拉菜单
        [weak_self showNavMoreMenu:menuDics sender:sender];
    }, ^(id sedner) {
        // 购物车
    }]];
}

- (void)showNavMoreMenu:(NSArray<NSDictionary *> *)menuDics sender:(id)sender {
    NSDictionary *navMoreMenuDataDic = @{@"icon1": @"tab_chanpin_normal", // 产品
                                         @"icon2": @"nav_message_black", // 消息
                                         @"icon3": @"nav_search", // 搜索
                                         @"icon4": @"tab_fengxiang_normal", // 分享
                                         @"icon5": @"tab_mine_normal"}; // 我的
    
    NSMutableArray *menuItemsArray = [NSMutableArray arrayWithCapacity:menuDics.count];
    for (NSDictionary *tempDic in menuDics) {
        NSString *text = tempDic[@"name"];
        NSString *icon = [navMoreMenuDataDic safeObjectForKey:tempDic[@"icon"]];
        NSString *function = tempDic[@"callback"];
        
        NavMenuItem *item = [[NavMenuItem alloc] initWithText:text imageSource:icon];
        item.userInfo = function;
        
        [menuItemsArray addObject:item];
    }
    
    @weakify(self)
    [NavMenuViewManager presentNavMenuWithMenuItems:menuItemsArray
                                         targetView:sender
                                             inView:[UIApplication sharedApplication].keyWindow
                                     selectedHandle:^(NSInteger index, NavMenuItem *selectedItem) {
         [GCDThread enqueueBackgroundWithDelay:0.0
                                         block:^{
             [weak_self performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:)
                                         withObject:selectedItem.userInfo
                                      waitUntilDone:YES];
         }];
    }];
}

- (void)stringByEvaluatingJavaScriptFromString:(NSString *)js {
    [self.appFrame evaluateJavaScript:js
                    completionHandler:^(id obj, NSError *error) {
                        
    }];
}

#pragma mark - setter & getter methods

- (void)setMsgCount:(NSInteger)msgCount {
    _staticMsgCount = msgCount;
    
    if (_navLevel == ProNavLevelOne && 2 == self.navigationItem.rightBarButtonItems.count) {
        UIButton *msgItem = [self.navigationItem.rightBarButtonItems[0].customView viewWithTag:kBarButtonItemViewTag];
        
        if (msgCount <= 0) {
            msgItem.badgeValue = nil;
        } else {
            msgItem.badgeValue = @"1";
        }
        
        msgItem.badgeBGColor = Color(@"red");
        msgItem.badgeFont = Fnt(1);
        msgItem.badgeMinSize = 3;
        msgItem.badgeOriginX = msgItem.width - msgItem.badge.width;
        msgItem.badgeOriginY = 2;
    }
}

- (NSInteger)msgCount {
    return _staticMsgCount;
}

- (void)setCartCount:(NSInteger)cartCount {
    _staticCartCount = cartCount;
    
    if (_navLevel == ProNavLevelOne && 2 == self.navigationItem.rightBarButtonItems.count) {
        UIButton *cartItem = [self.navigationItem.rightBarButtonItems[1].customView viewWithTag:kBarButtonItemViewTag];
        
        if (cartCount <= 0) {
            cartItem.badgeValue = nil;
        } else if (0 < cartCount && cartCount < 99) {
            cartItem.badgeValue = Str(cartCount);
        } else {
            cartItem.badgeValue = @"99+";
        }
        
        cartItem.badgeBGColor = Color(@"red");
        cartItem.badgeFont = Fnt(10);
        cartItem.badgePadding = 5;
        cartItem.badgeOriginY = 2;
    }
}

- (NSInteger)cartCount {
    return _staticCartCount;
}

@end
