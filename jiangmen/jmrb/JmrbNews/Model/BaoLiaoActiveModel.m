//
//  BaoLiaoActiveModel.m
//  JmrbNews
//
//  Created by dean on 12-12-3.
//
//

#import "BaoLiaoActiveModel.h"
#import "ZSSourceModel.h"
#import "AppDelegate.h"

@interface BaoLiaoActiveModel (){
    
    NSMutableArray *arrays;
    ASIHTTPRequest *httpRequest;
    ASIFormDataRequest *httpFormRequest;
    //MBProgressHUD *hud;
}


@end


@implementation BaoLiaoActiveModel


-(void)sendBaoliao{
    
    NSString *strurl=[NSString stringWithFormat:@"%@sJson-addOtherNews.action",Web_URL];
    httpFormRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strurl]];
    httpFormRequest.delegate = self;
    
    [httpFormRequest setPostValue:_txtBaoliaoPeople forKey:@"provider"];
    [httpFormRequest setPostValue:_txtTelephone forKey:@"providerNum"];
    [httpFormRequest setPostValue:_txtTitel forKey:@"othernewsTitle"];
    
    [httpFormRequest setPostValue:_txtHappenTime forKey:@"time"];

    [httpFormRequest setPostValue:_txtHappenAddress forKey:@"place"];
    [httpFormRequest setPostValue:_contentTextView forKey:@"newsInfo"];
    
    if(![_userimageurl isEqualToString:@""]){
        [httpFormRequest setFile:_userimageurl forKey:@"file"];
        //[httpFormRequest setData:_filedata withFileName:@"baoliao.jpg" andContentType:@"image/jpeg" forKey:@"file"];
    }
    
    //[httpFormRequest setData:_filedata forKey:@"file"];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate startLoading];
    httpFormRequest.didFinishSelector = @selector(didFinshRequestsendBaoliao:);
    httpFormRequest.didFailSelector = @selector(didFailReqeustsendBaoliao:);
    
    [httpFormRequest startAsynchronous];
    //[_queue addOperation:httpRequest];
    
}


-(void)didFinshRequestsendBaoliao:(ASIFormDataRequest *)request{
    
    NSString *httpstring = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSLog(@"httpstring------%@", httpstring);
    
    NSDictionary *rootDic = [[CJSONDeserializer deserializer] deserialize:[httpstring dataUsingEncoding:NSUTF8StringEncoding]  error: nil];
    
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate stopLoading];
    
    if([[rootDic objectForKey:@"errorcode"] isEqualToString:@"00"]){
         [[NSNotificationCenter defaultCenter] postNotificationName:Notification_SendBaoLiaoSuccess object:nil];
    }else{
        [appDelegate alertTishi:@"失败" detail:[rootDic objectForKey:@"msg"]];
    }

    
}


-(void)didFailReqeustsendBaoliao:(ASIFormDataRequest *)request{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate stopLoading];
    
    NSLog(@"citys error %@", [request error]);
}


@end
