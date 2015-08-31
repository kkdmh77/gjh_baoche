//
//  WaterPressureCell.m
//  MuBan
//
//  Created by 龚 俊慧 on 15/7/24.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "WaterPressureCell.h"

@implementation WaterPressureCell

- (void)awakeFromNib {
    // Initialization code
    
    [self setup];
}

#pragma mark - custom methods

- (void)configureViewsProperties
{
    [_numberBtn setTitleColor:Common_LiteBlueColor forState:UIControlStateNormal];
    [_valueBtn setTitleColor:Common_LiteBlueColor forState:UIControlStateNormal];
    
    CGFloat width = (IPHONE_WIDTH - 45 - 50 - 80) / 2;
    
    [_nameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(width);
    }];
    [_positionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(width);
    }];
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

+ (CGFloat)getCellHeight
{
    return 30;
}

- (void)loadDataWithShowEntity:(WaterPressureEntity *)entity
{
    [_numberBtn setTitle:entity.number forState:UIControlStateNormal];
    [_nameBtn setTitle:[NSString stringWithFormat:@"  %@", entity.name] forState:UIControlStateNormal];
    [_valueBtn setTitle:[NSString stringWithFormat:@"%.2f", entity.value.floatValue] forState:UIControlStateNormal];
    [_phoneBtn setTitle:[NSString stringWithFormat:@"  %@", entity.phone]forState:UIControlStateNormal];
    [_positionBtn setTitle:[NSString stringWithFormat:@"  %@", entity.position] forState:UIControlStateNormal];
}

@end
