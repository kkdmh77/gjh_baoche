//
//  PersonNewsVC.m
//  ZhongShangPaper
//
//  Created by Danny Deng on 12-2-22.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import "PersonNewsVC.h"
#import "ImageContant.h"
#import "QuartzCore/QuartzCore.h"
#import "ZSCommunicateModel.h"

@interface PersonNewsVC ()

- (void)dateChanged:(id)sender;
- (void)hideKeyBoard;
- (void)delSendPicture;
- (void)notificationBaoLiaoSuccess;
- (void)notificationBaoLiaoFail;

@end

@implementation PersonNewsVC
@synthesize datePicker;
@synthesize pictureView, pictureTitleView, contentView;
@synthesize delegate;
@synthesize contentScrollView;
@synthesize contentTextView;
@synthesize btnSend, btnTakePhoto, btnAddPicture, btnBaoliaoContent, btnAddPhotoFromAlbum;
@synthesize txtTelephone, txtHappenTime, txtBaoliaoPeople, txtHappenAddress;
@synthesize photoImageView;
@synthesize gestureHideKeyBoardView;
@synthesize btnHideContent, btnHidePicture;
@synthesize btnTelephone;

#pragma mark - Private
- (void)dateChanged:(id)sender {
    NSDate *date = [datePicker date];
    NSString *dateString = getStringFromDate(@"YYYY年MM月dd日 hh:mm a", date);
    [txtHappenTime setText:dateString];
}

