//
//  NewsManagerVC.m
//  JmrbNews
//
//  Created by swift on 14/12/2.
//
//

#import "NewsManagerVC.h"
#import "NewsVC.h"

@interface NewsManagerVC () <SUNSlideSwitchViewDelegate>

@property (nonatomic, strong) UIViewController *vc1;
@property (nonatomic, strong) UIViewController *vc2;
@property (nonatomic, strong) UIViewController *vc3;
@property (nonatomic, strong) UIViewController *vc4;
@property (nonatomic, strong) UIViewController *vc5;
@property (nonatomic, strong) UIViewController *vc6;

@end

@implementation NewsManagerVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)initialization
{
    self.title = @"滑动切换视图";
    self.slideSwitchView = [[SUNSlideSwitchView alloc] initWithFrame:self.view.bounds];
    [_slideSwitchView keepAutoresizingInFull];
    _slideSwitchView.slideSwitchViewDelegate = self;
    _slideSwitchView.tabItemNormalColor = HEXCOLOR(0X636363);
    _slideSwitchView.tabItemSelectedColor = HEXCOLOR(0X005BA5);
    _slideSwitchView.shadowImage = [[UIImage imageNamed:@"red_line_and_shadow.png"]
                                    stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
    [self.view addSubview:_slideSwitchView];
    
    self.vc1 = [[NewsVC alloc] init];
    self.vc1.title = @"高血";
    
    self.vc2 = [[UIViewController alloc] init];
    self.vc2.title = @"糖尿病防治";
    
    self.vc3 = [[UIViewController alloc] init];
    self.vc3.title = @"健康养生";
    
    self.vc4 = [[UIViewController alloc] init];
    self.vc4.title = @"慢病保健";
    
    self.vc5 = [[UIViewController alloc] init];
    self.vc5.title = @"亚健康调理";
    
    self.vc6 = [[UIViewController alloc] init];
    self.vc6.title = @"疾病预防";
    
    /*
     UIButton *rightSideButton = [UIButton buttonWithType:UIButtonTypeCustom];
     [rightSideButton setImage:[UIImage imageNamed:@"icon_rightarrow.png"] forState:UIControlStateNormal];
     [rightSideButton setImage:[UIImage imageNamed:@"icon_rightarrow.png"]  forState:UIControlStateHighlighted];
     rightSideButton.frame = CGRectMake(0, 0, 20.0f, 44.0f);
     rightSideButton.userInteractionEnabled = NO;
     self.slideSwitchView.rigthSideButton = rightSideButton;
     */
    
    [self.slideSwitchView buildUI];
    
    self.navigationItem.titleView = _slideSwitchView.topScrollView;
    self.navigationItem.leftBarButtonItem = nil;
    [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Right normalImg:[UIImage imageNamed:@"jiahao"] highlightedImg:nil action:NULL];
}

#pragma mark - 滑动tab视图代理方法

- (NSUInteger)numberOfTab:(SUNSlideSwitchView *)view
{
    return 6;
}

- (UIViewController *)slideSwitchView:(SUNSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    if (number == 0)
    {
        return self.vc1;
    }
    else if (number == 1)
    {
        return self.vc2;
    }
    else if (number == 2)
    {
        return self.vc3;
    }
    else if (number == 3)
    {
        return self.vc4;
    }
    else if (number == 4)
    {
        return self.vc5;
    }
    else if (number == 5)
    {
        return self.vc6;
    }
    else
    {
        return nil;
    }
}

- (void)slideSwitchView:(SUNSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer *)panParam
{
    
}

- (void)slideSwitchView:(SUNSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    UIViewController *vc = nil;
    if (number == 0)
    {
        vc = self.vc1;
    }
    else if (number == 1)
    {
        vc = self.vc2;
    }
    else if (number == 2)
    {
        vc = self.vc3;
    }
    else if (number == 3)
    {
        vc = self.vc4;
    }
    else if (number == 4)
    {
        vc = self.vc5;
    }
    else if (number == 5)
    {
        vc = self.vc6;
    }
//    [vc viewDidCurrentView];
}

@end
