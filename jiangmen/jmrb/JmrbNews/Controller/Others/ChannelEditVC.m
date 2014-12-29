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
#import "ChannelEditHeaderView.h"
#import "ChannelEditFooterView.h"
#import "UserInfoModel.h"
#import "CommonEntity.h"
#import "BaseTabBarVC.h"
#import "NewsManagerVC.h"
#import <objc/runtime.h>
#import "GCDThread.h"

static NSString * const cellIdentifier_collecitonViewCell = @"cellIdentifier_collecitonViewCell";
static NSString * const cellIdentifier_collecitonViewHeader = @"cellIdentifier_collecitonViewHeader";
static NSString * const cellIdentifier_collecitonViewFooter = @"cellIdentifier_collecitonViewFooter";

@interface ChannelEditVC ()
{
    UICollectionView *_collectionView;
    
    NSMutableArray *_selectedNewsTypeArray;
    NSMutableArray *_unSelectNewsTypeArray;
}

@end

@implementation ChannelEditVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _selectedNewsTypeArray = [NSMutableArray arrayWithArray:[UserInfoModel getUserDefaultSelectedNewsTypesArray]];
    _unSelectNewsTypeArray = [NSMutableArray arrayWithArray:[UserInfoModel getUserDefaultUnSelectNewsTypesArray]];
    
    [self initialization];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)backViewController
{
    [UserInfoModel setUserDefaultSelectedNewsTypesArray:_selectedNewsTypeArray];
    [UserInfoModel setUserDefaultUnSelectNewsTypesArray:_unSelectNewsTypeArray];
    
    UIViewController *controller = objc_getAssociatedObject(self, class_getName([NewsManagerVC class]));
    if ([controller isKindOfClass:[NewsManagerVC class]])
    {
        [((NewsManagerVC *)controller) configureSlideSwitchView];
    }
    
    [super backViewController];
}

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
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ChannelEditHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cellIdentifier_collecitonViewHeader];
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ChannelEditFooterView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:cellIdentifier_collecitonViewFooter];
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view).offset(@15);
        make.right.equalTo(self.view).offset(@(-15));
    }];
    
    // tableview
    _tableView = InsertTableView(self.view, CGRectZero, self, self, UITableViewStylePlain);
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
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
    return _selectedNewsTypeArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChannelEditCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier_collecitonViewCell forIndexPath:indexPath];
    
    NewsTypeEntity *entity = _selectedNewsTypeArray[indexPath.item];
    cell.titleLabel.text = entity.newsTypeNameStr;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader)
    {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cellIdentifier_collecitonViewHeader forIndexPath:indexPath];
        return view;
    }
    else
    {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:cellIdentifier_collecitonViewFooter forIndexPath:indexPath];
        return view;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.boundsWidth, 50);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.boundsWidth, 33);
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NewsTypeEntity *entity = _selectedNewsTypeArray[fromIndexPath.row];
    [_selectedNewsTypeArray removeObjectAtIndex:fromIndexPath.row];
    [_selectedNewsTypeArray insertObject:entity atIndex:toIndexPath.row];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewsTypeEntity *entity = _selectedNewsTypeArray[indexPath.item];
    
    [_unSelectNewsTypeArray addObject:entity];
    [_selectedNewsTypeArray removeObjectAtIndex:indexPath.item];
    
    [_collectionView reloadData];
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _unSelectNewsTypeArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = PageBackgroundColor;
        cell.backgroundView = nil;
        cell.textLabel.font = SP15Font;
        cell.textLabel.textColor = Common_BlackColor;
    }
    
    NewsTypeEntity *entity = _unSelectNewsTypeArray[indexPath.row];
    cell.textLabel.text = entity.newsTypeNameStr;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NewsTypeEntity *entity = _unSelectNewsTypeArray[indexPath.row];
    
    [_selectedNewsTypeArray addObject:entity];
    [_unSelectNewsTypeArray removeObjectAtIndex:indexPath.row];
    
    [_collectionView reloadData];
    [_tableView reloadData];
}

@end
