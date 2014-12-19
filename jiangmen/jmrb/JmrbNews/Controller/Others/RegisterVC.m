//
//  RegisterVC.m
//  JmrbNews
//
//  Created by 龚 俊慧 on 14/12/18.
//
//

#import "RegisterVC.h"

@interface RegisterVC ()

@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - custom methods

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:@"注册"];
    [self setup];
}

- (void)configureViewsProperties
{
    for (UIView *subView in self.view.subviews)
    {
        if ([subView isKindOfClass:[FUITextField class]])
        {
            subView.backgroundColor = [UIColor whiteColor];
            [subView addBorderToViewWitBorderColor:CellSeparatorColor borderWidth:LineWidth];
        }
    }
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

- (IBAction)clickRegisterBtn:(UIButton *)sender
{
    RegisterVC *registerVC = [RegisterVC loadFromNib];
    [self pushViewController:registerVC];
}

@end
