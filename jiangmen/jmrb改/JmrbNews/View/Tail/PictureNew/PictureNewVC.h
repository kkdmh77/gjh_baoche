//
//  PictureNewVC.h
//  ZhongShangPaper
//
//  Created by Danny Deng on 12-2-22.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureNewInfoDetail.h"
#import "PictureShowView1VC.h"
#import "PictureShowView2VC.h"
@protocol PictureNewVCDelegate;

@interface PictureNewVC : UIViewController <PictureShowView1Delegate, PictureShowView2VCDelegate, PictureNewInfoDetailDelegate>{
    PictureShowView1VC *_pictureShowView1;
    PictureShowView2VC *_pictureShowView2;
}

@property (nonatomic, assign) IBOutlet UIView *titileView;
@property (nonatomic, assign) id<PictureNewVCDelegate> delegate;
@property (nonatomic, assign) IBOutlet UIView *showView;
@property (nonatomic, assign) IBOutlet UIButton *btnShowModel;

- (IBAction)clickChangeModel:(id)sender;
- (void)refreshPictureNews;

@end

@protocol PictureNewVCDelegate <NSObject>

@optional
- (void)PictureNewHideTarBar:(BOOL)isHide;

@end
