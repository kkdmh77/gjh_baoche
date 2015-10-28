//
//  AboutVC.m
//  JmrbNews
//
//  Created by 龚 俊慧 on 15/1/10.
//
//

#import "RegisterVC.h"

@interface RegisterVC ()

@end

@implementation RegisterVC

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
    
    str = @"欢迎来到中国消防智能监测消防，如需注册请与我们联系，电话：13957887266，赵永军";
    
    return str;
}

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:@"程序注册"];
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
