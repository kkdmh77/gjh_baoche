//
//  CameraGetTextbookVC.m
//  kkyingyu100
//
//  Created by 龚 俊慧 on 16/2/26.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import "CameraGetTextbookVC.h"
#import "CameraToolBarView.h"
#import "PRPAlertView.h"
#import "BaseNetworkViewController+NetRequestManager.h"
#import "HUDManager.h"
#import "PRPAlertView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

#define kScanW_HRatio           1 / 1.4                  // 照相机中间高亮区域的宽高比
#define kUMScanResultCountKey   @"kUMScanResultCountKey" // 友盟统计拍照结果数量的key

@interface CameraGetTextbookVC ()

@property (nonatomic, strong) CameraToolBarView *cameraToolBar;
@property (nonatomic, strong) UINavigationBar *navBar;
@property (nonatomic, strong) UILabel *cameraNoticeLabel;

@property (nonatomic, strong) UIView *popBgView;

@property (nonatomic, copy) void (^handle)(NSString *);

@end

@implementation CameraGetTextbookVC

- (instancetype)initWtihCompleteHandle:(void (^)(NSString *))handle {
    self = [super init];
    
    if (self) {
        self.handle = handle;
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     // self.fd_prefersNavigationBarHidden = YES;
    
     [self initialization];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self.view bringSubviewToFront:_navBar];
    [self.view bringSubviewToFront:_cameraToolBar];
    [self.view bringSubviewToFront:_cameraNoticeLabel];
    
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.fd_interactivePopDisabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)initialization
{
    // 设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc] init];
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.colorAngle = kCurThemeColor;
    style.photoframeLineW = 3;
    style.photoframeAngleW = 20;
    style.photoframeAngleH = 20;
    style.isNeedShowRetangle = NO;
    style.anmiationStyle = LBXScanViewAnimationStyle_None;
    [self configureScanViewStyleSize:style scanType:_scanType];
    
    self.scanViewStyle = style;
    self.isOpenInterestRect = YES;
   
    // 提示
    self.cameraNoticeLabel = InsertLabel(self.view, CGRectZero, NSTextAlignmentCenter, @"", nil, nil, NO);
    _cameraNoticeLabel.dk_fontPicker = DKFontWithSize(12);
    _cameraNoticeLabel.dk_textColorPicker = DKColorWithColors([UIColor whiteColor], [UIColor whiteColor]);
    [self updateCameraNoticeLabelPositionWithScanType:_scanType];
    
    /*
    // 导航栏
    // 闪关灯和相册按钮
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, STATUS_BAR_HEIGHT + NAV_BAR_HEIGHT)];
    [navBar setBackgroundImage:[UIImage imageWithColor:[kCurThemeColor colorWithAlphaComponent:0.8]]
                 forBarMetrics:UIBarMetricsDefault];
    navBar.shadowImage = [UIImage new];
    [self.view addSubview:navBar];
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    item.rightBarButtonItem = [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Left
                                                       normalPicker:DKImageWithNames(@"btn_close_boy_normal", @"btn_close_girl_normal")
                                            normalHighlightedPicker:DKImageWithNames(@"btn_close_boy_pressed", @"btn_close_girl_pressed")
                                                             action:@selector(backViewController)];
    self.navigationItem.leftBarButtonItem = nil;
    item.leftBarButtonItem = [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Right
                                                        normalPicker:DKImageWithNames(@"btn_light_boy_off_normal", @"btn_light_girl_off_normal")
                                             normalHighlightedPicker:DKImageWithNames(@"btn_light_boy_off_pressed", @"btn_light_girl_off_pressed")
                                                      selectedPicker:DKImageWithNames(@"btn_light_boy_on_normal", @"btn_light_girl_on_normal")
                                           selectedHighlightedPicker:DKImageWithNames(@"btn_light_boy_on_pressed", @"btn_light_girl_on_pressed")
                                                          isSelected:NO
                                                              action:@selector(clickFlashStatusBtn:)];
    self.navigationItem.rightBarButtonItem = nil;
    navBar.items = @[item];
    self.navBar = navBar;
    */
    
    /*
    WEAKSELF
    // 底部工具栏
    CameraToolBarView *bottomToolBar = [CameraToolBarView loadFromNib];
    _cameraToolBar = bottomToolBar;
    [self.view addSubview:bottomToolBar];
    [bottomToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    bottomToolBar.scanType = _scanType;
    bottomToolBar.actionHandle = ^(CameraToolBarView *view, CameraBarActionType actionType, id sender) {
        if (CameraBarActionType_ChangeScanType == actionType) {
            if (CameraScanType_All_BarCode == view.scanType) {
                // weakSelf.scanViewStyle.whRatio = 1;
                [weakSelf.scanObj.scanNativeObj changeScanType:[weakSelf.scanObj.scanNativeObj defaultMetaDataObjectTypes]];
            } else {
                // weakSelf.scanViewStyle.whRatio = kScanW_HRatio;
                [weakSelf.scanObj.scanNativeObj changeScanType:@[AVMetadataObjectTypeAztecCode]];
            }
            weakSelf.scanType = view.scanType;
            [weakSelf configureScanViewStyleSize:weakSelf.scanViewStyle scanType:view.scanType];
            [weakSelf refreshScanViewStyle];
            [weakSelf updateCameraNoticeLabelPositionWithScanType:view.scanType];
        } else {
            [weakSelf.scanObj.scanNativeObj takePicture:^(UIImage *image) {
                // 停止scan
                [weakSelf.scanObj stopScan];
                
            }];
        }
    };
    */
    
    /*
    // pop 背景视图
    self.popBgView = InsertView(self.view, CGRectMake(0, CGRectGetMaxY(navBar.frame), IPHONE_WIDTH, IPHONE_HEIGHT - CGRectGetMaxY(navBar.frame)));
    [_popBgView keepAutoresizingInFull];
    _popBgView.backgroundColor = [UIColor clearColor];
     */
}

