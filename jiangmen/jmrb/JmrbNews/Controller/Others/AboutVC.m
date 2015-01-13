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

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:@"关于"];
}

// 设置界面
- (void)initialization
{
    NSString *aboutStr = @"《江门日报》是中共广东省江门市委机关报。前身为《江门报》，1985年12月1日试刊，1986年8月5日正式创刊，四开四版，周报。1990年12月1日改为日报。1993年1月1日正式出版对开四版日报。1997年9月1日起扩为对开八版日报。从2002年10月18日起，扩版为周一至周五每天对开十二版，周六、周日对开四版。2003年9月1日起，扩版为周一至周五每天对开十六版，周六、周日对开八版。2008年3月起，扩版为周一、六16版，周二、四28版，周三、五20版，周日8版，还有台山、开平、鹤山、恩平地方版，是中国第一侨乡江门五邑地区最具权威性和影响力的报纸。";
    
    // webView
    UIWebView *webView = InsertWebView(self.view, self.view.bounds, nil, 1000);
    [webView loadHTMLString:aboutStr baseURL:nil];
    
    [self.view addSubview:webView];
}

@end
