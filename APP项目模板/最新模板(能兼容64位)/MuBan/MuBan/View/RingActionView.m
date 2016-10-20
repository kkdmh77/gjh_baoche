//
//  BarActionView.m
//  kkpoem
//
//  Created by 龚 俊慧 on 2016/10/12.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import "RingActionView.h"
#import "M13ProgressViewRing.h"
#import "NetworkStatusManager.h"
#import "HUDManager.h"
#import "PRPAlertView.h"
#import "UserInfoModel.h"

#define PausedTitle         @"继续下载"
#define HaveNewVersionTitle @"更新"
#define NotDownloadTitle    @"下载"
#define DownloadingTitle    @"暂停"
#define HaveDownloadedTitle @"删除"
#define WaittingTitle       @"等待中"

extern NSString * const kStartBlockKey;
extern NSString * const kProgressBlockKey;
extern NSString * const kPauseBlockKey;
extern NSString * const kCompletionBlockKey;

@interface RingActionView ()

@property (nonatomic, assign) RingStatusType statusType; // defualt is RingStatusType_ToDownload

@property (weak, nonatomic) IBOutlet UIButton *actionBtn;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet M13ProgressViewRing *progressView;

@end

@implementation RingActionView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
}

#pragma mark - custom methods

- (void)configureViewsProperties
{
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    
    // _actionBtn.layer.cornerRadius = 2;
    _actionBtn.backgroundColor = [UIColor clearColor];
    
    _progressLabel.dk_fontPicker = DKFontWithSize(10);
    _progressLabel.dk_textColorPicker = DKColorWithColors(Common_LiteGrayColor, Common_LiteGrayColor_Night);
    
    _progressView.backgroundRingWidth = 2;
    _progressView.progressRingWidth = 2;
    _progressView.showPercentage = NO;
    _progressView.primaryColor = HEXCOLOR(0XAFAFAF);
    _progressView.secondaryColor = HEXCOLOR(0XE7E7E7);
    _progressView.userInteractionEnabled = NO;
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
    
    self.statusType = RingStatusType_ToDownload;
    self.fileType = -1;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    _actionBtn.layer.cornerRadius = cornerRadius;
}

- (void)setFileType:(DBFileType)fileType
{
    _fileType = fileType;
    
    [self setProgressValue:0];
    [self updateViewStatusWithFileType:fileType];
}

- (void)downloadAction
{
    [self clickActionBtn:_actionBtn];
}

- (void)configureDownloadHandlesWithFileType:(DBFileType)type
{
    NSString *key = @(type).stringValue;
    NSMutableDictionary *blocksDic = [[FileManager sharedInstance].downloadBlockDic safeObjectForKey:key];
    if (!blocksDic) {
        blocksDic = [[NSMutableDictionary alloc] init];
    }
    WEAKSELF
    [blocksDic setValue:^(DBFileType type) {
        [weakSelf updateViewStatusWithFileType:type];
        
        if (weakSelf.startDownloadHandle) {
            weakSelf.startDownloadHandle(weakSelf, type);
        }
    } forKey:kStartBlockKey];
    
    [blocksDic setValue:^(DBFileType type, CGFloat progress) {
        if (type == weakSelf.fileType) {
            [weakSelf updateViewStatusWithFileType:type];
            [weakSelf setProgressValue:progress];
            
            if (weakSelf.downloadingHandle) {
                weakSelf.downloadingHandle(weakSelf, type, progress);
            }
        }
    } forKey:kProgressBlockKey];
    
    [blocksDic setValue:^(DBFileType type) {
        [weakSelf updateViewStatusWithFileType:type];
        
        if (weakSelf.pausedHandle) {
            weakSelf.pausedHandle(weakSelf, type);
        }
    } forKey:kPauseBlockKey];
    
    [blocksDic setValue:^(DBFileType type, NSError *error) {
        if (type == weakSelf.fileType) {
            [weakSelf updateViewStatusWithFileType:type];
            [weakSelf setProgressValue:0];
            
            if (weakSelf.downloadCompletionHandle)
            {
                weakSelf.downloadCompletionHandle(weakSelf, type, error);
            }
        }
    } forKey:kCompletionBlockKey];
    [[FileManager sharedInstance].downloadBlockDic setValue:blocksDic forKey:key];
}

