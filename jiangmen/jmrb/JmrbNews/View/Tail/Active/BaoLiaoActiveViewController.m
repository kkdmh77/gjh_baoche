//
//  BaoLiaoActiveViewController.m
//  JmrbNews
//
//  Created by dean on 12-12-3.
//
//

#import "BaoLiaoActiveViewController.h"
#import "ImageContant.h"
#import "AppDelegate.h"
#import "BaoLiaoActiveModel.h"
#import "MobileCoreServices/UTCoreTypes.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
//#import "CommonUtil.h"




@interface BaoLiaoActiveViewController (){
    BaoLiaoActiveModel  *baoLiaoActiveModel;
    NSData *myfileData;
    NSString *videoPath;
}

- (void)dateChanged:(id)sender;
- (void)hideKeyBoard;
- (void)notificationBaoLiaoSuccess;

@end



@implementation BaoLiaoActiveViewController
@synthesize contentScrollView,userimage,datePicker;
@synthesize txtBaoliaoPeople,txtTitel,txtTelephone,txtHappenTime,txtHappenAddress,contentTextView;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [videoPath release];
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"mainbeijing.png"]];
    [self.contentScrollView setContentSize:CGSizeMake(320, 540)];
    [self.contentScrollView setDelegate:self];
    
    NSString *dateString = getStringFromDate(@"YYYY年MM月dd日 hh:mm a", [NSDate date]);
    [txtHappenTime setPlaceholder:dateString];
    [txtHappenTime setText:dateString];
    
    
    [txtBaoliaoPeople setDelegate:self];
    [txtHappenAddress setDelegate:self];
    
    
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    [datePicker setCenter:CGPointMake(160, 480+datePicker.frame.size.height)];
    [txtHappenTime setInputView:datePicker];
    
    UIImage *image, *image1;
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
    [txtHappenTime setInputAccessoryView:view];
    [txtHappenTime.inputAccessoryView addSubview:btn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationBaoLiaoSuccess) name:Notification_SendBaoLiaoSuccess object:nil];
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Private
- (void)dateChanged:(id)sender {
    NSDate *date = [datePicker date];
    NSString *dateString = getStringFromDate(@"YYYY年MM月dd日 hh:mm a", date);
    [txtHappenTime setText:dateString];
}

- (IBAction)doEditFieldDone:(id)sender{
    [sender resignFirstResponder];
}

- (IBAction)clickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickSend:(id)sender{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (txtBaoliaoPeople.text==nil || [txtBaoliaoPeople.text length] == 0 ) {
        [appDelegate alertTishi:@"请填写报料人姓名" detail:@""];
        return;
    }
    if (txtTelephone.text==nil || [txtTelephone.text length] == 0 ) {
        [appDelegate alertTishi:@"请填写联系电话" detail:@""];
        return;
    }
    if (txtTitel.text==nil || [txtTitel.text length] == 0 ) {
        [appDelegate alertTishi:@"请填写标题" detail:@""];
        return;
    }
    if (txtHappenTime.text==nil || [txtHappenTime.text length] == 0 ) {
       [appDelegate alertTishi:@"请填写发生时间" detail:@""];
        return;
    }
    if (txtHappenAddress.text==nil || [txtHappenAddress.text length] == 0 ) {
        [appDelegate alertTishi:@"请填写发生地点" detail:@""];
        return;
    }
    if (contentTextView.text==nil || [contentTextView.text length] == 0 ) {
        [appDelegate alertTishi:@"请填写事件内容" detail:@""];
        return;
    }
    
    baoLiaoActiveModel =[[BaoLiaoActiveModel alloc] init];
    [baoLiaoActiveModel setTxtBaoliaoPeople:txtBaoliaoPeople.text];
    [baoLiaoActiveModel setTxtTelephone:txtTelephone.text];
    [baoLiaoActiveModel setTxtTitel:@""];
    [baoLiaoActiveModel setTxtHappenTime:txtHappenTime.text];
    [baoLiaoActiveModel setTxtHappenAddress:txtHappenAddress.text];
    [baoLiaoActiveModel setContentTextView:contentTextView.text];
    if (userimage.tag==101) {
        [baoLiaoActiveModel setUserimageurl:[NSString stringWithFormat:@"%@/rbbaoliaotempuser.png",[self documentFolderPath]]];
        //[baoLiaoActiveModel setFiledata:myfileData];
    }else if(userimage.tag==102){
        [baoLiaoActiveModel setUserimageurl:videoPath];
        //[baoLiaoActiveModel setFiledata:myfileData];
        
    }else{
        [baoLiaoActiveModel setUserimageurl:@""];
    }
    [baoLiaoActiveModel sendBaoliao];
    
}


