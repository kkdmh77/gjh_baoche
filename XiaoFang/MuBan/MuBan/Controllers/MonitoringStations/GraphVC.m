//
//  GraphVC.m
//  MuBan
//
//  Created by 龚 俊慧 on 15/7/24.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "GraphVC.h"
#import "NIAttributedLabel.h"

@interface GraphVC ()

@property (weak, nonatomic) IBOutlet NIAttributedLabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *graphImageView;

@end

@implementation GraphVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:@"水压变化曲线图"];
}

- (void)configureViewsProperties
{
   [_graphImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.width.equalTo(IPHONE_WIDTH * 1.0625);
   }];
    
    if (_entity)
    {
        NSString *numberStr = [NSString stringWithFormat:@"0%ld", _entity.number];
        
        _titleLabel.text = [NSString stringWithFormat:@"监测点%@水压曲线图", numberStr];
        [_titleLabel setTextColor:Common_LiteBlueColor range:[_titleLabel.text rangeOfString:numberStr]];
        [_titleLabel setVerticalTextAlignment:NIVerticalTextAlignmentMiddle];
        
        _graphImageView.image = [UIImage imageNamed:@"quxian"];
    }
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

@end
