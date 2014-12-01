//
//  BaoLiaoActiveViewController.h
//  JmrbNews
//
//  Created by dean on 12-12-3.
//
//

#import <UIKit/UIKit.h>


@protocol BaoLiaoActiveViewDelegate;

@interface BaoLiaoActiveViewController : UIViewController<UIScrollViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UIActionSheetDelegate>{
    
}


@property (nonatomic, assign) id<BaoLiaoActiveViewDelegate> delegate;
@property (nonatomic, assign) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, assign) IBOutlet UIImageView *userimage;

@property (nonatomic, assign) IBOutlet UITextField *txtBaoliaoPeople;
@property (nonatomic, assign) IBOutlet UITextField *txtTitel;
@property (nonatomic, assign) IBOutlet UITextField *txtTelephone;
@property (nonatomic, assign) IBOutlet UITextField *txtHappenTime;
@property (nonatomic, assign) IBOutlet UITextField *txtHappenAddress;
@property (nonatomic, assign) IBOutlet UITextView *contentTextView;

@property (nonatomic, assign) IBOutlet UIDatePicker *datePicker;

- (IBAction)clickBack:(id)sender;

- (IBAction)clickSend:(id)sender;
- (IBAction)clickCamera:(id)sender;
- (IBAction)doEditFieldDone:(id)sender ;


@end


@protocol BaoLiaoActiveViewDelegate <NSObject>

@optional

- (void)BaoLiaoActiveViewHideTarBar:(BOOL)isHide;

@end
