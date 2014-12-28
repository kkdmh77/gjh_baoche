//
//  ChannelEditCollectionCell.m
//  JmrbNews
//
//  Created by swift on 14/12/26.
//
//

#import "ChannelEditCollectionCell.h"

@implementation ChannelEditCollectionCell

- (void)awakeFromNib
{
    [self setup];
}

#pragma mark - custom methods

- (void)configureViewsProperties
{
    [_titleLabel addBorderToViewWitBorderColor:HEXCOLOR(0XE4E4E4)
                                   borderWidth:LineWidth];
    _titleLabel.backgroundColor = PageBackgroundColor;
    _titleLabel.textColor = Common_BlackColor;
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}
@end
