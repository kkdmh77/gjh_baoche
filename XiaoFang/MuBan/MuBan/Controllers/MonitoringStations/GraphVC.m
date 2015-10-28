//
//  GraphVC.m
//  MuBan
//
//  Created by 龚 俊慧 on 15/7/24.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "GraphVC.h"
#import "NIAttributedLabel.h"
#import "BaseNetworkViewController+NetRequestManager.h"
#import "PNLineChartView.h"
#import "PNPlot.h"

@interface GraphVC ()
{
    NSArray *_netEntityArray;
}

@property (weak, nonatomic) IBOutlet NIAttributedLabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *graphImageView;

@property (weak, nonatomic) IBOutlet PNLineChartView *lineChartView;

@end

@implementation GraphVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self getNetworkData];
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:@"水压变化曲线图"];
}

- (void)setNetworkRequestStatusBlocks
{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (NetWaterPressureRequestType_GetCurveValueDataList == request.tag)
        {
            strongSelf->_netEntityArray = [weakSelf parseNetwordDataWithInfoObj:successInfoObj];
            
            [weakSelf loadCurveView];
        }
    } failedBlock:^(NetRequest *request, NSError *error) {
        
    }];
}

- (void)getNetworkData
{
    [self sendRequest:nil
         parameterDic:@{@"userId": [UserInfoModel getUserDefaultUserId],
                        @"trancode": @"BC0011",
                        @"sid": _entity.number,
                        @"page": @(1),
                        @"pageSize": @(15)}
    requestMethodType:RequestMethodType_POST
           requestTag:NetWaterPressureRequestType_GetCurveValueDataList];
}

- (NSArray *)parseNetwordDataWithInfoObj:(NSDictionary *)obj
{
    NSArray *dataArray = [obj safeObjectForKey:@"list"];
    
    return dataArray;
}

- (void)loadCurveView
{
    NSMutableArray *xValues = [NSMutableArray array];
    NSMutableArray *yValues = [NSMutableArray array];
    for (NSDictionary *dic in _netEntityArray) {
        [xValues addObject:@""];
        [yValues addObject:@([[dic safeObjectForKey:@"presure"] floatValue])];
    }
    
    // PNLineChartView *lineChartView = [[PNLineChartView alloc] initWithFrame:CGRectMake(0, 45.0, IPHONE_WIDTH, self.viewBoundsHeight - 45 - 40)];
    _lineChartView.backgroundColor = [UIColor whiteColor];
    // test line chart
    NSArray* plottingDataValues1 =@[@.27, @.28, @.3, @.1,@.5, @.4,@.0, @.8, @.0,@.9, @.1];
    //    NSArray* plottingDataValues2 =@[@24, @23, @22, @20,@53, @22,@33, @33, @54,@58, @43];
    
    _lineChartView.max = 1.5;
    _lineChartView.min = 0;
    // _lineChartView.pointerInterval = 10;
    
    _lineChartView.interval = (_lineChartView.max - _lineChartView.min) / 5;
    _lineChartView.horizontalLineWidth = 0;
    
    NSMutableArray* yAxisValues = [@[] mutableCopy];
    for (int i=0; i<11; i++) {
        NSString* str = [NSString stringWithFormat:@"%.2f", _lineChartView.min + _lineChartView.interval*i];
        [yAxisValues addObject:str];
    }
    
    _lineChartView.xAxisValues = xValues;
    _lineChartView.yAxisValues = yAxisValues;
    _lineChartView.axisLeftLineWidth = 39;
    
    PNPlot *plot = [[PNPlot alloc] init];
    plot.plottingValues = yValues;
    plot.lineColor = [UIColor blackColor];
    plot.lineWidth = 0.5;
    
    [_lineChartView addPlot:plot];
}

- (void)configureViewsProperties
{
   [_graphImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.width.equalTo(IPHONE_WIDTH * 1.0625);
   }];
    
    if (_entity)
    {
        NSString *numberStr = [NSString stringWithFormat:@"%@", _entity.position];
        
        _titleLabel.text = [NSString stringWithFormat:@"监测点%@水压曲线图", numberStr];
        [_titleLabel setTextColor:Common_LiteBlueColor range:[_titleLabel.text rangeOfString:numberStr]];
        [_titleLabel setVerticalTextAlignment:NIVerticalTextAlignmentMiddle];
        
        _graphImageView.image = [UIImage imageNamed:@"quxian"];
    }
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

@end
