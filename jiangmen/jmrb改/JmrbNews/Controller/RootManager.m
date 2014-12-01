//
//  RootManager.m
//  ZhongShangPaper
//
//  Created by Danny Deng on 12-2-20.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#define NavigationTag   1000

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#import "RootManager.h"
#import "ZSCommunicateModel.h"
#import "AppDelegate.h"

@interface RootManager(Private)

- (void)gotoTarBarItem:(NSNumber *)itemNum;

@end

@implementation RootManager

#pragma mark - Private

- (void)gotoTarBarItem:(NSNumber *)itemNum {
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate stopLoading];

    
    NSInteger item = [itemNum intValue];
    if (_oldSelecteItem == item) {
//        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [appDelegate stopLoading];
        return;
    }
    [_tarBarController setSelectedIndex:item];
    switch (item) {
        case 0:
            if (!_mainPageVC) {
                _mainPageVC = [[MainPageVC alloc] init];
                [_mainPageVC setDelegate:self];
                [_mainPageVC.view setTag:NavigationTag];
                [_mainPageNavigation pushViewController:_mainPageVC animated:NO];
            }
            [_mainPageVC initUIDate];
            break;
        case 1:
            if (!_picView) {
                _picView = [[PicViewController alloc] init];
                [_picView setDelegate:self];
                [_picView.view setTag:NavigationTag];
                [_pictureNavigation pushViewController:_picView animated:NO];
            }
            
            
            break;
        case 2:

            if (!_videoView) {
                _videoView = [[VideoViewController alloc] init];
                [_videoView setDelegate:self];
                [_videoView.view setTag:NavigationTag];
                [_listNavigation pushViewController:_videoView animated:NO];
            }
  
            break;
        case 3:
//            if (!_activeView) {
//                _activeView = [[ActiveViewController alloc] init];
//                [_activeView setDelegate:self];
//                [_activeView.view setTag:NavigationTag];
//                [_personNewsNavigation pushViewController:_activeView animated:NO];
//            }
            if (!_toupiaoView) {
                _toupiaoView = [[TouPiaoActiveViewController alloc] init];
               // [_toupiaoView setDelegate:self];
                [_toupiaoView.view setTag:NavigationTag];
                [_personNewsNavigation pushViewController:_toupiaoView animated:NO];
            }
            break;
        case 4:
//            if (!_moreVC) {
//                _moreVC = [[MoreVC alloc] init];
//                [_moreVC setDelegate:self];
//                [_moreVC.view setTag:NavigationTag];
//                [_moreNavigation pushViewController:_moreVC animated:NO];        
//                
//                //获取更多页面广告
//                NSMutableDictionary *dic = nil;
//                dic = [[NSMutableDictionary alloc] initWithCapacity:0];
//                [dic setObject:Web_moreAds forKey:Web_Key_urlString];
//                [[ZSCommunicateModel defaultCommunicate] getWebData:dic];
//                [dic release];
//            }
//            
            if (!_specialView) {
                _specialView = [[SpecialViewController alloc] init];
                [_specialView setDelegate:self];
                [_specialView.view setTag:NavigationTag];
                [_moreNavigation pushViewController:_specialView animated:NO];

            }
            
            break;
        default:
            break;
    }
    _oldSelecteItem = item;
//    if (item != 2) {
//        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [appDelegate stopLoading];
//    }
}

