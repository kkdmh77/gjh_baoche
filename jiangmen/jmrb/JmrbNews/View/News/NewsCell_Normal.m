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
    
    [self addLineWithPosition:ViewDrawLinePostionType_Bottom startPointOffset:10 endPointOffset:10 lineColor:CellSeparatorColor lineWidth:LineWidth];
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
    
    _newsImageView.backgroundColor = [UIColor blueColor];
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
    [_newsImageView gjh_setImageWithURL:[NSURL URLWithString:entity.newsImageUrlStr] placeholderImage:nil imageShowStyle:ImageShowStyle_None success:nil failure:nil];
    _newsTitleLabel.text = entity.newsTitleStr;
    _newsCommentCountLabel.text = [NSString stringWithFormat:@"%d评",entity.newsCommentCount];
    
    if ([entity.newsDescStr isAbsoluteValid])
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 6.0;
        
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:entity.newsDescStr];
        [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedStr.length)];
        _newsDescLabel.attributedText = attributedStr;
    }
}

@end
