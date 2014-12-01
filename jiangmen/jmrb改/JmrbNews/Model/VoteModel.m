//
//  VoteModel.m
//  JmrbNews
//
//  Created by dean on 12-12-5.
//
//

#import "VoteModel.h"
#import "ZSSourceModel.h"
#import "AppDelegate.h"

@interface VoteModel (){
    
    NSMutableArray *arrays;
    ASIHTTPRequest *httpRequest;
    ASIFormDataRequest *httpFormRequest;
    //MBProgressHUD *hud;
}
@end

@implementation VoteModel

-(void)sendTaoPiao{
    
    NSString *strurl=[NSString stringWithFormat:@"%@sJson-addVoters.action",Web_URL];
    httpFormRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strurl]];
    httpFormRequest.delegate = self;
    
    [httpFormRequest setPostValue:_votersName forKey:@"votersName"];
    [httpFormRequest setPostValue:_votersIsim forKey:@"votersIsim"];
    [httpFormRequest setPostValue:_votersPhone forKey:@"votersPhone"];
    [httpFormRequest setPostValue:_voteId forKey:@"voteId"];
    [httpFormRequest setPostValue:_voteType forKey:@"voteType"];
    [httpFormRequest setPostValue:_voteoptionId forKey:@"voteoptionId"];
    [httpFormRequest setPostValue:_votersUserId forKey:@"votersUserId"];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate startLoading];
    httpFormRequest.didFinishSelector = @selector(didFinshRequestsendTaoPiao:);
    httpFormRequest.didFailSelector = @selector(didFailReqeustsendTaoPiao:);
    
    [httpFormRequest startAsynchronous];
    //[_queue addOperation:httpRequest];
    
}


-(void)didFinshRequestsendTaoPiao:(ASIFormDataRequest *)request{
    
    NSString *httpstring = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSLog(@"httpstring------%@", httpstring);
    
    NSDictionary *rootDic = [[CJSONDeserializer deserializer] deserialize:[httpstring dataUsingEncoding:NSUTF8StringEncoding]  error: nil];
    
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate stopLoading];
    
    if([[rootDic objectForKey:@"errorcode"] isEqualToString:@"00"]){
          [appDelegate alertTishiSucc:@"" detail:[rootDic objectForKey:@"msg"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_SendTouPiaoSuccess object:nil];
    }else{
        [appDelegate alertTishi:@"" detail:[rootDic objectForKey:@"msg"]];
    }
    
    
}


-(void)didFailReqeustsendTaoPiao:(ASIFormDataRequest *)request{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate stopLoading];
    
    NSLog(@"citys error %@", [request error]);
}


-(void)getVideoLive{
    
    NSString *strurl=[NSString stringWithFormat:@"%@sJson-getVideourl.action",Web_URL];
    httpFormRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strurl]];
    httpFormRequest.delegate = self;
    
        
    //AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //[appDelegate startLoading];
    httpFormRequest.didFinishSelector = @selector(didFinshRequestgetVideoLive:);
    httpFormRequest.didFailSelector = @selector(didFailReqeustgetVideoLive:);
    
    [httpFormRequest startAsynchronous];
    //[_queue addOperation:httpRequest];
    
}


-(void)didFinshRequestgetVideoLive:(ASIFormDataRequest *)request{
    
    NSString *httpstring = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSLog(@"httpstring------%@", httpstring);
    
    NSDictionary *rootDic = [[CJSONDeserializer deserializer] deserialize:[httpstring dataUsingEncoding:NSUTF8StringEncoding]  error: nil];
    
    //AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //[appDelegate stopLoading];
    if([[rootDic objectForKey:@"errorcode"] isEqualToString:@"00"]){
         [[ZSSourceModel defaultSource ] setHotVideoLiveDic:[rootDic objectForKey:@"response"]];
        //[appDelegate alertTishiSucc:@"" detail:[rootDic objectForKey:@"msg"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_getVideoLive object:nil];
    }else{
        //[appDelegate alertTishi:@"" detail:[rootDic objectForKey:@"msg"]];
    }
    
    
}


-(void)didFailReqeustgetVideoLive:(ASIFormDataRequest *)request{
    //AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //[appDelegate stopLoading];
    
    NSLog(@"citys error %@", [request error]);
}

@end
