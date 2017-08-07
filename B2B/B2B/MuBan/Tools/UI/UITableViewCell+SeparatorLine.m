//
//  UITableViewCell+SeparatorLine.m
//  kkyuwen100
//
//  Created by 龚 俊慧 on 2016/12/30.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import "UITableViewCell+SeparatorLine.h"

@implementation UITableViewCell (SeparatorLine)

- (void)addLineWithLineOffsetIfNeed:(CGFloat)lineOffset indexPath:(NSIndexPath *)indexPath totalRowNumInSection:(NSInteger)totalRowNumInSection {
    
    if (0 == indexPath.row && totalRowNumInSection - 1 != indexPath.row) {
        
        [self addLineWithStartPointOffset:0
                           endPointOffset:0
                                 position:ViewDrawLinePostionType_Top];
        [self addLineWithStartPointOffset:lineOffset
                           endPointOffset:0
                                 position:ViewDrawLinePostionType_Bottom];
    } else if (0 == indexPath.row && totalRowNumInSection - 1 == indexPath.row) {
        
        [self addLineWithStartPointOffset:0
                           endPointOffset:0
                                 position:ViewDrawLinePostionType_Top];
        [self addLineWithStartPointOffset:0
                           endPointOffset:0
                                 position:ViewDrawLinePostionType_Bottom];
    } else if (totalRowNumInSection - 1 == indexPath.row) {
        
        [self addLineWithStartPointOffset:0
                           endPointOffset:0
                                 position:ViewDrawLinePostionType_Bottom];
    } else {
        
        [self addLineWithStartPointOffset:lineOffset
                           endPointOffset:0
                                 position:ViewDrawLinePostionType_Bottom];
    }
}

- (void)addLineWithStartPointOffset:(CGFloat)startOffset endPointOffset:(CGFloat)endPointOffset position:(ViewDrawLinePostionType)position
{
    UIView *lineView = [self addLineWithPosition:position
                                startPointOffset:startOffset
                                  endPointOffset:endPointOffset
                                       lineColor:nil
                                       lineWidth:ThinLineWidth];
    lineView.dk_backgroundColorPicker = DKColorWithColors(CellSeparatorColor, CellSeparatorColor_Night);
}

@end
