//
//  AwardViewController.m
//  JmrbNews
//
//  Created by dean on 13-6-2.
//
//

#import "AwardViewController.h"

@interface AwardViewController ()

@end

@implementation AwardViewController
@synthesize newsWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *objectDic =  [standardUserDefault objectForKey:Key_UserName];
    [newsWebView setBackgroundColor:[UIColor clearColor]];
    [newsWebView setOpaque:NO];
    //newsWebView.delegate =self;
    
    NSURL *url ;
    if (objectDic!=nil) {
        url =[NSURL URLWithString:[NSString stringWithFormat:@"http://jmrb.5g88.com:4180/lottery-checkLotteryLogin.action?userName=%@&userPassword=%@",[objectDic objectForKey:@"userName"],[objectDic objectForKey:@"userPassword"]]];
        NSURLRequest *request =[NSURLRequest requestWithURL:url];
        [newsWebView loadRequest:request];

    }else{
         url =[NSURL URLWithString:[NSString stringWithFormat:@"http://jmrb.5g88.com:4180/lottery-checkLotteryLogin.action?userName=&userPassword="]];
         [self.navigationController popViewControllerAnimated:YES];
        
    }
   
   
    
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)clickBack:(id)sender{

    [self.navigationController popViewControllerAnimated:YES];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //修改服务器页面的meta的值
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", webView.frame.size.width];
    [webView stringByEvaluatingJavaScriptFromString:meta];
}


- (void)viewDidUnload
{
    [self setNewsWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [newsWebView release];
    [super dealloc];
}
@end