- (IBAction)clickCamera:(id)sender{
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    //picker.sourceType = UIImagePickerControllerSourceTypeCamera;//相机
//    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//图片库
//    //picker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
//    //picker.mediaTypes = [[[NSArray alloc] initWithObjects:(NSString*)kUTTypeMovie, nil] autorelease];
//    picker.allowsEditing = NO;
//    picker.delegate = self;
//    
//    
//    
//    [self presentModalViewController: picker animated: YES];
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"请选择文件来源"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"本地相簿",@"本地视频",nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
    
    
}


#pragma UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex = [%d]",buttonIndex);
    switch (buttonIndex) {
//        case 0://照相机
//        {
//            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//            imagePicker.delegate = self;
//            //imagePicker.allowsEditing = YES;
//            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//            imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *)kUTTypeImage, nil];
//            [self presentModalViewController:imagePicker animated:YES];
//            //[imagePicker release];
//        }
//            break;
//        case 1://摄像机
//        {
//            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//            imagePicker.delegate = self;
//            //imagePicker.allowsEditing = YES;
//            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//            imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
//            imagePicker.videoQuality = UIImagePickerControllerQualityTypeLow;
//            [self presentModalViewController:imagePicker animated:YES];
//            //[imagePicker release];
//        }
//            break;
        case 0://本地相簿
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            //imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
            [self presentModalViewController:imagePicker animated:YES];
            if (delegate && [delegate respondsToSelector:@selector(BaoLiaoActiveViewHideTarBar:)]) {
                [delegate BaoLiaoActiveViewHideTarBar:true];
            }
            
            //[imagePicker release];
        }
            break;
        case 1://本地视频
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            //imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
            [self presentModalViewController:imagePicker animated:YES];
            if (delegate && [delegate respondsToSelector:@selector(BaoLiaoActiveViewHideTarBar:)]) {
                [delegate BaoLiaoActiveViewHideTarBar:true];
            }
            //[imagePicker release];
        }
            break;
        default:
            break;
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
    [txtTitel resignFirstResponder];
}


- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    //[[picker parentViewController] dismissModalViewControllerAnimated: YES];
    
    NSLog(@"您取消了选择图片");
    if (delegate && [delegate respondsToSelector:@selector(BaoLiaoActiveViewHideTarBar:)]) {
        [delegate BaoLiaoActiveViewHideTarBar:false];
    }
    [picker dismissModalViewControllerAnimated:YES];
    [picker release];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage]) {//图片
        self.userimage.image=[self scaleFromImage:[info objectForKey:UIImagePickerControllerOriginalImage] toSize:CGSizeMake(300, 300)];
        //self.userimage.image = [info objectForKey:UIImagePickerControllerOriginalImage];    //imageview是自己定义的一个image view 控件,用来显示选中的图片
//        UIImage  *img = [info objectForKey:UIImagePickerControllerOriginalImage];
//        if (UIImagePNGRepresentation(img) == nil) {
//            myfileData = UIImageJPEGRepresentation(img, 1.0);
//
//        } else {
//            myfileData = UIImagePNGRepresentation(img);
//        }
      
        
        [self saveImage:userimage.image WithName:[NSString stringWithFormat:@"rbbaoliaotempuser.png"]];
        [userimage setTag:101];

        
    } else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeMovie]) {
        videoPath =[[NSString alloc] initWithString:[[info objectForKey:UIImagePickerControllerMediaURL] path]];
        self.userimage.image=[self getImage:videoPath];
        [userimage setTag:102];
        //myfileData = [NSData dataWithContentsOfFile:videoPath];

    }
    if (delegate && [delegate respondsToSelector:@selector(BaoLiaoActiveViewHideTarBar:)]) {
        [delegate BaoLiaoActiveViewHideTarBar:false];
    }
    [picker dismissModalViewControllerAnimated:YES];
    [picker release];
    
    
    
}


- (NSString *)documentFolderPath
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    return  documentsDirectory;
    
    //return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


-(UIImage *)getImage:(NSString *)videoURL
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    
    NSURL *url = [[[NSURL alloc] initFileURLWithPath:videoURL] autorelease];
    
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake(600, 450);
    
    NSError *error = nil;
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(10, 10) actualTime:NULL error:&error];
    UIImage *image = [UIImage imageWithCGImage: img];
    
    return image;
}


- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
}


#pragma mark - Notification
- (void)notificationBaoLiaoSuccess {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"报料成功" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    [txtTitel setText:@""];
    [txtTelephone setText:@""];
    [txtHappenTime setText:@""];
    [txtHappenAddress setText:@""];
    [txtBaoliaoPeople setText:@""];
    [contentTextView setText:@""];
    if([userimage tag]==101){
        [userimage setImage:[UIImage imageNamed:@"baoliaoxianji.png"]];
    }
       
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




- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
