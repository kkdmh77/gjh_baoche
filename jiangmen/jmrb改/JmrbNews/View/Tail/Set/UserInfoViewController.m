//
//  UserInfoViewController.m
//  JmrbNews
//
//  Created by dean on 12-11-28.
//
//

#import "UserInfoViewController.h"
#import "ZSSourceModel.h"
#import "LoginModel.h"
#import "AppDelegate.h"

@interface UserInfoViewController (){
    NSDictionary *objectDic;
     LoginModel *loginmodel;
     bool isrefresh;
}

- (void)uploadSuccess;

@end

@implementation UserInfoViewController
@synthesize usertext,phonetext,sextext,uploadbut,userimage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [objectDic release];
    [imageQueue prepareRelease];
    [imageQueue setTarget:nil];
    [imageQueue release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isrefresh = false;
    imageQueue = [[ImageLoaderQueue alloc] initWithTarget:self];
    NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
    //objectDic = [standardUserDefault objectForKey:Key_UserName];
    objectDic=  [[NSDictionary alloc] initWithDictionary:[standardUserDefault objectForKey:Key_UserName]];
   //objectDic= [[ZSSourceModel defaultSource] succLoginDic];
    [usertext setText:[objectDic objectForKey:@"userName"]];
    [phonetext setText:[NSString stringWithFormat:@"%@(%@)",[objectDic objectForKey:@"userPhone"],[objectDic objectForKey:@"userVerificationString"]]];
    [sextext setText:[objectDic objectForKey:@"userSexString"]];
    
    UIImage *image = nil;
    NSString *urlString =[NSString stringWithFormat:@"%@%@",Web_URL ,[objectDic objectForKey:@"userPhoto"]];
    if (urlString && [urlString isKindOfClass:[NSString class]] && [urlString length] > 0) {
        image = [imageQueue getImageForURL:urlString];
        if (!image) {
            image = [UIImage imageNamed:@"nouserpic.png"];
            [imageQueue addOperationToQueueWithURL:urlString atIndex:94494];
        }
    }
    else {
        image = [UIImage imageNamed:@"nouserpic.png"];
    }

    [userimage setImage:image];
//    [image release];
//    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadSuccess) name:Notification_uploadUserImage object:nil];
    // Do any additional setup after loading the view from its nib.
}


-(void)viewWillAppear:(BOOL)animated{
    if(isrefresh){
        NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
        objectDic =  [[NSDictionary alloc] initWithDictionary:[standardUserDefault objectForKey:Key_UserName]];
        [usertext setText:[objectDic objectForKey:@"userName"]];
        [phonetext setText:[NSString stringWithFormat:@"%@(%@)",[objectDic objectForKey:@"userPhone"],[objectDic objectForKey:@"userVerificationString"]]];
        [sextext setText:[objectDic objectForKey:@"userSexString"]];
    }
    
}



- (IBAction)clickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)clickUpload:(id)sender{
    
    loginmodel = [[LoginModel alloc] init];
    [loginmodel setLoginuser:[objectDic objectForKey:@"userName"]];
    [loginmodel setLoginpassword:[objectDic objectForKey:@"userPassword"]];
    [loginmodel setUserimageurl:[NSString stringWithFormat:@"%@/%@rbtempuser.png",[self documentFolderPath],[objectDic objectForKey:@"userId"]]];
    [loginmodel uploadImage];
}

- (IBAction)clickCheckphone:(id)sender{
    
    if([[objectDic objectForKey:@"userVerification"] intValue]==0){
        isrefresh  = true;
        CheckPhoneViewController *checkPhoneViewController=[[CheckPhoneViewController alloc] init];
        
        [self.navigationController pushViewController:checkPhoneViewController animated:YES];
        [checkPhoneViewController release];
    }
}


- (IBAction)clickCamera:(id)sender{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //picker.sourceType = UIImagePickerControllerSourceTypeCamera;//相机
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//图片库
    picker.allowsEditing = NO;
    picker.delegate = self;
    
    [self presentModalViewController: picker animated: YES];
    
  
}


- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    //[[picker parentViewController] dismissModalViewControllerAnimated: YES];
    
    NSLog(@"您取消了选择图片");
    
    [picker dismissModalViewControllerAnimated:YES];
    [picker release];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
   self.userimage.image=[self scaleFromImage:[info objectForKey:UIImagePickerControllerOriginalImage] toSize:CGSizeMake(75, 75)];
    //self.userimage.image = [info objectForKey:UIImagePickerControllerOriginalImage];    //imageview是自己定义的一个image view 控件,用来显示选中的图片
    [self saveImage:userimage.image WithName:[NSString stringWithFormat:@"%@rbtempuser.png",[objectDic objectForKey:@"userId"]]];
    [picker dismissModalViewControllerAnimated:YES];
    [picker release];
    
    [uploadbut setHidden:NO];
    
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

#pragma mark - ImageQueueDelegate
- (void)imageOperationCompleted:(UIImage *)_image atIndex:(NSInteger)_index {
    [userimage setImage:_image];
}


- (void)uploadSuccess{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate alertTishiSucc:@"上传成功" detail:@""];
    [uploadbut setHidden:YES];
    
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
