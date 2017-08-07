//
//  RTTableComponent.h
//  Pods
//
//  Created by ricky on 16/6/19.
//
//

#import <Foundation/Foundation.h>


@protocol RTTableComponent;


@protocol RTTableComponentDelegate <NSObject>
@optional
- (void)tableComponent:(id<RTTableComponent>)component didTapItemAtIndex:(NSUInteger)index userInfo:(NSDictionary *)userInfo;

/**************************** 网络数据加载状态相关 ********************************/

- (void)emptyViewTapActionToReloadData:(id<RTTableComponent>)component;
@end


@protocol RTTableComponent <NSObject>
@required

@property (nonatomic, assign) NSInteger sectionOfTableView; ///< 这个component在table的section位置

- (NSString *)cellIdentifier;
- (NSString *)headerIdentifier;

- (NSInteger)numberOfItems;

- (CGFloat)estimatedHeightForComponentHeader;
- (CGFloat)heightForComponentHeader;
- (CGFloat)heightForComponentFooter;

- (CGFloat)estimatedHeightForComponentItemWithTableView:(UITableView *)tableView
                                            atIndexPath:(NSIndexPath *)indexPath;
/* @用下面这个方法替代此方法
 * @龚俊慧
 * @2016-8-24
 */
// - (CGFloat)heightForComponentItemAtIndex:(NSUInteger)index;
- (CGFloat)heightForComponentItemWithTableView:(UITableView *)tableView
                                   atIndexPath:(NSIndexPath *)indexPath;
/****************************修改结束********************************/

- (__kindof UITableViewCell *)cellForTableView:(UITableView *)tableView
                                   atIndexPath:(NSIndexPath *)indexPath;
- (__kindof UIView *)headerForTableView:(UITableView *)tableView;
- (__kindof UIView *)footerForTableView:(UITableView *)tableView;

- (void)reloadDataWithTableView:(UITableView *)tableView
                      inSection:(NSInteger)section;
- (void)registerWithTableView:(UITableView *)tableView;

@optional

- (void)willDisplayHeader:(__kindof UIView *)header;
- (void)willDisplayCell:(__kindof UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath;

- (void)didSelectItemAtIndex:(NSUInteger)index;

@end
