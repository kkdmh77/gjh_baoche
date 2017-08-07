//
//  HomePageViewController.m
//  Movie
//
//  Created by 龚 俊慧 on 2017/6/3.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import "HomePageViewController.h"
#import <NerdyUI/NerdyUI.h>
#import "StyleSelectorView.h"
#import "HomePageClllectionCell.h"
#import "BaseNetworkViewController+NetRequestManager.h"
#import "UrlManager.h"
#import "HomePageCollectionModel.h"
#import "MoviePlayerViewController.h"
#import <MediaPlayer/MPMoviePlayerViewController.h>

@interface HomePageViewController ()<StyleSelectorViewDelegate>

@property (nonatomic, strong) StyleSelectorView *selectorView;
@property (nonatomic, strong) NSArray<HomePageCollectionSectionModel *> *sectionModelArray;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initialization];
    [self getNetworkData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)initialization
{
    self.selectorView = [[StyleSelectorView alloc] initWithFrame:self.view.bounds
                                                 registerNibName:NSStringFromClass([HomePageClllectionCell class])];
    _selectorView.delegate = self;
    [self.view addSubview:_selectorView];
}

- (void)getNetworkData {
    /*bundleId=com.jipin.video&loc=22.35997571501532%2C113.4394260523032&pageSize=6&plat=1&sversion=10.3.2&version=1.3.2*/
    /*http://video2.dazhuangzhuang.com/detail/movie?bundleId=com.jipin.video&plat=1&sversion=10.3.2&version=1.3.2&videoId=9300ac5f-7ee7-4b05-ab91-b2a55467a808*/
    
//    [self sendRequest:[[self class] getRequestURLStr:NetHomePageRequestType_GetRecommendList]
//         parameterDic:@{@"bundleId": bundleId,
//                        @"pageSize": @(6),
//                        @"plat": @(plat),
//                        @"sversion": sversion,
//                        @"version": version}
//           requestTag:NetHomePageRequestType_GetRecommendList];
    
    [self sendRequest:@"video/analysis"
         parameterDic:@{@"version": @"1.3.2",
                        @"a":@"NK8YubJs3dLw69j4qAnWjtQPOTM8fJ3Nd+ZsU99WB27Fuuq6ObajBGd9DJSmEdno\r\n0a5HbhDEUauzFlTCLqUnnDbvqVv6wzTzXJw6JbZxhXw5N7sUbdkPHFXTzODPJLOa\r\nkhdjQeop1KvGbalxndrqcjTl2snnglCqC6RydW1jb2xlveoSiUuXO\\/Sze\\/SW1FdY\r\nCVytKKsh1fb6tDgrsPWVWR1Vb1ZWEeXa3Tg8vwkJA0cH0OGkkTMYVK\\/wc2M9fIMU\r\neb7mJDzKWBdiJwkyxnGQueZWAr2ceeL3G\\/Ptn7sSjPvOwYm1FXGLs1c8qcJjIKyS\r\nRkRvJEyaXXq20Vp9LDwPAg==",
                        @"plat": @"1",
                        @"loc": @"22.35986534266081,113.4394897143992",
                        @"bundleId": @"com.jipin.video",
                        @"sversion": @"10.3.2"
                        }
    requestMethodType:RequestMethodType_POST
           requestTag:1];
    
}

- (void)setNetworkRequestStatusBlocks {
    @weakify(self)
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
//        if ([successInfoObj isValidArray]) {
            NSString *b = [successInfoObj safeObjectForKey:@"b"];
            NSString *ss = [NSString stringWithBase64EncodedString:b];
        
        NSData *base64ResponseData = [NSData dataFromBase64String:b];
        NSString *string = [base64ResponseData base64EncodedString];
        NSString *ss1 = [NSString stringWithBase64EncodedString:string];
        
        
        NSString *key = @"1234567890123456";
        NSString *base = @"5Y+R6aG6ZmFzZGZhc2RmYXNkZmFzZGZhc2RmYWRkZH5zc+mYv+mHjOaWr+mhv+aUvui+o+akkuaSkuaXpuazlQ==";
        NSData *data = [base dataUsingEncoding:NSUTF8StringEncoding];
        data = [data aes256EncryptWithKey:[key dataUsingEncoding:NSUTF8StringEncoding] iv:nil];
        
        
        NSString *sss = [data base64EncodedString];
        NSString *asdfasd = [NSString stringWithBase64EncodedString:sss];
        
        NSData *er = [NSData dataWithBase64EncodedString:sss];
        
        NSData *newData = [er aes256DecryptWithkey:[key dataUsingEncoding:NSUTF8StringEncoding] iv:nil];
        NSString *newStr = [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding];
        
            NSArray *tempArray = (NSArray *)successInfoObj;
            
            NSMutableArray *tempSectionModelsArray = [NSMutableArray arrayWithCapacity:tempArray.count];
            for (NSDictionary *tempDic in tempArray) {
                HomePageCollectionSectionModel *model = [HomePageCollectionSectionModel modelWithJSON:tempDic];
                [tempSectionModelsArray addObject:model];
            }
            
            if ([tempSectionModelsArray isValidArray]) {
                weak_self.sectionModelArray = tempSectionModelsArray;
                [weak_self.selectorView reloadData];
            }
//        }
    } failedBlock:^(NetRequest *request, NSError *error) {
        
    }];
}

#pragma mark - StyleSelectorViewDelegate methods

- (NSInteger)numberOfItemsInStyleSelectorView:(StyleSelectorView *)selectorView {
    return 1;
}

- (CGSize)sizeForItemInStyleSelectorView:(StyleSelectorView *)selectorView {
    return CGSizeMake(100, 130);
}

- (void)styleSelectorView:(StyleSelectorView *)selectorView itemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    HomePageClllectionCell *cell = (HomePageClllectionCell *)view;
    
    HomePageCollectionItemModel *model = _sectionModelArray[0].itemModelArray[0];
    [cell.imageView setImageWithURL:[NSURL URLWithString:model.thumbnailImage]
                            options:YYWebImageOptionUseNSURLCache];
}

- (void)styleSelectorView:(StyleSelectorView *)selectorView didSelectItemAtIndex:(NSInteger)index {
//    MoviePlayerViewController *playerViewController = [[MoviePlayerViewController alloc] init];
//    playerViewController.videoURL = [NSURL URLWithString:@"http://pan.baidu.com/share/link?shareid=4216047301&uk=1331816597&fid=584139194710121.mp4"];
//    [self pushViewController:playerViewController];
    
    MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:@"http://pan.baidu.com/share/link?shareid=4216047301&uk=1331816597&fid=584139194710121"]];
    [self pushViewController:player];
}

@end
