//
//  MoreVC.m
//  ZhongShangPaper
//
//  Created by Danny Deng on 12-2-22.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import "MoreVC.h"
#import "ImageContant.h"
#import "ZSCommunicateModel.h"
#import "ZSSourceModel.h"

@interface MoreVC()

- (void)refreshMoreNewsCategory;

@end

@implementation MoreVC
@synthesize moreTableView;
@synthesize delegate;
@synthesize adsArray;

#pragma mark - Private
- (void)refreshMoreNewsCategory {
    NSMutableDictionary *adsAllDic = [[ZSSourceModel defaultSource] moreNewsAdsDic];
    if (adsAllDic) {
        NSDictionary *responseDic = [adsAllDic objectForKey:@"response"];
        NSMutableArray *itemArray = [responseDic objectForKey:@"item"];
        NSMutableArray *array = [NSMutableArray arrayWithArray:itemArray];
        [self setAdsArray:array];
        [moreTableView reloadData];
    }
}

#pragma mark - View lifecycle
- (void)dealloc {
    [imageArray release];
    [labelArray release];
    [imageQueue prepareRelease];
    [imageQueue setTarget:nil];
    [imageQueue release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_moreKeep release];
    [_moreCell release];
    [self setAdsArray:nil];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    imageQueue = [[ImageLoaderQueue alloc] initWithTarget:self];
    [moreTableView setDelegate:self];
    [moreTableView setDataSource:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMoreNewsCategory) name:Notification_MoreAds object:nil];
    [self refreshMoreNewsCategory];
}

- (IBAction)clickSelectItem:(id)sender {
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (adsArray && [adsArray count]>0) {
        return 5 + [adsArray count];
    }
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifierString = @"moreCell";
    MoreCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierString];
    if (!cell) {
        [[NSBundle mainBundle] loadNibNamed:@"MoreCell" owner:self options:nil];
        cell = _moreCell;
    }
    UIImage *image = nil;
    switch (indexPath.section) {
        case 0:
            [cell.cellLabel setText:@"阅读模式"];
            image = [UIImage imageByName:@"TarBar_list_icon_read_model" withExtend:@"png"];
            break;
        case 1:
            [cell.cellLabel setText:@"栏目定制"];
            image = [UIImage imageByName:@"TarBar_list_icon_customize_feed" withExtend:@"png"];
            break;
        case 2:
            [cell.cellLabel setText:@"关于"];
            image = [UIImage imageByName:@"TarBar_list_icon_aboutus" withExtend:@"png"];
            break;
        case 3:
            [cell.cellLabel setText:@"收藏"];
            image = [UIImage imageByName:@"TarBar_Keep_title_icon_Down" withExtend:@"png"];
            break;
        case 4:
            [cell.cellLabel setText:@"本报记者登陆"];
            image = [UIImage imageByName:@"TarBar_login_title_icon_Down" withExtend:@"png"];
            break;
        default:{
            if (indexPath.section-5>=0 && indexPath.section-5<[adsArray count]) {
                NSDictionary *itemDic = [adsArray objectAtIndex:indexPath.section - 5];
                NSString *ads_name = [itemDic objectForKey:@"moreAds_name"];
                [cell.cellLabel setText:ads_name];
                NSString *urlString = [itemDic objectForKey:@"moreAds_imageSrc"];
                image = [imageQueue getImageForURL:urlString];
                if (image == nil) {
                    image = [UIImage imageByName:@"home_image_loading" withExtend:@"png"];
                    [imageQueue addOperationToQueueWithURL:urlString atIndex:indexPath.section];
                }
            }
            break;
        }
    }
    [cell.cellImageView setImage:image];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            MoreReadModelVC *readModel = [[MoreReadModelVC alloc] initWithNibName:@"MoreReadModelVC" bundle:nil];
            [readModel setDelegate:self];
            [self.navigationController pushViewController:readModel animated:YES];
            [readModel release];
            break;
        }
        case 1: {
            MoreOrderChannelVC *orderChannnel = [[MoreOrderChannelVC alloc] initWithNibName:@"MoreOrderChannelVC" bundle:nil];
            [orderChannnel setDelegate:self];
            [self.navigationController pushViewController:orderChannnel animated:YES];
            [orderChannnel release];
            break;
        }
        case 2:{
            MoreAboutVC *moreAbout = [[MoreAboutVC alloc] initWithNibName:@"MoreAboutVC" bundle:nil];
            [moreAbout setDelegate:self];
            [self.navigationController pushViewController:moreAbout animated:YES];
            [moreAbout release];
            break;
        }
        case 3:{
            if (_moreKeep) {
                [_moreKeep release];
            }
            _moreKeep = [[MoreKeepVC alloc] initWithNibName:@"MoreKeepVC" bundle:nil];
            [_moreKeep setDelegate:self];
            [self.navigationController pushViewController:_moreKeep animated:YES];
            break;
        }   
        case 4:{
            MoreLoginVC *loginVC = [[MoreLoginVC alloc] initWithNibName:@"MoreLoginVC" bundle:nil];
            [loginVC setDelegate:self];
            [self.navigationController pushViewController:loginVC animated:YES];
            [loginVC release];
            break;
        }   
        default:{
            [moreTableView deselectRowAtIndexPath:indexPath animated:YES];
            if (indexPath.section-5>=0 && indexPath.section-5<[adsArray count]) {
                NSDictionary *itemDic = [adsArray objectAtIndex:indexPath.section - 5];
                NSString *urlString = [itemDic objectForKey:@"moreAds_webSrc"];
                NSURL *url=[NSURL URLWithString:urlString];
                [[UIApplication sharedApplication] openURL:url];
            }
            break;
        }
    }
}

#pragma mark - MoreKeepDelegate
- (void)MoreKeepHideTarBar:(BOOL)isHide {
    if (delegate && [delegate respondsToSelector:@selector(MoreVCHideTarBar:)]) {
        [delegate MoreVCHideTarBar:isHide];
    }
}

#pragma mark imageQueueDelegate
- (void)imageOperationCompleted:(UIImage *)_image atIndex:(NSInteger)_index {
    [moreTableView reloadData];
}

#pragma mark - AllMoreDetailDelegate
- (void)MoreDetailGoBack {
    NSIndexPath *indexPath = [moreTableView indexPathForSelectedRow];
    [moreTableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
