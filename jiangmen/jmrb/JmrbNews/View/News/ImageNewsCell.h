//
//  ImageNewsCell.h
//  JmrbNews
//
//  Created by 龚 俊慧 on 14/12/5.
//
//

#import <UIKit/UIKit.h>
#import "CommonEntity.h"

@interface ImageNewsCell : UITableViewCell

+ (CGFloat)getCellHeight;
- (void)loadCellShowDataWithItemEntity:(ImageNewsEntity *)entity;

@end
