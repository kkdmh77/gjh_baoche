//
//  ShuiYaCell.h
//  MuBan
//
//  Created by 龚 俊慧 on 15/7/23.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonEntity.h"

@class WarningDataListCell;

typedef void (^WarningDataListCellOperationHandle) (WarningDataListCell *cell, id sender);

@interface WarningDataListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *numberBtn;
@property (weak, nonatomic) IBOutlet UILabel *warningTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *warningDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *warningTimeBtn;

// @property (nonatomic, copy) WarningDataListCellOperationHandle handle;

+ (CGFloat)getCellHeight;
- (void)loadDataWithShowEntity:(WarningDataListEntity *)entity;

@end
