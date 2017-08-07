//
//  MineViewController.m
//  MuBan
//
//  Created by 龚 俊慧 on 2017/3/31.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import "MineViewController.h"
#import <JZNavigationExtension/JZNavigationExtension.h>

@interface MineViewController ()

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupPDRUI];
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setup {
    self.navigationItem.leftBarButtonItems = nil;
    
    self.jz_navigationBarBackgroundAlpha = 0.5;
}

@end
