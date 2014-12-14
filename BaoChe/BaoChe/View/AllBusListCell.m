//
//  AllBusListCell.m
//  BaoChe
//
//  Created by swift on 14/12/14.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import "AllBusListCell.h"

@interface AllBusListCell ()

@property (weak, nonatomic) IBOutlet UILabel *busNameLabel;             // 班车名
@property (weak, nonatomic) IBOutlet UILabel *departureTimeLabel;       // 出发时间
@property (weak, nonatomic) IBOutlet UILabel *departureStationLabel;    // 出发站名
@property (weak, nonatomic) IBOutlet UILabel *requiredTimeLabel;        // 所需时间
@property (weak, nonatomic) IBOutlet UILabel *terminalTimeLabel;        // 到达时间
@property (weak, nonatomic) IBOutlet UILabel *terminalStationLabel;     // 终点站名
@property (weak, nonatomic) IBOutlet UILabel *ThroughStationsLabel;     // 途径站点
@property (weak, nonatomic) IBOutlet UILabel *ticketPriceLabel;         // 票价

@end

@implementation AllBusListCell

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
    _busNameLabel.font = SP11Font;
    _busNameLabel.textColor = Common_GrayColor;
    
    _departureTimeLabel.font = SP18Font;
    _departureTimeLabel.textColor = Common_BlackColor;
    
    _departureStationLabel.font = SP13Font;
    _departureStationLabel.textColor = Common_BlackColor;
    
    _requiredTimeLabel.font = SP12Font;
    _requiredTimeLabel.textColor = Common_GrayColor;
    
    _terminalTimeLabel.font = SP11Font;
    _terminalTimeLabel.textColor = Common_GrayColor;
    
    _terminalStationLabel.font = SP13Font;
    _terminalStationLabel.textColor = Common_GrayColor;
    
    _ThroughStationsLabel.font = SP12Font;
    _ThroughStationsLabel.textColor = Common_GrayColor;
    
    _ticketPriceLabel.font = SP15Font;
    _ticketPriceLabel.textColor = Common_RedColor;
    
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
        AllBusListCell *cell = [self loadFromNib];
        defaultCellHeight = cell.boundsHeight;
    }
    return defaultCellHeight;
}

@end
