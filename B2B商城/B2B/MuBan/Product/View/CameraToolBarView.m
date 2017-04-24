//
//  CameraToolBarView.m
//  kkyingyu100
//
//  Created by 龚 俊慧 on 16/4/16.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import "CameraToolBarView.h"

@interface CameraToolBarView ()

@property (weak, nonatomic) IBOutlet UIView *pointView;
@property (weak, nonatomic) IBOutlet UIView *typeBgView;        // 照相机类型按钮背景
@property (weak, nonatomic) IBOutlet UIButton *scanTextbookBtn; // 拍课本
@property (weak, nonatomic) IBOutlet UIButton *scanBarCodeBtn;  // 扫条形码
@property (weak, nonatomic) IBOutlet UIButton *takePhotoBtn;    // 拍照

@end

@implementation CameraToolBarView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
}

#pragma mark - custom methods

- (void)configureViewsProperties
{
    UIColor *normalTextColor = HEXCOLORAL(0XFFFFFF, 0.7);
    UIColor *highlightTextColor = [UIColor whiteColor];
    
    self.dk_backgroundColorPicker = DKColorWithColors(kCurThemeColor, kCurThemeColor);
    
    _pointView.dk_backgroundColorPicker = DKColorWithColors(highlightTextColor, highlightTextColor);
    [_pointView setRadius:2];

    _typeBgView.backgroundColor = [UIColor clearColor];
    
    _scanTextbookBtn.titleLabel.dk_fontPicker = DKFontWithSize(15);
    [_scanTextbookBtn dk_setTitleColorPicker:DKColorWithColors(normalTextColor, normalTextColor)
                                    forState:UIControlStateNormal];
    [_scanTextbookBtn dk_setTitleColorPicker:DKColorWithColors(highlightTextColor, highlightTextColor)
                                    forState:UIControlStateSelected];
    
    _scanBarCodeBtn.titleLabel.dk_fontPicker = DKFontWithSize(15);
    [_scanBarCodeBtn dk_setTitleColorPicker:DKColorWithColors(normalTextColor, normalTextColor)
                                   forState:UIControlStateNormal];
    [_scanBarCodeBtn dk_setTitleColorPicker:DKColorWithColors(highlightTextColor, highlightTextColor)
                                   forState:UIControlStateSelected];
    
    _takePhotoBtn.backgroundColor = [UIColor clearColor];
//    [_takePhotoBtn dk_setBackgroundImage:DKImageWithNames(@"btn_take_normal", @"btn_take_normal")
//                                forState:UIControlStateNormal];
//    [_takePhotoBtn dk_setBackgroundImage:DKImageWithNames(@"btn_take_pressed", @"btn_take_pressed")
//                                forState:UIControlStateHighlighted];
}

- (void)setup
{
    [self configureViewsProperties];
    
    // self.scanType = CameraScanType_All_Textbook;
}

- (void)setScanType:(CameraScanType)scanType
{
    _scanType = scanType;
    
    _typeBgView.hidden = NO;
    _scanTextbookBtn.selected = NO;
    _scanBarCodeBtn.selected = NO;
    
    WEAKSELF
    void (^animationBlock) () = nil;
    
    switch (scanType) {
        case CameraScanType_BookPageOnly:
        {
            animationBlock = ^ {
                [weakSelf.typeBgView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@(0));
                }];
                [weakSelf.pointView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@(0));
                }];
                
                // CGFloat height = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
                [weakSelf mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@(102));
                }];
                
                weakSelf.typeBgView.hidden = YES;
                weakSelf.takePhotoBtn.hidden = NO;
            };
        }
            break;
        case CameraScanType_All_Textbook:
        {
            animationBlock = ^{
                [weakSelf.typeBgView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@(35));
                }];
                [weakSelf.pointView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@(4));
                }];
                [weakSelf.typeBgView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.mas_centerX).offset(@(42.5));
                }];
                
                weakSelf.takePhotoBtn.hidden = NO;
                weakSelf.scanTextbookBtn.selected = YES;
                
                // CGFloat height = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
                [weakSelf mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@(141));
                }];
            };
        }
            break;
        case CameraScanType_All_BarCode:
        {
            animationBlock = ^{
                [weakSelf.typeBgView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@(35));
                }];
                [weakSelf.pointView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@(4));
                }];
                [weakSelf.typeBgView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.mas_centerX).offset(@(-42.5));
                }];
                
                weakSelf.takePhotoBtn.hidden = YES;
                weakSelf.scanBarCodeBtn.selected = YES;
                
                // CGFloat height = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
                [weakSelf mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@(141));
                }];
            };
        }
            break;
        default:
            break;
    }
    
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.8
                        options:UIViewAnimationOptionCurveEaseIn animations:^{
        animationBlock();
                            
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)clickActionBtn:(id)sender
{
    CameraBarActionType type;
    
    if (sender == _scanTextbookBtn)
    {
        self.scanType = CameraScanType_All_Textbook;
        type = CameraBarActionType_ChangeScanType;
    }
    else if (sender == _scanBarCodeBtn)
    {
        self.scanType = CameraScanType_All_BarCode;
        type = CameraBarActionType_ChangeScanType;
    }
    else
    {
        type = CameraBarActionType_TakePhoto;
    }
    
    if (_actionHandle)
    {
        _actionHandle(self, type, sender);
    }
}

@end
