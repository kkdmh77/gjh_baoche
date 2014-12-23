//
//  CommentCell.h
//  JmrbNews
//
//  Created by swift on 14/12/21.
//
//

#import <UIKit/UIKit.h>
#import "CommonEntity.h"

@interface CommentCell : UITableViewCell

- (CGFloat)getCellHeihgtWithItemEntity:(CommentEntity *)entity;
- (void)loadCellShowDataWithItemEntity:(CommentEntity *)entity;

@end
