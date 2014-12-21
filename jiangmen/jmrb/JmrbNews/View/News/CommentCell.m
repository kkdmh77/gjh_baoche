//
//  CommentCell.m
//  JmrbNews
//
//  Created by swift on 14/12/21.
//
//

#import "CommentCell.h"

@implementation CommentCell

- (void)awakeFromNib
{
    [self setup];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - custom methods

- (void)configureViewsProperties
{

}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

////////////////////////////////////////////////////////////////////////////////

+ (CGFloat)getCellHeihgtWithItemEntity:(CommentEntity *)entity
{
    return 0;
}

- (void)loadCellShowDataWithItemEntity:(CommentEntity *)entity
{
    
}

@end
