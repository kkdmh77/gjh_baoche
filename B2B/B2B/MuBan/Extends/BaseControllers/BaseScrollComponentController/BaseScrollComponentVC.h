//
//  BaseScrollComponentVC.h
//  kkyingyu100
//
//  Created by 龚 俊慧 on 16/3/16.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import "BaseNetworkViewController.h"
#import "StyleSelectorView.h"

#define kBaseScrollComponentAssociatedKey "BaseScrollComponentVC"

NS_ASSUME_NONNULL_BEGIN

static NSString * const kBaseScrollComponentTabCellIdentifier = @"kBaseScrollComponentTabCellIdentifier";

@interface BaseScrollComponentVC : BaseNetworkViewController

- (instancetype)initWithTableCellRegisterNibName:(NSString *)nibName;
/// 构建界面
- (void)initialization;

@property (nonatomic, assign) NSInteger defaultScrollIndex; // 默认显示的滚动位置 defualt is 0
@property (nonatomic, copy  ) NSString  *cellNibName;
/// 点击tab的row
@property (nonatomic, copy) void (^didSelectRowInTabHandle) (NSInteger scrollIndex, NSIndexPath *tabIndexPath);

// 子类必须实现
- (NSArray<NSString *> *)slideSwitchTitles;
- (NSArray<NSArray *> *)dataArray;

- (NSInteger)numberOfRowsInSection:(NSInteger)section scrollIndex:(NSInteger)scrollIndex tableView:(UITableView *)tableView;
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath scrollIndex:(NSInteger)scrollIndex tableView:(UITableView *)tableView;
- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath scrollIndex:(NSInteger)scrollIndex tableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
