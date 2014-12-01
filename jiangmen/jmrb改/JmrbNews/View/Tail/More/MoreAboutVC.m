//
//  MoreAboutVC.m
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MoreAboutVC.h"

@interface MoreAboutVC ()

@end

@implementation MoreAboutVC
@synthesize bgWebView;
@synthesize delegate;

- (void)dealloc {
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSInteger fontSize = 17;
    NSString *webViewText = [NSString stringWithFormat:@"<style> body {text-align:justify; font:%ipx Custom-Font-Name; line-height:%ipx}</style>",fontSize,fontSize+10];
    NSString *htmlString = [webViewText stringByAppendingFormat:@"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;《江门日报》是中共广东省江门市委机关报。前身为《江门报》，1985年12月1日试刊，1986年8月5日正式创刊，四开四版，周报。1990年12月1日改为日报。1993年1月1日正式出版对开四版日报。1997年9月1日起扩为对开八版日报。从2002年10月18日起，扩版为周一至周五每天对开十二版，周六、周日对开四版。2003年9月1日起，扩版为周一至周五每天对开十六版，周六、周日对开八版。2008年3月起，扩版为周一、六16版，周二、四28版，周三、五20版，周日8版，还有台山、开平、鹤山、恩平地方版，是中国第一侨乡江门五邑地区最具权威性和影响力的报纸。"];
    NSString *newHtmlString = [htmlString stringByReplacingOccurrencesOfString:@"\n\n" withString:@"<br />"];
    htmlString = [newHtmlString stringByReplacingOccurrencesOfString:@"\n" withString:@"<br />"];
    [bgWebView loadHTMLString:htmlString baseURL:nil];
}

#pragma mark - Xib function
- (IBAction)clickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    if (delegate && [delegate respondsToSelector:@selector(MoreDetailGoBack)]) {
        [delegate MoreDetailGoBack];
    }
}

@end
