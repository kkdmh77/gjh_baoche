//
//  MyMessageVC.m
//  JmrbNews
//
//  Created by 龚 俊慧 on 14/12/24.
//
//

#import "MyMessageVC.h"
#import "MyMessageCell.h"

static NSString * const cellIdentifier_myMessage = @"cellIdentifier_myMessage";

@interface MyMessageVC ()
{
    NSMutableArray *_netMyMessageEntityArray;
}

@end

@implementation MyMessageVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Left
                            barButtonTitle:Cancel
                                    action:@selector(backViewController)];
    
    [self initialization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:@"我的消息"];
}

- (void)setNetworkRequestStatusBlocks
{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        
        
    }];
}

- (void)getNetworkData
{
    
}

- (NSMutableArray *)parseNetDataWithDic:(NSDictionary *)dic
{
    return nil;
}

- (void)initialization
{
    // tab
    [self setupTableViewWithFrame:self.view.bounds
                            style:UITableViewStylePlain
                  registerNibName:NSStringFromClass([MyMessageCell class])
                  reuseIdentifier:cellIdentifier_myMessage];
}

- (void)reloadTableData
{
    [_tableView reloadData];
}

//- (CommentEntity *)curShowDataAtIndex:(NSInteger)index
//{
//    return index < _netCommentEntityArray.count ? _netCommentEntityArray[index] : nil;
//}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _netMyMessageEntityArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MyMessageCell getCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier_myMessage];
    
//    CommentEntity *entity = [self curShowDataAtIndex:indexPath.row];;
//    [cell loadCellShowDataWithItemEntity:entity];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
