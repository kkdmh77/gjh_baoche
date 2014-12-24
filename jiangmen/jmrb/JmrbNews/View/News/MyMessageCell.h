//
//  MyMessageCell.h
//  JmrbNews
//
//  Created by 龚 俊慧 on 14/12/24.
//
//

#import <UIKit/UIKit.h>
#import "CommonEntity.h"

@interface MyMessageCell : UITableViewCell

+ (CGFloat)getCellHeightWithItemEntity:(MyMessageEntity *)entity;
- (void)loadCellShowDataWithItemEntity:(MyMessageEntity *)entity;

@end
