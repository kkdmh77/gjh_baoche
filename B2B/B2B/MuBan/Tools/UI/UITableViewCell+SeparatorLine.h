//
//  UITableViewCell+SeparatorLine.h
//  kkyuwen100
//
//  Created by 龚 俊慧 on 2016/12/30.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (SeparatorLine)

- (void)addLineWithLineOffsetIfNeed:(CGFloat)lineOffset
                          indexPath:(NSIndexPath *)indexPath
               totalRowNumInSection:(NSInteger)totalRowNumInSection;

@end
