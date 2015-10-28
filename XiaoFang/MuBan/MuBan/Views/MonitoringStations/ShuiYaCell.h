//
//  ShuiYaCell.h
//  MuBan
//
//  Created by 龚 俊慧 on 15/7/23.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonEntity.h"

@class ShuiYaCell;

typedef void (^ShuiYaCellOperationHandle) (ShuiYaCell *cell, id sender);

@interface ShuiYaCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *numberBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UIButton *valueBtn;

@property (nonatomic, copy) ShuiYaCellOperationHandle handle;

+ (CGFloat)getCellHeight;
- (void)loadDataWithShowEntity:(MonitoringDataListEntity *)entity;

@end
