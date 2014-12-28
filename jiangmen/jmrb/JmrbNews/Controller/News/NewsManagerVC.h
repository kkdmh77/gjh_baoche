//
//  NewsManagerVC.h
//  JmrbNews
//
//  Created by swift on 14/12/2.
//
//

#import "BaseNetworkViewController.h"
#import "SUNSlideSwitchView.h"

@interface NewsManagerVC : BaseNetworkViewController

@property (nonatomic, strong) SUNSlideSwitchView *slideSwitchView;

- (void)configureSlideSwitchView;

@end
