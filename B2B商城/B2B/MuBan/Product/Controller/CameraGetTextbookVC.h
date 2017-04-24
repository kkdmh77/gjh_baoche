//
//  CameraGetTextbookVC.h
//  kkyingyu100
//
//  Created by 龚 俊慧 on 16/2/26.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import "LBXScanViewController.h"
#import "CameraToolBarView.h"

/*
 * @拍照识别
 */
@interface CameraGetTextbookVC : LBXScanViewController

@property (nonatomic, assign) CameraScanType scanType; // 扫描类型

- (instancetype)init UNAVAILABLE_ATTRIBUTE;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil UNAVAILABLE_ATTRIBUTE;

- (instancetype)initWtihCompleteHandle:(void (^) (NSString *resultStr))handle;

@end
