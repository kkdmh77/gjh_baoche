//
//  PositioningVC.m
//  MuBan
//
//  Created by 龚 俊慧 on 15/7/23.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "PositioningVC.h"
#import <MapKit/MapKit.h>
#import "Annotation.h"
#import "AppDelegate.h"
#import "BaseNetworkViewController+NetRequestManager.h"

@interface PositioningVC () <MKMapViewDelegate>
{
    MKMapView *_mapView;
}

@end

@implementation PositioningVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Left
                                 normalImg:[UIImage imageNamed:@"nav_menu"]
                            highlightedImg:nil
                                    action:NULL];
    
    [self initialization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:self.title];
}

- (void)setNetworkRequestStatusBlocks
{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (NetWaterPressureRequestType_GetMonitoringStationsList == request.tag)
        {
           
        }
    }];
}

- (void)getNetworkData
{
    [self sendRequest:nil
         parameterDic:nil
           requestTag:NetWaterPressureRequestType_GetMonitoringStationsList];
}

- (void)initialization
{
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    [_mapView keepAutoresizingInFull];
    
    [self.view addSubview:_mapView];
    
    // 添加annotation点
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:SharedAppDelegate.tabDataArray.count];
    for (DataEntity *entity in SharedAppDelegate.tabDataArray)
    {
//        29.705878, 121.397455
        entity.coordinate = CLLocationCoordinate2DMake(29.705878 + arc4random_uniform(100) / 5000.0, 121.397455 + arc4random_uniform(100) / 5000.0);
        Annotation *annotation = [[Annotation alloc] init];
        annotation.entity = entity;
        
        [annotations addObject:annotation];
    }
    
    [_mapView addAnnotations:annotations];
    
//    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(29.705878, 121.397455)];
    [_mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(29.715878, 121.407455), MKCoordinateSpanMake(0.05, 0.05)) animated:YES];
}

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView
{
    
}

- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView
{
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *identifier = @"pinAnnotationView";
    
    MKAnnotationView *pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (pinView == nil)
    {
        pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        
        pinView.image = [UIImage imageNamed:@"annotation"];
    }
//    pinView.pinColor = MKPinAnnotationColorRed;
//    pinView.animatesDrop = YES;
    pinView.canShowCallout = YES;
    pinView.annotation = annotation;
    
    return pinView;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    for (MKPinAnnotationView *view in views)
    {
        [view setSelected:YES animated:YES];
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
}

@end
