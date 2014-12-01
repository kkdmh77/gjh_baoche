//
//  RootManager.h
//  ZhongShangPaper
//
//  Created by Danny Deng on 12-2-20.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaperTarBarVC.h"
#import "MainPageVC.h"
#import "ListVC.h"
#import "PictureNewVC.h"
#import "PersonNewsVC.h"
#import "MoreVC.h"
#import "PicViewController.h"
#import "VideoViewController.h"
#import "SpecialViewController.h"
#import "ActiveViewController.h"
#import "TouPiaoActiveViewController.h"



@interface RootManager : UIViewController <ListVCDelegate,VideoViewDelegate, PictureNewVCDelegate,PicViewDelegate,SpecialViewDelegate,PaperTarBarVCDelegate, MainPageDelegate, PersonNewsVCDelegate, MoreVCDelegate,ActiveViewDelegate, UITabBarControllerDelegate>{
    UINavigationController *_mainPageNavigation, *_listNavigation, *_pictureNavigation, *_personNewsNavigation, *_moreNavigation;
    PaperTarBarVC *_tarBar;
    MainPageVC *_mainPageVC;
    ListVC *_listVC;
    PictureNewVC *_pictureNewVC;
    PicViewController *_picView;
    SpecialViewController *_specialView;
    VideoViewController *_videoView;
    ActiveViewController *_activeView;
    TouPiaoActiveViewController *_toupiaoView;
    PersonNewsVC *_personNewsVC;
    MoreVC *_moreVC;
    NSInteger _oldSelecteItem;
    UITabBarController *_tarBarController;
}


@end
