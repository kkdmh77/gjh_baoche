//
//  NewsCell_ Normal.m
//  JmrbNews
//
//  Created by 龚 俊慧 on 14/12/2.
//
//

#import "CollectionCell.h"

@interface CollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UILabel *newsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectionTimeLabel;

@end

@implementation CollectionCell

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
    _newsTitleLabel.font = SP15Font;
    _newsTitleLabel.textColor = Common_BlackColor;
    
    _collectionTimeLabel.font = SP12Font;
    _collectionTimeLabel.textColor = Common_LiteGrayColor;
    _collectionTimeLabel.backgroundColor = HEXCOLOR(0XFFFFFF);
    
    [self addLineWithPosition:ViewDrawLinePostionType_Bottom
             startPointOffset:10
               endPointOffset:10
                    lineColor:CellSeparatorColor
                    lineWidth:LineWidth];
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

+ (CGFloat)getCellHeight
{
    if (0 == defaultCellHeight)
    {
        CollectionCell *cell = [CollectionCell loadFromNib];
        defaultCellHeight = cell.boundsHeight;
    }
    return defaultCellHeight;
}

- (void)loadCellShowDataWithItemEntity:(NewsCollectionEntity *)entity
{
    if ([entity.newsImageUrlStr isAbsoluteValid])
    {
        [_newsImageView gjh_setImageWithURL:[NSURL URLWithString:entity.newsImageUrlStr]
                           placeholderImage:[UIImage imageNamed:@"placeholder_small"]
                             imageShowStyle:ImageShowStyle_None
                                    success:nil
                                    failure:nil];
        [_newsImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(75));
            make.right.equalTo(_newsTitleLabel.mas_left).offset(@(-6));
        }];
    }
    else
    {
        _newsImageView.image = nil;
        
        [_newsImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(0));
            make.right.equalTo(_newsTitleLabel.mas_left).offset(@(0));
        }];
    }
    
    _newsTitleLabel.text = entity.newsTitleStr;
    _collectionTimeLabel.text = [NSDate stringFromTimeIntervalSeconds:entity.collectTime.doubleValue withFormatter:DataFormatter_DateAndTime];
}

@end
