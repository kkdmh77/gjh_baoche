//
//  AddPassengersVC.m
//  BaoChe
//
//  Created by 龚 俊慧 on 15/1/13.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "AddPassengersVC.h"
#import "OrderWriteVC.h"
#include <objc/runtime.h>
#import "CommonEntity.h"
#import "StringJudgeManager.h"

@interface AddPassengersVC ()

@property (weak, nonatomic) IBOutlet UIView *theContactBGView;
@property (weak, nonatomic) IBOutlet UILabel *theContactDescLabel;
@property (weak, nonatomic) IBOutlet UITextField *theContactTF;

@property (weak, nonatomic) IBOutlet UIView *idCardBGView;
@property (weak, nonatomic) IBOutlet UILabel *idCardDescLabel;
@property (weak, nonatomic) IBOutlet UITextField *idCardTF;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end

@implementation AddPassengersVC

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
    [self setNavigationItemTitle:@"添加乘客"];
    
    [self setup];
}

- (void)configureViewsProperties
{
    UIColor *blackColor = Common_BlackColor;
    UIColor *grayColor = Common_GrayColor;
    
    _theContactBGView.backgroundColor = [UIColor whiteColor];
    [_theContactBGView addLineWithPosition:ViewDrawLinePostionType_Bottom
                              lineColor:CellSeparatorColor
                              lineWidth:LineWidth];
    _idCardBGView.backgroundColor = [UIColor whiteColor];
    [_idCardBGView addLineWithPosition:ViewDrawLinePostionType_Bottom
                                     lineColor:CellSeparatorColor
                                     lineWidth:LineWidth];
    
    _theContactDescLabel.textColor = blackColor;
    _theContactTF.textColor = grayColor;
    _theContactTF.text = nil;
    
    _idCardDescLabel.textColor = blackColor;
    _idCardTF.textColor = grayColor;
    _idCardTF.text = nil;
    
    _addBtn.backgroundColor = Common_ThemeColor;
    [_addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_addBtn setRadius:5];
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

- (IBAction)clickAddBtn:(UIButton *)sender
{
    if ([_theContactTF hasText])
    {
        if ([StringJudgeManager isValidateStr:_idCardTF.text regexStr:ID_CardNumRegex])
        {
            PassengersEntity *entity = [[PassengersEntity alloc] init];
            entity.nameStr = _theContactTF.text;
            entity.idCartStr = _idCardTF.text;
            
            OrderWriteVC *orderWrite = objc_getAssociatedObject(self, class_getName([OrderWriteVC class]));
            [orderWrite.passengersItemsArray addObject:entity];
            
            [self backViewController];
        }
        else
        {
            [self showHUDInfoByString:@"请填写乘客身份证号码"];
        }
    }
    else
    {
        [self showHUDInfoByString:@"请填写乘客姓名"];
    }
}

@end
