//
//  AboutVC.m
//  JmrbNews
//
//  Created by 龚 俊慧 on 15/1/10.
//
//

#import "AboutVC.h"

@interface AboutVC ()

@end

@implementation AboutVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (NSString *)aboutStr
{
    NSString *filePath = GetApplicationPathFileName(@"About", @"txt");
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return str;
}

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:@"关于我们"];
}

// 设置界面
- (void)initialization
{
    NSString *aboutStr = [self aboutStr];
    
    // webView
    UIWebView *webView = InsertWebView(self.view, self.view.bounds, nil, 1000);
    [webView loadHTMLString:aboutStr baseURL:nil];
    
    [self.view addSubview:webView];
}

@end