- (void)hideFlashItem:(BOOL)hide
{
    WEAKSELF
    [_navBar animationFadeWithExecuteBlock:^{
        UINavigationItem *item = weakSelf.navBar.items[0];
        
        for (UIBarButtonItem *barBtnItem in item.leftBarButtonItems) {
            barBtnItem.customView.hidden = hide;
        }
    }];
}

// 获取扫描区域的宽高比
- (CGFloat)ratioByScanType:(CameraScanType)type
{
    if (CameraScanType_All_BarCode == type)
    {
        return 1;
    }
    else
    {
        CGFloat navBarHeight = 64;
        CGFloat bottomBarHeight = CameraScanType_BookPageOnly == type ? 105 : 140;
        CGFloat heightWithoutBar = IPHONE_HEIGHT - bottomBarHeight - navBarHeight;
        
        CGFloat margin = [self marginByScanType:type];
        CGFloat cameraAreWidth = IPHONE_WIDTH - margin * 2;

        CGFloat ratio = cameraAreWidth / (heightWithoutBar - 30 * 2); // 除去显示文字的高度
        
        return MIN(ratio, 1);
    }
}

// 获取扫描区域离界面左边及右边距离
- (CGFloat)marginByScanType:(CameraScanType)type
{
    if (CameraScanType_All_BarCode == type)
    {
        return kGetScaleValueBaseIP6(70);
    }
    else
    {
        return iPhone4 ? 47 : 20;
    }
}

// 设置扫描取景范围
- (void)configureScanViewStyleSize:(LBXScanViewStyle *)scanStyleView scanType:(CameraScanType)type
{
    scanStyleView.whRatio = [self ratioByScanType:type];
    scanStyleView.xScanRetangleOffset = [self marginByScanType:type];
    // scanStyleView.centerUpOffset = (CameraScanType_BookPageOnly == type ? 30 : 46);
    scanStyleView.centerUpOffset = 30;
}

- (void)updateCameraNoticeLabelPositionWithScanType:(CameraScanType)type
{
    CGFloat navBarHeight = 64;
    CGFloat bottomBarHeight = /*CameraScanType_BookPageOnly == type ? 105 : 140*/ 0;
    CGFloat heightWithoutBar = IPHONE_HEIGHT - bottomBarHeight - navBarHeight;
    CGFloat cameraAreHeight = (IPHONE_WIDTH - [self marginByScanType:type] * 2) / [self ratioByScanType:type];
    CGFloat topMargin = (heightWithoutBar - cameraAreHeight) / 2;
    
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^
    {
        [_cameraNoticeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.view.mas_top).offset(@(topMargin + cameraAreHeight - 20));
        }];
        [self.view layoutIfNeeded];
        
        if (CameraScanType_All_Textbook == type) {
            _cameraNoticeLabel.text = @"尽量将课本封面放入框内再拍照更准确哦";
        } else if (CameraScanType_All_BarCode == type) {
            _cameraNoticeLabel.text = @"将条形码放入框内，即可自动扫描";
        } else {
            _cameraNoticeLabel.text = @"尽量将课本放入框内再拍照更准确哦";
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (void)clickFlashStatusBtn:(UIButton *)sender
{
    [self openOrCloseFlash];
    
    sender.selected = self.isOpenFlash;
}

- (void)clickAlbumBtn:(UIButton *)sender
{
    [self openLocalPhoto];
}

// 照相机和相册等权限错误的提示
- (void)showError:(NSString *)str
{
    [PRPAlertView showWithTitle:str
                        message:nil
                    buttonTitle:LocalizedStr(All_Confirm)];
}

// 扫描结果回调方法（摄像头和识别相册图片）
- (void)scanResultWithArray:(NSArray<LBXScanResult*> *)array
{
    if (![array isValidArray])
    {
        return;
    }
    
    LBXScanResult *scanResult = array[0];
    NSString *strResult = scanResult.strScanned;
    
    if (!strResult) {
        return;
    }
    
    if (_handle) {
        _handle(strResult);
    }
    
    // 震动提醒
    [LBXScanWrapper systemVibrate];
    // 声音提醒
    [LBXScanWrapper systemSound];
}

- (void)rescanByShowNoticeMessage:(NSString *)message
{
    [PRPAlertView showWithTitle:message
                        message:nil
                    cancelTitle:nil
                    cancelBlock:nil
                     otherTitle:LocalizedStr(All_Confirm)
                     otherBlock:^
     {
         // 重新扫描
         [self.scanObj startScan];
     }];
}

@end
