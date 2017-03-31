//
//  BaseScrollComponentItemCell.h
//  kkyingyu100
//
//  Created by 龚 俊慧 on 16/3/16.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseScrollComponentItemCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/// 点击tab的row
@property (nonatomic, copy) void (^didSelectRowInTab) (NSIndexPath *tabIndexPath);

- (void)reloadData;

@end
