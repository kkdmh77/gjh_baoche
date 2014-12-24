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
    [self dddd];
    [self initialization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)dddd
{
    MyMessageEntity *entity = [[MyMessageEntity alloc] init];
    entity.messageTitleStr = @"周杰伦";
    entity.messageContentStr = @"我的消息";
    
    MyMessageEntity *entity1 = [[MyMessageEntity alloc] init];
    entity1.messageTitleStr = @"周杰伦";
    entity1.messageContentStr = @"我的消息我的消息我的消息我的消息我的消息我的消息我的消息";
    
    _netMyMessageEntityArray = [NSMutableArray arrayWithObjects:entity, entity1, nil];
}

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

- (MyMessageEntity *)curShowDataAtIndex:(NSInteger)index
{
    return index < _netMyMessageEntityArray.count ? _netMyMessageEntityArray[index] : nil;
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _netMyMessageEntityArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MyMessageCell getCellHeightWithItemEntity:[self curShowDataAtIndex:indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier_myMessage];
    
    MyMessageEntity *entity = [self curShowDataAtIndex:indexPath.row];;
    [cell loadCellShowDataWithItemEntity:entity];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
