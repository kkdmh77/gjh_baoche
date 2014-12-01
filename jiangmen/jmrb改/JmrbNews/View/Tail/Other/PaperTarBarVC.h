//
//  PaperTarBarVC.h
//  ZhongShangPaper
//
//  Created by Danny Deng on 12-2-20.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PaperTarBarVCDelegate;

@interface PaperTarBarVC : UIViewController {
    
}

@property (nonatomic, assign) IBOutlet UIButton *btnMainPage, *btnList, *btnPicture, *btnPersonNews, *btnMore;
@property (nonatomic, assign) id<PaperTarBarVCDelegate> delegate;

- (IBAction)clickTarBar:(id)sender;

@end

@protocol PaperTarBarVCDelegate <NSObject>

@optional
- (void)tarBarSelectedItem:(NSInteger) item;

@end