//
//  LoginModel.m
//  JmrbNews
//
//  Created by dean on 12-11-23.
//
//

#import "LoginModel.h"
#import "ZSSourceModel.h"
#import "AppDelegate.h"


static LoginModel *_default;


@interface LoginModel (){
    
    NSMutableArray *arrays;
    ASIHTTPRequest *httpRequest;
    ASIFormDataRequest *httpFormRequest;
    //MBProgressHUD *hud;
}

@end

@implementation LoginModel


+ (id)defaultSource {
    if (!_default) {
        _default = [[LoginModel alloc] init];
    }
    return _default;
}

- (void) dealloc
{
	[arrays release];
    [httpRequest release];
    [httpFormRequest release];
	[super dealloc];
}


-(void)getLogin{
    NSString *strurl=[NSString stringWithFormat:@"%@sJson-logon.action?userName=%@&userPassword=%@",Web_URL,_loginuser,_loginpassword];
    httpRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:strurl]];
    httpRequest.delegate = self;
    [httpRequest setRequestMethod:@"POST"];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate startLoading];
    
    //[httpRequest addRequestHeader:@"Content-Type" value:@"application/json"];
    
   
    httpRequest.didFinishSelector = @selector(didFinshRequestLogin:);
    httpRequest.didFailSelector = @selector(didFailReqeustLogin:);
    [httpRequest startAsynchronous];
    //[_queue addOperation:httpRequest];
    
}


-(void)didFinshRequestLogin:(ASIHTTPRequest *)request{
    
    //NSError *error;
    //NSStringEncoding  enc=CFStringConvertNSStringEncodingToEncoding(kCFStringEncodingGB_18030_2000);
    NSString *httpstring = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSLog(@"httpstring------%@", httpstring);
    
    NSDictionary *rootDic = [[CJSONDeserializer deserializer] deserialize:[httpstring dataUsingEncoding:NSUTF8StringEncoding]  error: nil];
    
    [httpstring release];
   
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate stopLoading];
   
    if([[rootDic objectForKey:@"errorcode"] isEqualToString:@"00"]){
        [[ZSSourceModel defaultSource] setSuccLoginDic:[rootDic objectForKey:@"response"]];
         NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
        [standardUserDefault setValue:[rootDic objectForKey:@"response"]  forKey:Key_UserName];
        
        [standardUserDefault synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_loginSucces object:nil];
    }else{
        [appDelegate alertTishi:@"登陆失败" detail:[rootDic objectForKey:@"msg"]];
    }
    
}


-(void)didFailReqeustLogin:(ASIHTTPRequest *)request{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate stopLoading];
    //[hud removeFromSuperview];
    NSLog(@"citys error %@", [request error]);
}


-(void)getRegister{
    
    NSString *strurl=[NSString stringWithFormat:@"%@sJson-addUser.action",Web_URL];
    httpFormRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strurl]];
    httpFormRequest.delegate = self;
   
    [httpFormRequest setPostValue:_loginuser forKey:@"userName"];
    [httpFormRequest setPostValue:_loginpassword forKey:@"userPassword"];
    [httpFormRequest setPostValue:_loginphone forKey:@"userPhone"];
    [httpFormRequest setPostValue:_loginsex forKey:@"userSex"];
    
    
    //[httpFormRequest setFile:@"1.png" forKey:@"userPhoto"];
    
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate startLoading];
    httpFormRequest.didFinishSelector = @selector(didFinshRequestRegister:);
    httpFormRequest.didFailSelector = @selector(didFailReqeustRegister:);
    
    [httpFormRequest startAsynchronous];
    //[_queue addOperation:httpRequest];
    
}



-(void)didFinshRequestRegister:(ASIFormDataRequest *)request{
    
    NSString *httpstring = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSLog(@"httpstring------%@", httpstring);
    
    NSDictionary *rootDic = [[CJSONDeserializer deserializer] deserialize:[httpstring dataUsingEncoding:NSUTF8StringEncoding]  error: nil];
    
    [httpstring release];
    
   
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate stopLoading];
    
    if([[rootDic objectForKey:@"errorcode"] isEqualToString:@"00"]){
        [[ZSSourceModel defaultSource] setSuccLoginDic:[rootDic objectForKey:@"response"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_loginSucces object:nil];
    }else{
        [appDelegate alertTishi:@"注册失败" detail:[rootDic objectForKey:@"msg"]];
    }
    
}


-(void)didFailReqeustRegister:(ASIFormDataRequest *)request{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate stopLoading];
   
    NSLog(@"citys error %@", [request error]);
}


-(void)uploadImage{
    
    NSString *strurl=[NSString stringWithFormat:@"%@sJson-getUserphoto.action",Web_URL];
    httpFormRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strurl]];
    httpFormRequest.delegate = self;
    
    [httpFormRequest setPostValue:_loginuser forKey:@"userName"];
    [httpFormRequest setPostValue:_loginpassword forKey:@"userPassword"];
    [httpFormRequest setFile:_userimageurl forKey:@"file"];
    
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate startLoading];
    httpFormRequest.didFinishSelector = @selector(didFinshRequestuploadImage:);
    httpFormRequest.didFailSelector = @selector(didFailReqeustuploadImage:);
    
    [httpFormRequest startAsynchronous];
    //[_queue addOperation:httpRequest];
    
}


