//
//  MainPageOrderChannelVC.m
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MainPageOrderChannelVC.h"
#import "ZSSourceModel.h"
#import "ImageContant.h"

@interface MainPageOrderChannelVC ()

- (void)refreshNewsCategory;

@end

@implementation MainPageOrderChannelVC
@synthesize orderTableView;
@synthesize newsCatagoryArray;

#pragma mark - Private
- (void)refreshNewsCategory {
    NSMutableDictionary *allDic = [[ZSSourceModel defaultSource] newsTypeDataDic];
    if (allDic == nil) {
        return;
    }
    NSDictionary *responseDic = [allDic objectForKey:@"response"];
    NSArray *itemArray = [responseDic objectForKey:@"item"];
    if ([itemArray count] > 0) {
        [self setNewsCatagoryArray:itemArray];
        [orderTableView reloadData];
    }
}

#pragma mark - System
- (void)dealloc {
    [self setNewsCatagoryArray:nil];
    [_imageQueue prepareRelease];
    [_imageQueue release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageQueue = [[ImageLoaderQueue alloc] initWithTarget:self];
    [orderTableView setDelegate:self];
    [orderTableView setDataSource:self];   
    [self refreshNewsCategory];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNewsCategory) name:Notification_getNewsType object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [newsCatagoryArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *indetifyString = @"OrderCell";
    MoreOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:indetifyString];
    if (!cell) {
        [[NSBundle mainBundle] loadNibNamed:@"MoreOrderCell" owner:self options:nil];
        cell = _moreOrderCell;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    NSDictionary *itemDic = [newsCatagoryArray objectAtIndex:indexPath.section];
    UIImage *image = [_imageQueue getImageForURL:[itemDic objectForKey:@"newstype_Icon_Small"]];
    NSInteger newsId = [[itemDic objectForKey:@"newstype_id"] intValue];
    if (!image) {
        image = [UIImage imageByName:@"home_image_loading" withExtend:@"png"];
        [_imageQueue addOperationToQueueWithURL:[itemDic objectForKey:@"newstype_Icon_Small"] atIndex:indexPath.section];
    }
//    BOOL isOrder = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%i",Key_Channel_Order_Number, newsId]] boolValue];
//    [cell.orderSwitch setOn:isOrder];
    [cell setNewsId:newsId];
    [cell.cellImageView setImage:image];
    [cell.cellLabel setText:[itemDic objectForKey:@"newstyle_OrderName"]];
    return cell;
}

#pragma mark - Xib Function
- (IBAction)clickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_AdjustOrderNews object:nil];
}

#pragma mark - ImageQueueDelegate 
- (void)imageOperationCompleted:(UIImage *)_image atIndex:(NSInteger)_index {
    [orderTableView reloadData];
}


@end
