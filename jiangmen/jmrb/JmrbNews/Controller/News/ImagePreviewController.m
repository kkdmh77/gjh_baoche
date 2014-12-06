//
//  ImagePreviewController.m
//  JmrbNews
//
//  Created by swift on 14/12/6.
//
//

#import "ImagePreviewController.h"
#import "CycleScrollView.h"

#define kNavBarHeight (44.0 + 20.0)

@interface ImagePreviewController () <CycleScrollViewDelegate>
{
    UINavigationBar *_navBar;
}

@end

@implementation ImagePreviewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialization];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)initialization
{
    _navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.viewBoundsWidth, kNavBarHeight)];
    [_navBar setBackgroundImage:[UIImage imageWithColor:[UIColor blackColor] size:CGSizeMake(1, 1)]
                 forBarMetrics:UIBarMetricsDefault];
    _navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:nil];
    item.leftBarButtonItem = [UIBarButtonItem barButtonItemWithFrame:CGRectMake(0, 0, 30, 30)
                                                           normalImg:[UIImage imageNamed:@"navBack"]
                                                      highlightedImg:nil
                                                              target:self action:@selector(backViewController)];
    _navBar.items = @[item];
    [self.view addSubview:_navBar];
    
    // scroll
    /*
    UIScrollView *scrollView = InsertScrollView(self.view, self.view.bounds, 1000, self);
    [scrollView addTarget:self action:@selector(operationTapGesture:)];
    scrollView.backgroundColor = [UIColor blueColor];
     */
    CycleScrollView *scrollView = [[CycleScrollView alloc] initWithFrame:self.view.bounds
                                                         viewContentMode:ViewShowStyle_AutoResizing
                                                                delegate:self
                                                         imgUrlsStrArray:_imageSourceArray
                                                            isAutoScroll:NO
                                                               isCanZoom:YES];
    
    [self.view addSubview:scrollView];
    
    // 前置navBar
    [self.view bringSubviewToFront:_navBar];
}

- (void)operationTapGesture:(UITapGestureRecognizer *)gesture
{
    [self hideOrShowNavigationBar];
}

- (void)hideOrShowNavigationBar
{
    WEAKSELF
    [_navBar animationFadeWithExecuteBlock:^{
        STRONGSELF
        strongSelf->_navBar.hidden = !strongSelf->_navBar.hidden;
        [UIApplication sharedApplication].statusBarHidden = strongSelf->_navBar.hidden;
    }];
}

#pragma mark - CycleScrollViewDelegate methods

- (void)didClickPage:(CycleScrollView *)csView atIndex:(NSInteger)index
{
    DLog(@"click index = %d",index);
    [self hideOrShowNavigationBar];
}

@end
