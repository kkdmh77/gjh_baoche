//
//  BaseScrollComponentVC.m
//  kkyingyu100
//
//  Created by 龚 俊慧 on 16/3/16.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import "BaseScrollComponentVC.h"
#import "GJHSlideSwitchView.h"
#import "BaseScrollComponentItemCell.h"
#import <objc/runtime.h>

static NSString * const kBaseScrollComponentItemCellIdentifier = @"kBaseScrollComponentItemCellIdentifier";

@interface BaseScrollComponentVC () <GJHSlideSwitchViewDelegate ,StyleSelectorViewDelegate>

@property (nonatomic, strong) GJHSlideSwitchView *sliderSwitch;
@property (nonatomic, strong) StyleSelectorView *selectorView;

@property (nonatomic, assign) NSInteger scrollIndex;

@end

@implementation BaseScrollComponentVC

- (instancetype)initWithTableCellRegisterNibName:(NSString *)nibName
{
    self = [super init];
    if (self)
    {
        self.cellNibName = nibName;
        self.scrollIndex = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)initialization
{
    self.sliderSwitch = [[GJHSlideSwitchView alloc] initWithFrame:CGRectMake(0, 0, self.viewBoundsWidth, kDefaultSlideSwitchViewHeight)
                                                      titlesArray:[self slideSwitchTitles]];
    _sliderSwitch.slideSwitchViewDelegate = self;
    _sliderSwitch.tabItemNormalColor = [UserInfoModel sharedInstance].isNightThemeStyle ? Common_SilveryWhiteColor_Night : Common_BlackColor;
    _sliderSwitch.shadowImage = [UIImage imageWithColor:Common_InkBlackColor];
    [_sliderSwitch buildUI];
    _sliderSwitch.topScrollView.dk_backgroundColorPicker = DKColorWithColors(Common_ThemeColor, Common_ThemeColor_Night);
    [self.view addSubview:_sliderSwitch];
    
    self.selectorView = [[StyleSelectorView alloc] initWithFrame:CGRectMake(0, _sliderSwitch.frameHeight, self.viewFrameWidth, self.viewFrameHeight - _sliderSwitch.frameHeight)
                                                 registerNibName:NSStringFromClass([BaseScrollComponentItemCell class])];
    _selectorView.delegate = self;
    _selectorView.sectionInset = UIEdgeInsetsZero;
    _selectorView.minimumInteritemSpacing = 0;
    _selectorView.minimumLineSpacing = 0;
    _selectorView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _selectorView.collectionView.pagingEnabled = YES;
    [_selectorView keepAutoresizingInFull];
    
    [self.view addSubview:_selectorView];

    // 滚动到默认位置
    [self scrollToDefaultIndex:_defaultScrollIndex];
}

- (void)setDefaultScrollIndex:(NSInteger)defaultScrollIndex
{
    _defaultScrollIndex = defaultScrollIndex;
    
    [self scrollToDefaultIndex:defaultScrollIndex];
}

- (void)scrollToDefaultIndex:(NSInteger)index
{
    if (_sliderSwitch && _selectorView && index >= 0 && index < [self slideSwitchTitles].count)
    {
        self.scrollIndex = index;
        
        [_sliderSwitch scrollToIndex:(int)index animated:NO];
        
        [_selectorView.collectionView performBatchUpdates:^{
            [_selectorView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]
                                                 atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                         animated:NO];
            [_selectorView reloadData];
        } completion:^(BOOL finished) {
            /*
            [_selectorView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]
                                                 atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                         animated:NO];
             */
        }];
    }
}

- (NSArray<NSString *> *)slideSwitchTitles
{
    NSAssert(NO, @"子类必须实现");
    
    return nil;
}

- (NSArray<NSArray *> *)dataArray
{
    NSAssert(NO, @"子类必须实现");
    
    return nil;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section scrollIndex:(NSInteger)scrollIndex tableView:(UITableView *)tableView
{
    NSAssert(NO, @"子类必须实现");
    
    return 0;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath scrollIndex:(NSInteger)scrollIndex tableView:(UITableView *)tableView
{
    NSAssert(NO, @"子类必须实现");
    
    return 0;
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath scrollIndex:(NSInteger)scrollIndex tableView:(UITableView *)tableView
{
    NSAssert(NO, @"子类必须实现");
    
    return nil;
}

#pragma mark - GJHSlideSwitchViewDelegate methods

- (void)slideSwitchView:(GJHSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    if (number < [self dataArray].count && _scrollIndex != number)
    {
        self.scrollIndex = number;
        [_selectorView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:number inSection:0]
                                             atScrollPosition:UICollectionViewScrollPositionNone
                                                     animated:YES];
    }
}

#pragma mark - StyleSelectorViewDelegate methods

- (NSInteger)numberOfItemsInStyleSelectorView:(StyleSelectorView *)selectorView
{
    return [self dataArray].count;
}

- (CGSize)sizeForItemInStyleSelectorView:(StyleSelectorView *)selectorView
{
    return CGSizeMake(IPHONE_WIDTH, IPHONE_HEIGHT - STATUS_BAR_HEIGHT - NAV_BAR_HEIGHT - kDefaultSlideSwitchViewHeight);
}

- (void)styleSelectorView:(StyleSelectorView *)selectorView itemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    BaseScrollComponentItemCell *itemCell = (BaseScrollComponentItemCell *)view;

    BaseScrollComponentVC *obj = objc_getAssociatedObject(view, kBaseScrollComponentAssociatedKey);
    if (!obj)
    {
        objc_setAssociatedObject(view, kBaseScrollComponentAssociatedKey, self, OBJC_ASSOCIATION_ASSIGN);
        
        if ([_cellNibName isAbsoluteValid])
        {
            UINib *nib = [UINib nibWithNibName:_cellNibName bundle:nil];
            if (nib)
            {
                [itemCell.tableView registerNib:nib forCellReuseIdentifier:kBaseScrollComponentTabCellIdentifier];
            }
            else
            {
                [itemCell.tableView registerClass:NSClassFromString(_cellNibName) forCellReuseIdentifier:kBaseScrollComponentTabCellIdentifier];
            }
        }
    }
    WEAKSELF
    itemCell.tag = index;
    itemCell.didSelectRowInTab = ^(NSIndexPath *tabIndexPath) {
        if (weakSelf.didSelectRowInTabHandle) {
            weakSelf.didSelectRowInTabHandle(index, tabIndexPath);
        }
    };
    
    [itemCell reloadData];
}

- (void)styleSelectorView:(StyleSelectorView *)selectorView didScrollItemAtIndex:(NSInteger)index
{
    if (_scrollIndex != index)
    {
        self.scrollIndex = index;
        [_sliderSwitch scrollToIndex:(int)index];
    }
}

@end