- (IBAction)clickActionBtn:(UIButton *)sender {
    if (_statusType == RingStatusType_ToDownload ||
        _statusType == RingStatusType_ToUpdate ||
        _statusType == RingStatusType_Paused)
    {
        if ([NetworkStatusManager isConnectNetwork])
        {
            if (_actionHandle)
            {
                _actionHandle(self, _statusType, sender);
            }
            
            [[FileManager sharedInstance] downloadPackageWithFileType:_fileType];
            [self configureDownloadHandlesWithFileType:_fileType];
            
            [self updateViewStatusWithFileType:_fileType];
        }
        else
        {
            [HUDManager showAutoHideHUDWithToShowStr:NoConnectionNetwork
                                             HUDMode:MBProgressHUDModeText];
        }
    }
    else if (_statusType == RingStatusType_Downloading)
    {
        DataPackageInfoModel *model = [[FileManager sharedInstance].dataPackageInfoDic safeObjectForKey:KKD_NSINETGER_2_NSSTRING(_fileType)];
        AFHTTPRequestOperation *operation = [self curDownloadOperationByPackageInfoModel:model];

        // 不是正在解压
        if (operation.executing && !model.isUpPackageing)
        {
            if (_actionHandle)
            {
                _actionHandle(self, _statusType, sender);
            }
            
            [operation pause];
        }
    }
    else if (_statusType == RingStatusType_ToDelete)
    {
        WEAKSELF
        [FileManager deleteDBFileWithType:self.fileType completeHandle:^{
            if (weakSelf.actionHandle)
            {
                weakSelf.actionHandle(weakSelf, weakSelf.statusType, sender);
            }
            
            [weakSelf updateViewStatusWithFileType:weakSelf.fileType];
        }];
    }
}

- (void)setProgressValue:(CGFloat)progressValue
{
    [_progressView setProgress:progressValue animated:NO];
    _progressLabel.dk_languageTextPicker = DKLanguageTextWithText([NSString stringWithFormat:@"%.0f%%", progressValue * 100]);
}

#pragma mark - tools methods

- (AFHTTPRequestOperation *)curDownloadOperationByPackageInfoModel:(DataPackageInfoModel *)model
{
    AFHTTPRequestOperation *operation = [[DownloadManager sharedInstance] dbZipDownloadingOperationWithUrlStr:model.downloadUrl];
    if (!operation) {
        operation = [[DownloadManager sharedInstance] dbZipDownloadingOperationWithUrlStr:model.patchUrl];
    }
    return operation;
}

