//
//  RTBaseComponent.h
//  Pods
//
//  Created by ricky on 16/6/18.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "RTTableComponent.h"
#import "GlobalConfig.h"
#import "EmptyDataCell.h"

@interface RTBaseComponent : NSObject <RTTableComponent>

@property (nonatomic, weak, readonly) UITableView *tableView;

@property (nonatomic, weak) id<RTTableComponentDelegate> delegate;
@property (nonatomic, assign) NSInteger sectionOfTableView; ///< 这个component在table的section位置

@property (nonatomic, strong) NSString *cellIdentifier;
@property (nonatomic, strong) NSString *headerIdentifier;

+ (instancetype)componentWithTableView:(UITableView *)tableView;
+ (instancetype)componentWithTableView:(UITableView *)tableView delegate:(id<RTTableComponentDelegate>)delegate;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithTableView:(UITableView *)tableView;
- (instancetype)initWithTableView:(UITableView *)tableView delegate:(id<RTTableComponentDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (void)registerWithTableView:(UITableView *)tableView NS_REQUIRES_SUPER;
- (void)setNeedUpdateHeightForSection:(NSInteger)section;

/**************************** 网络数据加载状态相关 ********************************/

@property (nonatomic, assign) ViewLoadType loadType; // 数据加载类型 defuatl is ViewLoadTypeLoading
@property (nonatomic, strong, readonly) EmptyDataCell *emptyDataCell;

@end
