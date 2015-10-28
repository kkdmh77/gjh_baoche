//
//  DetailInfoListCell.h
//  MuBan
//
//  Created by 龚 俊慧 on 15/7/24.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonEntity.h"

@interface DetailInfoListCell : UITableViewCell

+ (CGFloat)getCellHeight;
- (void)loadDataWithShowEntity:(WaterPressureDetail_CollectListEntity *)entity;

@end
