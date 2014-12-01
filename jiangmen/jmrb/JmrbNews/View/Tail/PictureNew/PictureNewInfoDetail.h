//
//  MainPageNewInfoDetail.h
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-13.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#import <UIKit/UIKit.h>
#import "PictureNewInfoDetailContent.h"
#import "MPNewInfoDetailContent.h"


@protocol PictureNewInfoDetailDelegate;

@interface PictureNewInfoDetail : UIViewController<UIActionSheetDelegate> {
    MPNewInfoDetailContent *_infoContent;
    MPNewInfoDetailContent *_infoContent1;
    NSInteger currentNewItem;
    NSInteger fontSize;
}

@property (nonatomic, assign) id<PictureNewInfoDetailDelegate> delegate;
@property (nonatomic, assign) IBOutlet UIView *fullTopView, *fullTailView, *halfTopView, *halfTailView;
@property (nonatomic, assign) IBOutlet UILabel *newsTitle;
@property (nonatomic, assign) IBOutlet UILabel *replayNumText;
@property (nonatomic, assign) IBOutlet UIButton *btnNext,*btnPre, *btnNext1,*btnPre1;
@property (nonatomic, retain) NSArray *newsArray;
@property (nonatomic, assign) IBOutlet UIButton *btnKeep, *btnKeep1;
@property (nonatomic, assign) IBOutlet UISlider *fontSlider, *fontSlider1;

- (IBAction)clickBack:(id)sender;
- (IBAction)clickFullScreen:(id)sender;
- (IBAction)clickHalfScreen:(id)sender;
- (IBAction)clickNextNews:(id)sender;
- (IBAction)clickPreNews:(id)sender;
- (IBAction)clickShare:(id)sender;
- (IBAction)clickDiscuss:(id)sender;
- (IBAction)clickDiscussSend:(id)sender;
- (IBAction)clickKeep:(id)sender;
- (IBAction)dragSlider:(id)sender;

- (void)setNewsContent:(NSInteger ) itemId;
- (void)initFrame; 

@end

@protocol PictureNewInfoDetailDelegate <NSObject>

@optional
- (void)PictureNewInfoDetailGoBack;
- (void)PictureNewInfoShowTarBar;
- (void)PictureNewInfoGoBack;

@end


