//
//  PersonNewsVC.h
//  ZhongShangPaper
//
//  Created by Danny Deng on 12-2-22.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PersonNewsVCDelegate ;

@interface PersonNewsVC : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate, UIAlertViewDelegate, UITextFieldDelegate> {
    UIImagePickerController *pickerController;
    UIImage *_pickerImage;
    BOOL _isDelPicture;
}

@property (nonatomic, assign) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, assign) id<PersonNewsVCDelegate> delegate;
@property (nonatomic, assign) IBOutlet UIButton *btnBaoliaoContent, *btnAddPicture;

@property (nonatomic, assign) IBOutlet UITextView *contentTextView;
@property (nonatomic, assign) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, assign) IBOutlet UITextField *txtBaoliaoPeople;
@property (nonatomic, assign) IBOutlet UITextField *txtTelephone;
@property (nonatomic, assign) IBOutlet UITextField *txtHappenTime;
@property (nonatomic, assign) IBOutlet UITextField *txtHappenAddress;
@property (nonatomic, assign) IBOutlet UIImageView *photoImageView;

@property (nonatomic, assign) IBOutlet UIButton *btnAddPhotoFromAlbum, *btnTakePhoto;
@property (nonatomic, assign) IBOutlet UIButton *btnSend, *btnTelephone;

@property (nonatomic, assign) IBOutlet UIView *contentView, *pictureView, *pictureTitleView;
@property (nonatomic, assign) IBOutlet UIView *gestureHideKeyBoardView;
@property (nonatomic, assign) IBOutlet UIButton *btnHideContent, *btnHidePicture;

- (IBAction)clickFindPhotoFromAlbum:(id)sender;
- (IBAction)clickTakePhoto:(id)sender;
- (IBAction)clickHideContentView:(id)sender;
- (IBAction)clickHidePictureView:(id)sender;
- (IBAction)clickCallPhone:(id)sender;
- (IBAction)clickSubmit:(id)sender;
- (IBAction)downDelPicture:(id)sender;
- (IBAction)upDelPicture:(id)sender;
- (IBAction)clickShowDatePicker:(id)sender;
- (IBAction)clickBack:(id)sender;

@end

@protocol PersonNewsVCDelegate <NSObject>

@optional
- (void)PersonNewsHideTarBar:(BOOL)isHide;

@end
