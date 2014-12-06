//
//  NewsCell_Image.m
//  JmrbNews
//
//  Created by swift on 14/12/3.
//
//

#import "NewsCell_Image.h"

@interface NewsCell_Image ()

@property (weak, nonatomic) IBOutlet UILabel *imageGroupNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewOne;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewTwo;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewThree;
@property (weak, nonatomic) IBOutlet UILabel *imageCountAndCommentCountLabel;

@end

@implementation NewsCell_Image

CGFloat defaultNormalNews_ImageCellHeight = 0;

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
    _imageGroupNameLabel.font = SP15Font;
    _imageGroupNameLabel.textColor = Common_BlackColor;
    
    _imageCountAndCommentCountLabel.font = SP12Font;
    _imageCountAndCommentCountLabel.textColor = Common_LiteGrayColor;
    
    [self addLineWithPosition:ViewDrawLinePostionType_Bottom startPointOffset:10 endPointOffset:10 lineColor:CellSeparatorColor lineWidth:LineWidth];
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

////////////////////////////////////////////////////////////////////////////////

+ (CGFloat)getCellHeight
{
    if (0 == defaultNormalNews_ImageCellHeight)
    {
        NewsCell_Image *cell = [NewsCell_Image loadFromNib];
        defaultNormalNews_ImageCellHeight = cell.boundsHeight;
    }
    return defaultNormalNews_ImageCellHeight;
}

- (void)loadCellShowDataWithItemEntity:(News_NormalEntity *)entity
{
    
}

@end