#pragma mark - View lifecycle
- (void)dealloc {
    
    [_picView release];
    [_specialView release];
    [_toupiaoView release];
    [_mainPageNavigation release];
    [_listNavigation release];
    [_pictureNavigation release];
    [_personNewsNavigation release];
    [_moreNavigation release];
    [_mainPageVC release];
    [_listVC release];
    [_pictureNewVC release];
    [_personNewsVC release];
    [_moreVC release];
    [_tarBar release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _mainPageNavigation = [[UINavigationController alloc] init];
    [_mainPageNavigation setNavigationBarHidden:YES];
    [_mainPageNavigation.view setTag:NavigationTag];
    [_mainPageNavigation.view setFrame:CGRectMake(0, 0, 320, 431)];
    
    _listNavigation = [[UINavigationController alloc] init];
    [_listNavigation setNavigationBarHidden:YES];
    [_listNavigation.view setTag:NavigationTag];
    [_listNavigation.view setFrame:CGRectMake(0, 0, 320, 431)];
    
    _pictureNavigation = [[UINavigationController alloc] init];
    [_pictureNavigation setNavigationBarHidden:YES];
    [_pictureNavigation.view setTag:NavigationTag];
    [_pictureNavigation.view setFrame:CGRectMake(0, 0, 320, 431)];
    
    _personNewsNavigation = [[UINavigationController alloc] init];
    [_personNewsNavigation setNavigationBarHidden:YES];
    [_personNewsNavigation.view setTag:NavigationTag];
    [_personNewsNavigation.view setFrame:CGRectMake(0, 0, 320, 431)];
    
    _moreNavigation = [[UINavigationController alloc] init];
    [_moreNavigation setNavigationBarHidden:YES];
    [_moreNavigation.view setTag:NavigationTag];
    [_moreNavigation.view setFrame:CGRectMake(0, 0, 320, 431)];
    
    _mainPageVC = [[MainPageVC alloc] init];
    [_mainPageVC setDelegate:self];
    [_mainPageNavigation pushViewController:_mainPageVC animated:NO];
    
    _tarBar = [[PaperTarBarVC alloc] initWithNibName:@"PaperTarBarVC" bundle:nil];
    if (iPhone5) {
        [_tarBar.view setFrame:CGRectMake(0,568-49,320,49)];
    }else{
        [_tarBar.view setFrame:CGRectMake(0, 480-49, 320, 49)];
    }
    
    //[_tarBar.view setFrame:CGRectMake(0, 480-49, 320, 49)];
    [_tarBar setDelegate:self];
//    [self.view addSubview:_tarBar.view];
    
    _oldSelecteItem = 0;
    _tarBarController = [[UITabBarController alloc] init];
    _tarBarController.viewControllers = [NSArray arrayWithObjects:_mainPageNavigation, _pictureNavigation,_listNavigation,  _personNewsNavigation, _moreNavigation, nil];
    [self.view addSubview:_tarBarController.view];
    [self.view addSubview:_tarBar.view];
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - TarBarDelegate
- (void)tarBarSelectedItem:(NSInteger)item {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate tarBarStartLoading];
    [self performSelector:@selector(gotoTarBarItem:) withObject:[NSNumber numberWithInt:item] afterDelay:.01];
}

- (void)allHideTarBar:(BOOL)isHide {
    [_tarBar.view setHidden:isHide];
}


#pragma mark - MainPageDelegate
- (void)mainPageHideTarBar:(BOOL)isHide {
    [_tarBar.view setHidden:isHide];
}

#pragma mark - PersonNewsDelegate
- (void)PersonNewsHideTarBar:(BOOL)isHide {
    [_tarBar.view setHidden:isHide];
}

#pragma mark - PictureNewsDelegate
- (void)PictureNewHideTarBar:(BOOL)isHide {
    [_tarBar.view setHidden:isHide];
}

#pragma mark - ListVCDelegate
- (void)ListVCHideTarBar:(BOOL)isHide {
    [_tarBar.view setHidden:isHide];
}

#pragma mark - MoreVCDelegate
- (void)MoreVCHideTarBar:(BOOL)isHide {
    [_tarBar.view setHidden:isHide];
}

#pragma mark - SpecialViewController
- (void)SpecialNewHideTarBar:(BOOL)isHide {
    [_tarBar.view setHidden:isHide];
}

#pragma mark - ActiveViewDelegate
- (void)ActiveViewHideTarBar:(BOOL)isHide{
     [_tarBar.view setHidden:isHide];
}

@end
