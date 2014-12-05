//
//  VideoNewsCell.h
//  JmrbNews
//
//  Created by swift on 14/12/5.
//
//

#import <UIKit/UIKit.h>
#import "CommonEntity.h"

@interface VideoNewsCell : UITableViewCell

+ (CGFloat)getCellHeight;
- (void)loadCellShowDataWithItemEntity:(VideoNewsEntity *)entity;

@end
