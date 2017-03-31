//
//  ProductViewController.m
//  MuBan
//
//  Created by 龚 俊慧 on 2017/3/31.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import "ProductViewController.h"

@interface ProductViewController ()

@end

@implementation ProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setup {
    [self configureBarbuttonItemsByPosition:BarbuttonItemPosition_Left
                                 normalImgs:@[@"nav_scan_white", @"nav_scan_white"]
                            highlightedImgs:@[@"nav_scan_white", @"nav_scan_white"]
                                    actions:@[^(id sender){
        DLog(@"aaa");
    }, ^(id sedner) {
        DLog(@"bbb");
    }]];
    
    [self configureBarbuttonItemsByPosition:BarbuttonItemPosition_Right
                                 normalImgs:@[@"nav_scan_white", @"nav_scan_white", @"nav_scan_white"]
                            highlightedImgs:@[@"nav_scan_white", @"nav_scan_white", @"nav_scan_white"]
                                    actions:@[^(id sender){
        DLog(@"ccc");
    }, ^(id sedner) {
        DLog(@"ddd");
    }, ^(id sender) {
        DLog(@"eee")
    }]];
    
    [self setupNavSearchBarWithActionHandle:^(id sender) {
        
    }];
}

@end
