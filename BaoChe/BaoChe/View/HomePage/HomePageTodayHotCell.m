//
//  HomePageTodayHotCell.m
//  BaoChe
//
//  Created by 龚 俊慧 on 14/12/15.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import "HomePageTodayHotCell.h"
#import "NIAttributedLabel.h"
#import "NSMutableAttributedString+NimbusAttributedLabel.h"

@interface HomePageTodayHotCell ()

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemOriginalPriceLabel;

@end

@implementation HomePageTodayHotCell

static CGFloat defautlCellHeight = 0;

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
    _itemNameLabel.font = SP14Font;
    _itemNameLabel.textColor = HEXCOLOR(0X0A3959);
    
    _itemPriceLabel.font = SP12Font;
    _itemPriceLabel.textColor = HEXCOLOR(0X999999);
    
    _itemOriginalPriceLabel.font = SP12Font;
    _itemOriginalPriceLabel.textColor = HEXCOLOR(0X999999);
    
    // 分割线
    [self.contentView addLineWithPosition:ViewDrawLinePostionType_Bottom
                                lineColor:CellSeparatorColor
                                lineWidth:LineWidth];
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
    
    [self loadCellShowDataWithItemEntity];
}

////////////////////////////////////////////////////////////////////////////////

+ (CGFloat)getCellHeight
{
    if (0 == defautlCellHeight)
    {
        HomePageTodayHotCell *cell = [self loadFromNib];
        defautlCellHeight = cell.boundsHeight;
    }
    
    return defautlCellHeight;
}

- (void)loadCellShowDataWithItemEntity
{
    [_itemImageView gjh_setImageWithURL:[NSURL URLWithString:@"http://image16-c.poco.cn/mypoco/myphoto/20141208/14/525813772014120814022804_640.jpg?596x396_120"]
                       placeholderImage:nil
                         imageShowStyle:ImageShowStyle_None
                                success:nil
                                failure:nil];
    
    // 现价
    NSString *price = @"299";
    NSString *priceStr = [NSString stringWithFormat:@"%@元",price];
    
    NSMutableAttributedString *priceAttributedStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [priceAttributedStr setFont:SP18Font range:[priceStr rangeOfString:price]];
    [priceAttributedStr setTextColor:HEXCOLOR(0XFF565B) range:[priceStr rangeOfString:price]];
    
    _itemPriceLabel.attributedText = priceAttributedStr;
    
    // 原价
    NSString *originalPriceStr = [NSString stringWithFormat:@"%.2lf元",888.00];
    NSMutableAttributedString *originalPriceAttributedStr = [[NSMutableAttributedString alloc] initWithString:originalPriceStr];
    [originalPriceAttributedStr setStrikethroughStyle:kCTUnderlineStyleSingle];
    
    _itemOriginalPriceLabel.attributedText = originalPriceAttributedStr;
}

@end
