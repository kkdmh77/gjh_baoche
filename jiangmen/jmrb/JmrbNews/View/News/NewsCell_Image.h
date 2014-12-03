//
//  NewsCell_Image.h
//  JmrbNews
//
//  Created by swift on 14/12/3.
//
//

#import <UIKit/UIKit.h>
#import "CommonEntity.h"

@interface NewsCell_Image : UITableViewCell

+ (CGFloat)getCellHeight;
- (void)loadCellShowDataWithItemEntity:(News_ImageEntity *)entity;

@end
