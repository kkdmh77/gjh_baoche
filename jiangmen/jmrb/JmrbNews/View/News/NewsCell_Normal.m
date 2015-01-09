//
//  NewsCell_ Normal.m
//  JmrbNews
//
//  Created by 龚 俊慧 on 14/12/2.
//
//

#import "NewsCell_Normal.h"

@interface NewsCell_Normal ()

@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UILabel *newsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsCommentCountLabel;

@end

@implementation NewsCell_Normal

CGFloat defaultNormalNewsCellHeight = 0;

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
    
    _newsDescLabel.font = SP12Font;
    _newsDescLabel.textColor = Common_LiteGrayColor;
    
    _newsCommentCountLabel.font = SP12Font;
    _newsCommentCountLabel.textColor = Common_LiteGrayColor;
    _newsCommentCountLabel.backgroundColor = HEXCOLOR(0XFFFFFF);
    
    [self addLineWithPosition:ViewDrawLinePostionType_Bottom startPointOffset:10 endPointOffset:10 lineColor:CellSeparatorColor lineWidth:LineWidth];
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

+ (CGFloat)getCellHeight
{
    if (0 == defaultNormalNewsCellHeight)
    {
        NewsCell_Normal *cell = [NewsCell_Normal loadFromNib];
        defaultNormalNewsCellHeight = cell.boundsHeight;
    }
    return defaultNormalNewsCellHeight;
}

- (void)loadCellShowDataWithItemEntity:(News_NormalEntity *)entity
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
    _newsCommentCountLabel.text = [NSString stringWithFormat:@" %d评",entity.newsCommentCount];
    
    if ([entity.newsDescStr isAbsoluteValid])
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 4.0;
        
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:entity.newsDescStr];
        [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedStr.length)];
        _newsDescLabel.attributedText = attributedStr;
    }
}

@end
