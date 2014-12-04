//
//  NewsVC.h
//  JmrbNews
//
//  Created by swift on 14/12/2.
//
//

#import "BaseNetworkViewController.h"
#import "CommonEntity.h"

@interface NewsVC : BaseNetworkViewController

@property (nonatomic, strong) NewsTypeEntity *newsTypeEntity;

- (void)viewDidCurrentView;

@end