-(void)didFinshRequestuploadImage:(ASIFormDataRequest *)request{
    
    NSString *httpstring = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSLog(@"httpstring------%@", httpstring);
    
    NSDictionary *rootDic = [[CJSONDeserializer deserializer] deserialize:[httpstring dataUsingEncoding:NSUTF8StringEncoding]  error: nil];
    
     [httpstring release];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate stopLoading];
    
    if([[rootDic objectForKey:@"errorcode"] isEqualToString:@"00"]){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_uploadUserImage object:nil];
    }else{
        [appDelegate alertTishi:@"失败" detail:[rootDic objectForKey:@"msg"]];
    }
    
}


-(void)didFailReqeustuploadImage:(ASIFormDataRequest *)request{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate stopLoading];
    
    NSLog(@"citys error %@", [request error]);
}


-(void)sendsms:(NSString *) phone vcode:(NSString *) vicode{
    
    NSString *strurl=[NSString stringWithFormat:@"%@sJson-sendsms.action",Web_URL];
    httpFormRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strurl]];
    httpFormRequest.delegate = self;
    
    [httpFormRequest setPostValue:phone forKey:@"phone"];
    [httpFormRequest setPostValue:vicode forKey:@"vicode"];
    
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate startLoading];
    httpFormRequest.didFinishSelector = @selector(didFinshRequestsendsms:);
    httpFormRequest.didFailSelector = @selector(didFailReqeustsendsms:);
    
    [httpFormRequest startAsynchronous];
    //[_queue addOperation:httpRequest];
    
}


-(void)didFinshRequestsendsms:(ASIFormDataRequest *)request{
    NSString *httpstring = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSLog(@"httpstring------%@", httpstring);
    
    NSDictionary *rootDic = [[CJSONDeserializer deserializer] deserialize:[httpstring dataUsingEncoding:NSUTF8StringEncoding]  error: nil];
    
     [httpstring release];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate stopLoading];
    
    if([[rootDic objectForKey:@"errorcode"] isEqualToString:@"00"]){
        [appDelegate alertTishiSucc:@"发送成功，请留意短信！" detail:@""];
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_usersendsms object:nil];
    }else{
        [appDelegate alertTishi:@"失败" detail:[rootDic objectForKey:@"msg"]];
    }
    
}


-(void)didFailReqeustsendsms:(ASIFormDataRequest *)request{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate stopLoading];
    
    NSLog(@"sms  error %@", [request error]);
}



-(void)updateUser:(NSString *) userId userName:(NSString *) userName userPassword:(NSString *) userPassword userPhone:(NSString *) userPhone userSex:(NSString *) userSex userVerification:(NSString *) userVerification{
    
    NSString *strurl=[NSString stringWithFormat:@"%@sJson-updateUser.action",Web_URL];
    httpFormRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strurl]];
    httpFormRequest.delegate = self;
    
    [httpFormRequest setPostValue:userId forKey:@"userId"];
    [httpFormRequest setPostValue:userName forKey:@"userName"];
    [httpFormRequest setPostValue:userPassword forKey:@"userPassword"];
    [httpFormRequest setPostValue:userPhone forKey:@"userPhone"];
    [httpFormRequest setPostValue:userSex forKey:@"userSex"];
    [httpFormRequest setPostValue:userVerification forKey:@"userVerification"];
    
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate startLoading];
    httpFormRequest.didFinishSelector = @selector(didFinshRequestupdateUser:);
    httpFormRequest.didFailSelector = @selector(didFailReqeustupdateUser:);
    
    [httpFormRequest startAsynchronous];
    //[_queue addOperation:httpRequest];
    
}


-(void)didFinshRequestupdateUser:(ASIFormDataRequest *)request{
    NSString *httpstring = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSLog(@"httpstring------%@", httpstring);
    
    NSDictionary *rootDic = [[CJSONDeserializer deserializer] deserialize:[httpstring dataUsingEncoding:NSUTF8StringEncoding]  error: nil];
    
    [httpstring release];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate stopLoading];
    
    if([[rootDic objectForKey:@"errorcode"] isEqualToString:@"00"]){
        NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
        [standardUserDefault setValue:[rootDic objectForKey:@"response"]  forKey:Key_UserName];
        
        
        //[[ZSSourceModel defaultSource] setSuccLoginDic:[rootDic objectForKey:@"response"]];
        [appDelegate alertTishiSucc:@"手机号码验证成功！" detail:@""];
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_userscheck object:nil];
    }else{
        [appDelegate alertTishi:@"失败" detail:[rootDic objectForKey:@"msg"]];
    }
    
}


-(void)didFailReqeustupdateUser:(ASIFormDataRequest *)request{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate stopLoading];
    
    NSLog(@"sms  error %@", [request error]);
}





@end
