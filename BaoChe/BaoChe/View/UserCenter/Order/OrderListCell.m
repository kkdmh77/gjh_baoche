//
//  OrderListCell.m
//  BaoChe
//
//  Created by 龚 俊慧 on 15/1/1.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "OrderListCell.h"
#import "NSMutableAttributedString+NimbusAttributedLabel.h"
#import "QRCodeGenerator.h"
#import "ClickImage.h"

@interface OrderListCell ()

@property (weak, nonatomic) IBOutlet UIView *topBGView;
@property (weak, nonatomic) IBOutlet UILabel *busNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *busInfoStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *busPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *startAndEndTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *startStationLabel;
@property (weak, nonatomic) IBOutlet UILabel *endStationLabel;
@property (weak, nonatomic) IBOutlet UILabel *passengersLabel;      // 乘客

@property (weak, nonatomic) IBOutlet ClickImage *QRCodeImageView;   // 检票二维码
@property (weak, nonatomic) IBOutlet UILabel *QRCodeDescLabel;

@end

@implementation OrderListCell

static CGFloat defaultCellHeight = 0;

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
    _topBGView.backgroundColor = [UIColor whiteColor];
    [_topBGView addLineWithPosition:ViewDrawLinePostionType_Bottom
                          lineColor:CellSeparatorColor
                          lineWidth:LineWidth];
    
    UIColor *blackColor = Common_BlackColor;
    UIColor *grayColor = Common_GrayColor;
    
    _busNameLabel.textColor = blackColor;
    _busInfoStatusLabel.textColor = Common_ThemeColor;
    _busPriceLabel.textColor = blackColor;
    _startStationLabel.textColor = blackColor;
    _startAndEndTimeLabel.textColor = grayColor;
    _endStationLabel.textColor = blackColor;
    _passengersLabel.textColor = grayColor;
    
    _QRCodeImageView.canClick = YES;
    
    // 分割线
    [self.contentView addLineWithPosition:ViewDrawLinePostionType_Bottom
                                lineColor:CellSeparatorColor
                                lineWidth:LineWidth];
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

////////////////////////////////////////////////////////////////////////////////

+ (CGFloat)getCellHeight
{
    if (0 == defaultCellHeight)
    {
        OrderListCell *cell = [self loadFromNib];
        defaultCellHeight = cell.boundsHeight;
    }
    return defaultCellHeight;
}

- (void)loadCellShowDataWithItemEntity:(OrderListEntity *)entity
{
    // 价钱
    NSString *priceStr = [NSString stringWithFormat:@"￥%.2f",entity.orderTotalFee];
    NSString *priceDescStr = @"总价: ";
    NSString *resultPriceStr = [NSString stringWithFormat:@"%@%@", priceDescStr, priceStr];
    NSMutableAttributedString *attributedPriceStr = [[NSMutableAttributedString alloc] initWithString:resultPriceStr];
    [attributedPriceStr setFont:SP15Font range:[resultPriceStr rangeOfString:priceStr]];
    [attributedPriceStr setTextColor:Common_RedColor range:[resultPriceStr rangeOfString:priceStr]];
    _busPriceLabel.attributedText = attributedPriceStr;
    
    _busNameLabel.text = [NSString stringWithFormat:@"%@(单程)", entity.busInfoEntity.busNameStr];
    _busInfoStatusLabel.text = entity.busInfoEntity.cartInfoStatusDesc;
    NSString *startAndEndTimeStr = [NSString stringWithFormat:@"%@ %@开 - %@ %@到",entity.busInfoEntity.startTime_DateStr, entity.busInfoEntity.startTimeStr,entity.busInfoEntity.endTime_DateStr, entity.busInfoEntity.endTimeStr];
    _startAndEndTimeLabel.text = startAndEndTimeStr;
    _startStationLabel.text = entity.busInfoEntity.startStation;
    _endStationLabel.text = entity.busInfoEntity.endStation;
    
    // 乘车人
    NSMutableArray *passengersNameArray = [NSMutableArray array];
    for (PassengersEntity *passengerEntity in entity.passengersArray)
    {
        [passengersNameArray addObject:passengerEntity.nameStr];
    }
    NSString *passengersStr = [passengersNameArray componentsJoinedByString:@","];
    _passengersLabel.text = [NSString stringWithFormat:@"%@(%ld人)",passengersStr, (long)entity.passengersArray.count];
    
    // 二维码
    if ([entity.orderStatus isEqualToString:@"OS_VERIFIED"])
    {
        _QRCodeDescLabel.hidden = NO;
        _QRCodeImageView.hidden = NO;
        
        _QRCodeImageView.image = [QRCodeGenerator qrImageForString:entity.orderNo imageSize:300];
        _QRCodeImageView.backgroundColor = [UIColor redColor];
    }
    else
    {
        _QRCodeDescLabel.hidden = YES;
        _QRCodeImageView.hidden = YES;
    }
}

@end
