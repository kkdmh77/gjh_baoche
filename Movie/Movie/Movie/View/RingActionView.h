//
//  BarActionView.h
//  kkpoem
//
//  Created by 龚 俊慧 on 2016/10/12.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileManager.h"

@class RingActionView;

typedef NS_ENUM(NSInteger, RingStatusType)
{
    /// 不显示
    RingStatusType_Hide = -1,
    /// 去下载
    RingStatusType_ToDownload = 0,
    /// 去更新
    RingStatusType_ToUpdate,
    /// 正在下载
    RingStatusType_Downloading,
    /// 暂停中
    RingStatusType_Paused,
    /// 删除
    RingStatusType_ToDelete,
    /*
    /// 队列中
    RingStatusType_Waitting
     */
};

typedef NS_ENUM(NSInteger, RingAccessoryType)
{
    /// 更新
    BarAccessoryType_Update = 0,
    /// 删除
    BarAccessoryType_Delete
};

typedef void (^RingActionHandle) (RingActionView *view, RingStatusType actionType, UIButton *sender);

@interface RingActionView : UIView

@property (nonatomic, assign) RingAccessoryType accessoryType; // 如果功能包存在，更新和删除的显示只能二选一
@property (nonatomic, assign) DBFileType fileType; // defualt is -1，需要先设置accessoryType值

@property (nonatomic, copy  ) RingActionHandle actionHandle;
@property (nonatomic, copy  ) void (^startDownloadHandle) (RingActionView *view, DBFileType fileType);
@property (nonatomic, copy  ) void (^downloadCompletionHandle) (RingActionView *view, DBFileType fileType, NSError *error);
@property (nonatomic, copy  ) void (^downloadingHandle) (RingActionView *view, DBFileType fileType, CGFloat progress);
@property (nonatomic, copy  ) void (^pausedHandle) (RingActionView *view, DBFileType fileType);

@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign, readonly) RingStatusType statusType;

- (void)updateViewStatusWithFileType:(DBFileType)type;

/// 配置下载回调blcok,必须在设置完所有downloadHandle后调用
- (void)configureDownloadHandlesWithFileType:(DBFileType)type;

/// 触发下载事件
- (void)downloadAction;

@end
