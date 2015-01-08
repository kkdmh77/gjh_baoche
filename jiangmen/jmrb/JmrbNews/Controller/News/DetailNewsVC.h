//
//  DetailNewsVC.h
//  JmrbNews
//
//  Created by swift on 14/12/5.
//
//

#import "BaseNetworkViewController.h"

@interface DetailNewsVC : BaseNetworkViewController

@property (nonatomic, assign) NSInteger newsId;
@property (nonatomic, copy) NSString *newsShareurlStr;

@end
