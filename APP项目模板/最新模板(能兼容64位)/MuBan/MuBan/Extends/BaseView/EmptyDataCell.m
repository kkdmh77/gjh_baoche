//
//  EmptyDataCell.m
//  Biuu
//
//  Created by 龚 俊慧 on 2017/7/20.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import "EmptyDataCell.h"
#import <UIScrollView+EmptyDataSet.h>
#import <NerdyUI.h>

@interface EmptyDataCell ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UIScrollView *emptyScrollView;

@end

@implementation EmptyDataCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - custom methods

- (void)initialization {
    @weakify(self)
    _emptyScrollView = (UIScrollView *)[UIScrollView new].addTo(self.contentView).makeCons(^{
        make.edge.equal.view(weak_self.contentView);
    });
    
    _emptyScrollView.emptyDataSetSource = self;
    _emptyScrollView.emptyDataSetDelegate = self;
}

#pragma mark - getter & setter methods

- (void)setLoadType:(ViewLoadType)loadType {
    _loadType = loadType;
    
    [_emptyScrollView reloadEmptyDataSet];
}

#pragma mark - DZNEmptyDataSetSource & DZNEmptyDataSetDelegate methods

- (BOOL)emptyDataSetShouldBeForcedToDisplay:(UIScrollView *)scrollView {
    return _loadType != ViewLoadTypeSuccess;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return _loadType != ViewLoadTypeSuccess;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *desc = @"";
    switch (_loadType) {
        case ViewLoadTypeLoading:
            desc = @"正在加载中...";
            break;
        case ViewLoadTypeFailed:
            desc = @"数据加载失败";
            break;
        case ViewLoadTypeNoNet:
            desc = @"网络加载失败";
            break;
        case ViewLoadTypeNoneData:
            desc = @"没有数据";
            break;
        default:
            break;
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:desc];
    str.color = TextPlaceholderColor;
    str.font = kCustomFont_Size(14);
    
    return str;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *imageName = @"";
    switch (_loadType) {
        case ViewLoadTypeLoading:
            imageName = @"dataLoadingMid";
            break;
        case ViewLoadTypeFailed:
        case ViewLoadTypeNoNet:
            imageName = @"dataLoadFailedMid";
            break;
        case ViewLoadTypeNoneData:
            imageName = @"";
            break;
        default:
            break;
    }
    
    return [UIImage imageNamed:imageName];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIColor whiteColor];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return 0;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return 11;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    if (ViewLoadTypeLoading != _loadType && ViewLoadTypeSuccess != _loadType && _tapActionHandle) {
        _tapActionHandle(self);
    }
}

@end
