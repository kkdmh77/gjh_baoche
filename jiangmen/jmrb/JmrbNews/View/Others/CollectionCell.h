//
//  NewsCell_ Normal.h
//  JmrbNews
//
//  Created by 龚 俊慧 on 14/12/2.
//
//

#import <UIKit/UIKit.h>
#import "CommonEntity.h"
#import "NewsCollectionEntity.h"

@interface CollectionCell : UITableViewCell

+ (CGFloat)getCellHeight;
- (void)loadCellShowDataWithItemEntity:(NewsCollectionEntity *)entity;

@end
