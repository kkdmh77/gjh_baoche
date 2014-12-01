//
//  MoreReadModelVC.m
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MoreReadModelVC.h"
#import "ImageContant.h"

@interface MoreReadModelVC ()

@end

@implementation MoreReadModelVC
@synthesize halfImageView, fullImageView;
@synthesize lblReadModel;
@synthesize delegate;

- (void)dealloc {
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSNumber *readModel = [[NSUserDefaults standardUserDefaults] objectForKey:More_ReadModel];
    UIImage *imageSelected = [UIImage imageByName:@"TarBar_multi_selected1" withExtend:@"png"];
    UIImage *imageNotSelected = [UIImage imageByName:@"TarBar_multi_unselected1" withExtend:@"png"];
    if ([readModel boolValue]) {
        [self.fullImageView setImage:imageSelected];
        [self.halfImageView setImage:imageNotSelected];
        [lblReadModel setText:@"默认打开全屏阅读模式"];
    }
    else {
        [self.fullImageView setImage:imageNotSelected];
        [self.halfImageView setImage:imageSelected];
        [lblReadModel setText:@"默认打开普通阅读模式"];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Xib function
- (IBAction)clickHalfScreen:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:More_ReadModel];
    UIImage *imageSelected = [UIImage imageByName:@"TarBar_multi_selected1" withExtend:@"png"];
    UIImage *imageNotSelected = [UIImage imageByName:@"TarBar_multi_unselected1" withExtend:@"png"];
    [self.fullImageView setImage:imageNotSelected];
    [self.halfImageView setImage:imageSelected];
    [lblReadModel setText:@"默认打开普通阅读模式"];
}

- (IBAction)clickFullScreen:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:More_ReadModel];
    UIImage *imageSelected = [UIImage imageByName:@"TarBar_multi_selected1" withExtend:@"png"];
    UIImage *imageNotSelected = [UIImage imageByName:@"TarBar_multi_unselected1" withExtend:@"png"];
    [self.fullImageView setImage:imageSelected];
    [self.halfImageView setImage:imageNotSelected];
    [lblReadModel setText:@"默认打开全屏阅读模式"];
}

- (IBAction)clickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    if (delegate && [delegate respondsToSelector:@selector(MoreDetailGoBack)]) {
        [delegate MoreDetailGoBack];
    }
}

@end
