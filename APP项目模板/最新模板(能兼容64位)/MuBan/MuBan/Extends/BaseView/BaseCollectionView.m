//
//  BaseCollectionView.m
//  Biuu
//
//  Created by 龚 俊慧 on 2017/8/10.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import "BaseCollectionView.h"
#import <UIScrollView+EmptyDataSet.h>

@interface BaseCollectionView ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation BaseCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - custom methods

- (void)commonInit {
    self.emptyDataSetSource = self;
    self.emptyDataSetDelegate = self;
    self.loadType = ViewLoadTypeSuccess;
}

#pragma mark - getter & setter methods

- (void)setLoadType:(ViewLoadType)loadType {
    _loadType = loadType;
    
    [self reloadEmptyDataSet];
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
            desc = @"呦，快抢沙发啊~";
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

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    if ((ViewLoadTypeNoNet == _loadType || ViewLoadTypeFailed == _loadType) && _tapActionHandle) {
        _tapActionHandle(self);
    }
}

@end
