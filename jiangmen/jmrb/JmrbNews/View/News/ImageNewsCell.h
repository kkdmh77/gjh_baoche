//
//  ImageNewsCell.h
//  JmrbNews
//
//  Created by 龚 俊慧 on 14/12/5.
//
//

#import <UIKit/UIKit.h>
#import "CommonEntity.h"

@class ImageNewsCell;

typedef NS_ENUM(NSInteger, CellOperationType)
{
    /// 查看评论
    CellOperationType_CheckComment = 0,
    /// 去评论
    CellOperationType_GoComment,
    /// 分享
    CellOperationType_Share,
};

typedef void (^cellOperationHandle) (ImageNewsCell *cell, CellOperationType type, id sender);

@interface ImageNewsCell : UITableViewCell

@property (nonatomic, copy) cellOperationHandle handle;

+ (CGFloat)getCellHeight;
- (void)loadCellShowDataWithItemEntity:(ImageNewsEntity *)entity;

@end
