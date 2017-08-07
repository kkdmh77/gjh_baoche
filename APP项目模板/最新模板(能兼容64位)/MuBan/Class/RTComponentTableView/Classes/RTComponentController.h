//
//  RTComponentTableView.h
//  Pods
//
//  Created by ricky on 16/6/18.
//
//

#import <UIKit/UIKit.h>
#import "RTTableComponent.h"
#import "BaseNetworkViewController.h"

@interface RTComponentController : BaseNetworkViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray <id<RTTableComponent> > *components;

- (CGRect)tableViewRectForBounds:(CGRect)bounds;

@end
