//
//  ChannelEditVC.m
//  JmrbNews
//
//  Created by swift on 14/12/26.
//
//

#import "ChannelEditVC.h"
#import "DraggableCollectionViewFlowLayout.h"
#import "ChannelEditCollectionCell.h"

static NSString * const cellIdentifier_collecitonViewCell = @"cellIdentifier_collecitonViewCell";

@interface ChannelEditVC ()
{
    UICollectionView *_collectionView;
    
    NSMutableArray *_array;
}

@end

@implementation ChannelEditVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _array = [NSMutableArray arrayWithObjects:@"1", @"2",@"3",@"4",@"5",@"6",@"7",nil];
    
    [self initialization];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:@"内容定制"];
}

- (void)initialization
{
    // collection view
    DraggableCollectionViewFlowLayout *layout = [[DraggableCollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(60, 35);
    layout.minimumLineSpacing = 18;
    layout.minimumInteritemSpacing = 13;
    layout.sectionInset = UIEdgeInsetsZero;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.draggable = YES;
    _collectionView.scrollingEdgeInsets = UIEdgeInsetsMake(10, 15, 10, 15);
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ChannelEditCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:cellIdentifier_collecitonViewCell];
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    // tableview
    _tableView = InsertTableView(self.view, CGRectZero, self, self, UITableViewStylePlain);
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_collectionView);
        make.right.equalTo(_collectionView);
        make.top.equalTo(_collectionView.mas_bottom).offset(@0);
        make.height.equalTo(_collectionView);
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier_collecitonViewCell forIndexPath:indexPath];
    if (0 == indexPath.section && 0 == indexPath.item)
    {
        cell.backgroundColor = [UIColor grayColor];
        cell.userInteractionEnabled = NO;
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [_array exchangeObjectAtIndex:fromIndexPath.item withObjectAtIndex:toIndexPath.item];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
