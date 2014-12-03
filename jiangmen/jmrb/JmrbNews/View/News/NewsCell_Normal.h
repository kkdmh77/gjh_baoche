//
//  NewsCell_ Normal.h
//  JmrbNews
//
//  Created by 龚 俊慧 on 14/12/2.
//
//

#import <UIKit/UIKit.h>
#import "CommonEntity.h"

@interface NewsCell_Normal : UITableViewCell

+ (CGFloat)getCellHeight;
- (void)loadCellShowDataWithItemEntity:(News_NormalEntity *)entity;

@end