- (void)delSendPicture {
    if (_isDelPicture && _pickerImage) {
        [btnAddPhotoFromAlbum setBackgroundColor:[UIColor clearColor]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认清空图片？" message:nil delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alert show];
        [alert release];
    }
}

- (void)hideKeyBoard {
    if (txtBaoliaoPeople.text && [txtBaoliaoPeople.text length]>6) {
        NSRange range;
        range.length = 6;
        range.location = 0;
        NSString *nameString = [txtBaoliaoPeople.text substringWithRange:range];
        [txtBaoliaoPeople setText:nameString];
    }
    if (txtHappenAddress.text && [txtHappenAddress.text length]>50) {
        NSRange range;
        range.length = 50;
        range.location = 0;
        NSString *nameString = [txtHappenAddress.text substringWithRange:range];
        [txtHappenAddress setText:nameString];
    }
    [txtTelephone resignFirstResponder];
    [txtHappenTime resignFirstResponder];
    [txtHappenAddress resignFirstResponder];
    [txtBaoliaoPeople resignFirstResponder];
    [contentTextView resignFirstResponder];
}

#pragma mark - View lifecycle
- (void)dealloc {
    [_pickerImage release];
    [pickerController release];
    [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated {
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:More_Login_Name];
    if (name) {
        [txtBaoliaoPeople setText:name];
        [txtBaoliaoPeople setEnabled:NO];
    }
    else {
        [txtBaoliaoPeople setEnabled:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *dateString = getStringFromDate(@"YYYY年MM月dd日 hh:mm a", [NSDate date]);
    [txtHappenTime setPlaceholder:dateString];
    [txtHappenTime setText:dateString];
    
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    [datePicker setCenter:CGPointMake(160, 480+datePicker.frame.size.height)];
    [txtHappenTime setInputView:datePicker];
    
    [txtBaoliaoPeople setDelegate:self];
    [txtHappenAddress setDelegate:self];
    
    UIImage *image, *image1;
//    UIImage *image = [UIImage imageByName:@"BaoLiao_bg_Line" withExtend:@"png"];
//    [self.contentTextView setBackgroundColor:[UIColor colorWithPatternImage:image]];
    [self.contentScrollView setContentSize:CGSizeMake(320, 540)];
    pickerController = [[UIImagePickerController alloc] init];
    [pickerController setDelegate:self];
    [self.contentScrollView setDelegate:self];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(320-50, 0, 50, 25)];
    [btn addTarget:self action:@selector(hideKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    image = [UIImage imageByName:@"close_keyborad_button" withExtend:@"png"];
    image1 = [UIImage imageByName:@"close_keyborad_button_tapped" withExtend:@"png"];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:image1 forState:UIControlStateHighlighted];
    [contentTextView setInputAccessoryView:view];
    [contentTextView.inputAccessoryView addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(320-50, 0, 50, 25)];
    [btn addTarget:self action:@selector(hideKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    image = [UIImage imageByName:@"close_keyborad_button" withExtend:@"png"];
    image1 = [UIImage imageByName:@"close_keyborad_button_tapped" withExtend:@"png"];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:image1 forState:UIControlStateHighlighted];
    [txtTelephone setInputAccessoryView:view];
    [txtTelephone.inputAccessoryView addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(320-50, 0, 50, 25)];
    [btn addTarget:self action:@selector(hideKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    image = [UIImage imageByName:@"close_keyborad_button" withExtend:@"png"];
    image1 = [UIImage imageByName:@"close_keyborad_button_tapped" withExtend:@"png"];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:image1 forState:UIControlStateHighlighted];
    [txtHappenTime setInputAccessoryView:view];
    [txtHappenTime.inputAccessoryView addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(320-50, 0, 50, 25)];
    [btn addTarget:self action:@selector(hideKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    image = [UIImage imageByName:@"close_keyborad_button" withExtend:@"png"];
    image1 = [UIImage imageByName:@"close_keyborad_button_tapped" withExtend:@"png"];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:image1 forState:UIControlStateHighlighted];
    [txtHappenAddress setInputAccessoryView:view];
    [txtHappenAddress.inputAccessoryView addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(320-50, 0, 50, 25)];
    [btn addTarget:self action:@selector(hideKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    image = [UIImage imageByName:@"close_keyborad_button" withExtend:@"png"];
    image1 = [UIImage imageByName:@"close_keyborad_button_tapped" withExtend:@"png"];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:image1 forState:UIControlStateHighlighted];
    [txtBaoliaoPeople setInputAccessoryView:view];
    [txtBaoliaoPeople.inputAccessoryView addSubview:btn];

    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [gesture setMinimumPressDuration:0.01];
    [gestureHideKeyBoardView addGestureRecognizer:gesture];
    [gesture release];
    
    [view release];
    _isDelPicture = NO;
    
    [btnHidePicture setSelected:YES];
    CGPoint picturePoint, sendPoint,telephonePoint;
    picturePoint = [pictureView center];
    sendPoint = [btnSend center];
    telephonePoint = [btnTelephone center];
    [pictureView setCenter:CGPointMake(picturePoint.x, picturePoint.y-190)];
    [btnSend setCenter:CGPointMake(sendPoint.x, sendPoint.y-190)];
    [btnTelephone setCenter:CGPointMake(telephonePoint.x, telephonePoint.y-190)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationBaoLiaoSuccess) name:Notification_SendBaoLiaoSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationBaoLiaoFail) name:Notification_SendBaoLiaoFail object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationBaoLiaoFail) name:Notification_SendBaoLiao_Error object:nil];
}

#pragma mark - xib function
- (IBAction)clickShowDatePicker:(id)sender {
    if ([datePicker center].y > 480) {
        [UIView animateWithDuration:.5 animations:^{
            [datePicker setCenter:CGPointMake(160, 328)]; 
        }completion:^(BOOL finish) {
            
        }];
    }
    else {
        [UIView animateWithDuration:.5 animations:^{
            [datePicker setCenter:CGPointMake(160, 480+datePicker.frame.size.height)]; 
        }completion:^(BOOL finish) {
            
        }];
    }
}

- (IBAction)downDelPicture:(id)sender {
    [btnAddPhotoFromAlbum setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.4]];
    _isDelPicture = YES;
    [self performSelector:@selector(delSendPicture) withObject:nil afterDelay:1];
}

- (IBAction)upDelPicture:(id)sender {
    [btnAddPhotoFromAlbum setBackgroundColor:[UIColor clearColor]];
    _isDelPicture = NO;
}

- (IBAction)clickSubmit:(id)sender {
    if (txtBaoliaoPeople.text==nil || [txtBaoliaoPeople.text length] == 0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请填写报料人姓名" message:nil delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    if (txtTelephone.text==nil || [txtTelephone.text length] == 0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请填写联系电话" message:nil delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    if (txtHappenTime.text==nil || [txtHappenTime.text length] == 0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请填写发生时间" message:nil delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    if (txtHappenAddress.text==nil || [txtHappenAddress.text length] == 0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请填写发生地点" message:nil delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    if (contentTextView.text==nil || [contentTextView.text length] == 0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请填写事件内容" message:nil delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSString *reportId = [[[NSUserDefaults standardUserDefaults] objectForKey:More_Login_Reporter_id] stringValue];
    if (reportId == nil || [reportId length] == 0) {
        reportId = @"0";
    }
    [infoDic setObject:reportId forKey:Key_BaoLiao_Category];
    if (txtBaoliaoPeople.text) {
        [infoDic setObject:txtBaoliaoPeople.text forKey:Key_BaoLiao_baoLiaoPerson];
    }
    else {
        [infoDic setObject:@"" forKey:Key_BaoLiao_baoLiaoPerson];
    }
    
    if (txtTelephone.text) {
        [infoDic setObject:txtTelephone.text forKey:Key_BaoLiao_Telephone];
    }
    else {
        [infoDic setObject:@"" forKey:Key_BaoLiao_Telephone];
    }
    
    if (txtHappenTime.text) {
        [infoDic setObject:txtHappenTime.text forKey:Key_BaoLiao_StartTime];
    }
    else {
        [infoDic setObject:@"" forKey:Key_BaoLiao_StartTime];
    }
    
    if (txtHappenAddress.text) {
        [infoDic setObject:txtHappenAddress.text forKey:Key_BaoLiao_HappenAddress];
    }
    else {
        [infoDic setObject:@"" forKey:Key_BaoLiao_HappenAddress];
    }
    
    if (contentTextView.text) {
        [infoDic setObject:contentTextView.text forKey:Key_BaoLiao_Content];
    }
    else {
        [infoDic setObject:@"" forKey:Key_BaoLiao_Content];
    }
    [[ZSCommunicateModel defaultCommunicate] sendBaoLiaoImage:_pickerImage Info:infoDic];
    [infoDic release];
}

- (IBAction)clickCallPhone:(id)sender {
    BOOL callSuccess = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:076088881111"]];
    if (!callSuccess) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"设备不支持电话功能" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

- (IBAction)clickFindPhotoFromAlbum:(id)sender {
    if (delegate && [delegate respondsToSelector:@selector(PersonNewsHideTarBar:)]) {
        [delegate PersonNewsHideTarBar:YES];
    }
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentModalViewController:pickerController animated:YES];
}

- (IBAction)clickTakePhoto:(id)sender {
    if (delegate && [delegate respondsToSelector:@selector(PersonNewsHideTarBar:)]) {
        [delegate PersonNewsHideTarBar:YES];
    }
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentModalViewController:pickerController animated:YES];
}

- (IBAction)clickHideContentView:(id)sender {
    UIButton *clickBtn = (UIButton *)sender;
    NSInteger changeInt = 270;
    [self hideKeyBoard];
    UIButton *btn = btnHideContent;
    [clickBtn setEnabled:NO];
    CGPoint contentPoint,pictureTitlePoint,picturePoint, sendPoint, telephonePoint;
    contentPoint = [contentView center];
    pictureTitlePoint = [pictureTitleView center];
    picturePoint = [pictureView center];
    sendPoint = [btnSend center];
    telephonePoint = [btnTelephone center];
    if ([btn isSelected]) {
        [UIView animateWithDuration:.5 animations:^{
            [contentView setCenter:CGPointMake(contentPoint.x, contentPoint.y+changeInt)];
            [pictureTitleView setCenter:CGPointMake(pictureTitlePoint.x, pictureTitlePoint.y+changeInt)];
            [pictureView setCenter:CGPointMake(picturePoint.x, picturePoint.y+changeInt)];
            [btnSend setCenter:CGPointMake(sendPoint.x, sendPoint.y+changeInt)];
            [btnTelephone setCenter:CGPointMake(telephonePoint.x, telephonePoint.y+changeInt)];
            CGSize size = CGSizeMake(contentScrollView.contentSize.width, contentScrollView.contentSize.height+changeInt);
            [contentScrollView setContentSize:size];
        }completion:^(BOOL finish){
            [btn setSelected:NO];
            [clickBtn setEnabled:YES];
        }];
    }
    else {
        [UIView animateWithDuration:.5 animations:^{
            [contentView setCenter:CGPointMake(contentPoint.x, contentPoint.y-changeInt)];
            [pictureTitleView setCenter:CGPointMake(pictureTitlePoint.x, pictureTitlePoint.y-changeInt)];
            [pictureView setCenter:CGPointMake(picturePoint.x, picturePoint.y-changeInt)];
            [btnSend setCenter:CGPointMake(sendPoint.x, sendPoint.y-changeInt)];
            [btnTelephone setCenter:CGPointMake(telephonePoint.x, telephonePoint.y-changeInt)];
            CGSize size = CGSizeMake(contentScrollView.contentSize.width, contentScrollView.contentSize.height-changeInt);
            [contentScrollView setContentSize:size];
        }completion:^(BOOL finish){
            [btn setSelected:YES];
            [clickBtn setEnabled:YES];
        }];
    }
}

- (IBAction)clickHidePictureView:(id)sender {
    UIButton *clickBtn = (UIButton *)sender;
    NSInteger changeInt = 190;
    UIButton *btn = btnHidePicture;
    [clickBtn setEnabled:NO];
    CGPoint picturePoint, sendPoint,telephonePoint;
    picturePoint = [pictureView center];
    sendPoint = [btnSend center];
    telephonePoint = [btnTelephone center];
    if ([btn isSelected]) {
        [UIView animateWithDuration:.5 animations:^{
            [pictureView setCenter:CGPointMake(picturePoint.x, picturePoint.y+changeInt)];
            [btnSend setCenter:CGPointMake(sendPoint.x, sendPoint.y+changeInt)];
            [btnTelephone setCenter:CGPointMake(telephonePoint.x, telephonePoint.y+changeInt)];
            CGSize size = CGSizeMake(contentScrollView.contentSize.width, contentScrollView.contentSize.height+changeInt);
            [contentScrollView setContentSize:size];
        }completion:^(BOOL finish){
            [btn setSelected:NO];
            [clickBtn setEnabled:YES];
        }];
    }
    else {
        [UIView animateWithDuration:.5 animations:^{
            [pictureView setCenter:CGPointMake(picturePoint.x, picturePoint.y-changeInt)];
            [btnSend setCenter:CGPointMake(sendPoint.x, sendPoint.y-changeInt)];
            [btnTelephone setCenter:CGPointMake(telephonePoint.x, telephonePoint.y-changeInt)];
            CGSize size = CGSizeMake(contentScrollView.contentSize.width, contentScrollView.contentSize.height-changeInt);
            [contentScrollView setContentSize:size];
        }completion:^(BOOL finish){
            [btn setSelected:YES];
            [clickBtn setEnabled:YES];
        }];
    }    
}
- (IBAction)clickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
   
}


#pragma mark - ImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    if (_pickerImage) {
        [_pickerImage release];
    }
    _pickerImage = [image retain];
    [photoImageView setImage:_pickerImage];
    [photoImageView setFrame:CGRectMake(9, 11, 301, 178)];
    if (delegate && [delegate respondsToSelector:@selector(PersonNewsHideTarBar:)]) {
        [delegate PersonNewsHideTarBar:NO];
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if (delegate && [delegate respondsToSelector:@selector(PersonNewsHideTarBar:)]) {
        [delegate PersonNewsHideTarBar:NO];
    }
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint point = [scrollView contentOffset];
    if (point.y > 200) {
        [self hideKeyBoard];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex && _pickerImage) {
        if (_pickerImage) {
            [_pickerImage release];
            _pickerImage = nil;
        }
        UIImage *image = [UIImage imageByName:@"TarBar_BaoLiao_add_local_photo" withExtend:@"png"];
        [photoImageView setImage:image];
    }
}

#pragma mark - Notification
- (void)notificationBaoLiaoSuccess {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"报料成功" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    [txtTelephone setText:@""];
    [txtHappenTime setText:@""];
    [txtHappenAddress setText:@""];
    [txtBaoliaoPeople setText:@""];
    [contentTextView setText:@""];
    if (_pickerImage) {
        [_pickerImage release];
        _pickerImage = nil;
    }
}

- (void)notificationBaoLiaoFail {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"报料失败" message:nil delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

#pragma mark - textDelegate
-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField isEqual:txtBaoliaoPeople]) {
        NSMutableString *text = [[txtBaoliaoPeople.text mutableCopy] autorelease];
        [text replaceCharactersInRange:range withString:string];
        return [text length] <= 6;
    }
    else if ([textField isEqual:txtHappenAddress]) {
        NSMutableString *text = [[txtHappenAddress.text mutableCopy] autorelease];
        [text replaceCharactersInRange:range withString:string];
        return [text length] <= 50;
    }
    return YES;
} 

@end
