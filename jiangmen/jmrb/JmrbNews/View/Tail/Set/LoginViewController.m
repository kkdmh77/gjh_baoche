//
//  LoginViewController.m
//  JmrbNews
//
//  Created by dean on 12-11-23.
//
//

#import "LoginViewController.h"
#import "LoginModel.h"
#import "AppDelegate.h"
#import "ZSSourceModel.h"
#import <QuartzCore/QuartzCore.h>

@interface LoginViewController (){
     LoginModel *loginmodel;
    
   
}
 -(void)loginSuccess;

@end

@implementation LoginViewController
@synthesize usertext,pwdtext,loginbut,registerbut,userimage;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)dealloc{
    
    //[loginmodel release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    pwdtext.secureTextEntry=true;
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"mainbeijing.png"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:Notification_loginSucces object:nil];
//    
//    UIView *loginveiw=[[UIView alloc] initWithFrame:CGRectMake(20, 150, 280, 100)];
//    loginveiw.layer.borderColor=[UIColor grayColor].CGColor;
//    loginveiw.layer.borderWidth=1;
//    loginveiw.layer.cornerRadius=15;
//    
//    [self.view addSubview:loginveiw];
   
    // Do any additional setup after loading the view from its nib.
}



- (IBAction)clickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (IBAction)clickCamera:(id)sender{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //picker.sourceType = UIImagePickerControllerSourceTypeCamera;//相机
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//图片库
    picker.allowsEditing = NO;
    picker.delegate = self;
    
    
    
    [self presentModalViewController: picker animated: YES];

    
//    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        NSArray *temp_MediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
//        picker.mediaTypes = temp_MediaTypes;
//        picker.delegate = self;
//        picker.allowsImageEditing = YES; 
//    }
}


- (IBAction)doEditFieldDone:(id)sender{
    [sender resignFirstResponder];
}


- (IBAction)clickLogin:(id)sender{
    [usertext resignFirstResponder];
    [pwdtext resignFirstResponder];
    
    loginmodel = [[LoginModel alloc] init];
    if([usertext.text isEqual:@""]){
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate alertTishi:@"用户名不能为空！" detail:@""];
        return;
        
    }else if([pwdtext.text isEqual:@""]){
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate alertTishi:@"密码不能为空！" detail:@""];
        return;
        
    }else{
        [loginmodel setLoginuser:usertext.text];
        [loginmodel setLoginpassword:pwdtext.text];
        [loginmodel getLogin];
    }
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
    
    [picker dismissModalViewControllerAnimated:YES];
    [picker release];
    
}


- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


- (void)loginSuccess{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate alertTishiSucc:@"登陆成功" detail:@""];
   // NSDictionary *objectDic= [[ZSSourceModel defaultSource] succLoginDic];
   // NSLog(@"%@",[objectDic objectForKey:@"userPhone"]);
    if(delegate && [delegate respondsToSelector:@selector(LoginSuccesGoTo)]){
        [delegate LoginSuccesGoTo];
    }
    [self.navigationController popViewControllerAnimated:YES];
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
