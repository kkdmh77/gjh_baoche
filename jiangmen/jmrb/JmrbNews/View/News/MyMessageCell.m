//
//  MyMessageCell.m
//  JmrbNews
//
//  Created by 龚 俊慧 on 14/12/24.
//
//

#import "MyMessageCell.h"

@interface MyMessageCell ()

@property (weak, nonatomic) IBOutlet UILabel *messageTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation MyMessageCell

static MyMessageCell *defaultCell = nil;

- (void)awakeFromNib
{
    [self setup];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureViewsProperties
{
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = nil;
    
    _messageTitleLabel.textColor = Common_BlackColor;
    _messageContentLabel.textColor = Common_LiteGrayColor;
    _timeLabel.textColor = Common_LiteGrayColor;
    
    [self.contentView addLineWithPosition:ViewDrawLinePostionType_Bottom
                         startPointOffset:20
                           endPointOffset:0
                                lineColor:CellSeparatorColor
                                lineWidth:LineWidth];
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

////////////////////////////////////////////////////////////////////////////////

+ (CGFloat)getCellHeightWithItemEntity:(MyMessageEntity *)entity
{
    if (!defaultCell)
    {
        defaultCell = [self loadFromNib];
    }
    
    return defaultCell.boundsHeight + ([entity.messageContentStr sizeWithFont:defaultCell.messageContentLabel.font constrainedToWidth:IPHONE_WIDTH - 30].height - defaultCell.messageContentLabel.boundsHeight);
}

- (void)loadCellShowDataWithItemEntity:(MyMessageEntity *)entity
{
    _messageTitleLabel.text = entity.messageTitleStr;
    _messageContentLabel.text = entity.messageContentStr;
    _timeLabel.text = [NSDate stringFromTimeIntervalSeconds:entity.messageTime
                                              withFormatter:DataFormatter_DateAndTime];
    
}

@end
