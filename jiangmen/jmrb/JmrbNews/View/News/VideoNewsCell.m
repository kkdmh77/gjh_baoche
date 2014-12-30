//
//  VideoNewsCell.m
//  JmrbNews
//
//  Created by swift on 14/12/5.
//
//

#import "VideoNewsCell.h"
#import "NIAttributedLabel.h"

@interface VideoNewsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *videoNewsImageView;
@property (weak, nonatomic) IBOutlet UIButton *videoLongTimeBtn;
@property (weak, nonatomic) IBOutlet UILabel *videoNewsNameLabel;
@property (weak, nonatomic) IBOutlet NIAttributedLabel *videoNewsPlayCountLabel;

@end

@implementation VideoNewsCell

CGFloat defaultVideoNewsCellHeight = 0;

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
    _videoNewsNameLabel.font = SP15Font;
    _videoNewsNameLabel.textColor = Common_BlackColor;
    
    _videoNewsPlayCountLabel.font = SP12Font;
    _videoNewsPlayCountLabel.textColor = Common_LiteGrayColor;
    _videoNewsPlayCountLabel.textAlignment = NSTextAlignmentRight;
    
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
    if (0 == defaultVideoNewsCellHeight)
    {
        VideoNewsCell *cell = [VideoNewsCell loadFromNib];
        defaultVideoNewsCellHeight = cell.boundsHeight;
    }
    return defaultVideoNewsCellHeight;
}

- (void)loadCellShowDataWithItemEntity:(VideoNewsEntity *)entity
{
     [_videoNewsImageView gjh_setImageWithURL:[NSURL URLWithString:entity.videoImageUrlStr] placeholderImage:nil imageShowStyle:ImageShowStyle_None success:nil failure:nil];
    [_videoLongTimeBtn setTitle:entity.videoLongTimeStr forState:UIControlStateNormal];
    _videoNewsNameLabel.text = entity.videoNameStr;
    
    _videoNewsPlayCountLabel.text = [NSString stringWithFormat:@"  %d",entity.videoPalyCount];
    [_videoNewsPlayCountLabel insertImage:[UIImage imageNamed:@"videoPlayCount"] atIndex:1 margins:UIEdgeInsetsZero verticalTextAlignment:NIVerticalTextAlignmentMiddle];
}

@end
