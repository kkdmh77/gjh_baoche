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
    
    str = @"宁波滕头物联网科技有限公司是一家以智慧消防为主要方向的科技类公司，公司主要从事消防栓的水压无限远程监测，老旧消防栓改造成新型智能消防栓，依托物联网大背景，实现消防栓全天候监管，并能把实时水压数据上传，让消防栓内的生命之水永远不会消失，为智慧城市，和谐社会，安居乐业提供技术支持！";
    
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
    
    // scroll
    UIScrollView *scroll = InsertScrollView(self.view, self.view.bounds, 1000, nil);
    UILabel *label = InsertLabel(scroll,
                                 CGRectInset(scroll.bounds, 10, 10),
                                 NSTextAlignmentLeft,
                                 aboutStr,
                                 SP16Font,
                                 [UIColor blackColor],
                                 YES);
    scroll.contentSize = CGSizeMake(scroll.boundsWidth, label.boundsHeight);
    
    [self.view addSubview:scroll];
}

@end
