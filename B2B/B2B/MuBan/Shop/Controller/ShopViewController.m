//
//  ShopViewController.m
//  MuBan
//
//  Created by 龚 俊慧 on 2017/3/31.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import "ShopViewController.h"
#import <JZNavigationExtension/JZNavigationExtension.h>

@interface ShopViewController ()

@end

@implementation ShopViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.loadUrlStr = @"http://120.76.188.84:8085/plugin/testAppUI.html";
    }
    return self;
}

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
