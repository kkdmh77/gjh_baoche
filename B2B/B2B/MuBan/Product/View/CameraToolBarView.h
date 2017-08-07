//
//  CameraToolBarView.h
//  kkyingyu100
//
//  Created by 龚 俊慧 on 16/4/16.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import "BaseView.h"

@class CameraToolBarView;

typedef NS_ENUM(NSInteger, CameraScanType)
{
    /// 只有扫描课本内页
    CameraScanType_BookPageOnly = 0,
    /// 扫描课本&条形码，默认选择到课本封面
    CameraScanType_All_Textbook,
    /// 扫描课本&条形码，默认选择到条形码
    CameraScanType_All_BarCode
};

typedef NS_ENUM(NSInteger, CameraBarActionType)
{
    /// 拍照
    CameraBarActionType_TakePhoto = 0,
    /// 切换模式
    CameraBarActionType_ChangeScanType
};

typedef void (^CameraBarActionHandle) (CameraToolBarView *view,
                                       CameraBarActionType actionType,
                                       id sender);

@interface CameraToolBarView : BaseView

@property (nonatomic, assign) CameraScanType scanType;
@property (nonatomic, copy  ) CameraBarActionHandle actionHandle;

@end
