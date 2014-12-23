//
//  CommentCell.m
//  JmrbNews
//
//  Created by swift on 14/12/21.
//
//

#import "CommentCell.h"

@interface CommentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentContentLabel;

@end

@implementation CommentCell

static CommentCell *defaultCell;

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
    _userNameLabel.textColor = Common_BlueColor;
    _commentTimeLabel.textColor = Common_LiteGrayColor;
    _commentContentLabel.textColor = Common_BlackColor;
    
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

- (CGFloat)getCellHeihgtWithItemEntity:(CommentEntity *)entity
{
//    if (!defaultCell)
//    {
//        defaultCell = [self loadFromNib];
//    }
    
    
    [self loadCellShowDataWithItemEntity:entity];
    
    CGSize cellSize = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return cellSize.height + 1;
     
//    return defaultCell.boundsHeight + ([entity.commentContentStr sizeWithFont:defaultCell.commentContentLabel.font constrainedToWidth:IPHONE_WIDTH  - 60].height - defaultCell.commentContentLabel.boundsHeight);
}

- (void)loadCellShowDataWithItemEntity:(CommentEntity *)entity
{
    [_userHeaderImageView gjh_setImageWithURL:[NSURL URLWithString:entity.criticsHeaderImageUrlStr]
                             placeholderImage:nil
                               imageShowStyle:ImageShowStyle_None
                                      success:nil
                                      failure:nil];
    
    _userNameLabel.text = @"xx";
    _commentTimeLabel.text = @"2小时前";
    _commentContentLabel.text = entity.commentContentStr;
}

@end