- (void)setStatusType:(RingStatusType)statusType
{
    _statusType = statusType;
    
    _actionBtn.hidden = NO;
    _progressLabel.hidden = NO;
    _progressView.hidden = NO;
    
    // _actionBtn.userInteractionEnabled = YES;
    // _progressView.userInteractionEnabled = YES;
    
    switch (statusType) {
        case RingStatusType_Hide:
        {
            _actionBtn.hidden = YES;
            _progressLabel.hidden = YES;
            _progressView.hidden = YES;
        }
            break;
        case RingStatusType_ToDownload:
        {
            _progressLabel.hidden = YES;
            _progressView.hidden = YES;
            
            // _actionBtn.dk_backgroundColorPicker = DKColorWithColors(Common_InkBlackColor, Common_InkBlackColor);
            // [_actionBtn setTitle:NotDownloadTitle forState:UIControlStateNormal];
            
            [_actionBtn setImage:[UIImage imageNamed:@"ic_download"] forState:UIControlStateNormal];
        }
            break;
        case RingStatusType_ToUpdate:
        {
            _progressLabel.hidden = YES;
            _progressView.hidden = YES;
            
            // _actionBtn.dk_backgroundColorPicker = DKColorWithColors(Common_BlueColor, Common_BlueColor);
            // [_actionBtn setTitle:HaveNewVersionTitle forState:UIControlStateNormal];
            
            [_actionBtn setImage:[UIImage imageNamed:@"ic_update"] forState:UIControlStateNormal];
        }
            break;
        case RingStatusType_Downloading:
        {
            // _actionBtn.dk_backgroundColorPicker = DKColorWithColors([UIColor clearColor], [UIColor clearColor]);
            // [_actionBtn setTitle:DownloadingTitle forState:UIControlStateNormal];
            
            [_actionBtn setImage:nil forState:UIControlStateNormal];
        }
            break;
        case RingStatusType_Paused:
        {
            _progressLabel.hidden = YES;
            
            // _actionBtn.dk_backgroundColorPicker = DKColorWithColors(Common_RedColor, Common_RedColor);
            // [_actionBtn setTitle:PausedTitle forState:UIControlStateNormal];
            
            [_actionBtn setImage:[UIImage imageNamed:@"ic_downloading"] forState:UIControlStateNormal];
        }
            break;
        case RingStatusType_ToDelete:
        {
            _progressLabel.hidden = YES;
            _progressView.hidden = YES;
            
            // _actionBtn.dk_backgroundColorPicker = DKColorWithColors(Common_RedColor, Common_RedColor);
            // [_actionBtn setTitle:HaveDownloadedTitle forState:UIControlStateNormal];
            
            [_actionBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
            break;
            /*
            case RingStatusType_Waitting:
        {
            _actionBtn.userInteractionEnabled = NO;
            _progressView.userInteractionEnabled = NO;
            
            // _actionBtn.dk_backgroundColorPicker = DKColorWithColors(Common_BlueColor, Common_BlueColor);
            // [_actionBtn setTitle:WaittingTitle forState:UIControlStateNormal];
            
            [_actionBtn setImage:[UIImage imageNamed:@"pictureBook_pause"] forState:UIControlStateNormal];
        }
            break;
            */
        default:
            break;
    }
}

// 更新每个下载情况的状态
- (void)updateViewStatusWithFileType:(DBFileType)type
{
    if (type != _fileType)
    {
        return;
    }
    
    FileExsitType fileExsitType = [FileManager dbFileExsitTypeWithDBFileType:type];
    NSString *filePath = [FileManager getFilePathByFileType:type];
    DataPackageInfoModel *model = [[FileManager sharedInstance].dataPackageInfoDic safeObjectForKey:KKD_NSINETGER_2_NSSTRING(type)];
    AFHTTPRequestOperation *operation = [self curDownloadOperationByPackageInfoModel:model];

    // 存在已下载的数据库包文件
    if (IsFileExists(filePath))
    {
        // 只显示更新状态
        if (_accessoryType == BarAccessoryType_Update)
        {
            // 有更新
            if (model.hasNewVersion || NeedUpDate == fileExsitType || HasNewVersion == fileExsitType)
            {
                self.statusType = RingStatusType_ToUpdate;
            }
            else
            {
                self.statusType = RingStatusType_Hide;
            }
        }
        // 只显示删除状态
        else if (_accessoryType == BarAccessoryType_Delete)
        {
            self.statusType = RingStatusType_ToDelete;
        }
    }
    // 没有数据包的情况
    else
    {
        self.statusType = RingStatusType_ToDownload;
    }
    
    if (operation)
    {
        // 正在下载
        if (operation.isExecuting || model.isUpPackageing)
        {
            [self setProgressValue:model.percentDone];
            
            self.statusType = RingStatusType_Downloading;
        }
        // 判断是不是处于暂停状态,手动点击了暂停后model.isDownLoading还是YES
        else if ([operation isPaused])
        {
            [self setProgressValue:model.percentDone];
            
            self.statusType = RingStatusType_Paused;
        }
        /*
        // 在队列中等待
        else
        {
            self.statusType = RingStatusType_Waitting;
        }
         */
    }
    // 有下载时产生的临时文件也是处于暂停状态
    else if (IsFileExists([AFDownloadRequestOperation tempPathWithTargetPath:[FileManager getFileDownladTargetPathWithDownloadUrl:model.downloadUrl]]) ||
             IsFileExists([AFDownloadRequestOperation tempPathWithTargetPath:[FileManager getFileDownladTargetPathWithDownloadUrl:model.patchUrl]]))
    {
        [self setProgressValue:model.percentDone];
        
        self.statusType = RingStatusType_Paused;
    }
}

@end
