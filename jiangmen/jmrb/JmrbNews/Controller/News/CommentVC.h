//
//  CommentVC.h
//  JmrbNews
//
//  Created by swift on 14/12/21.
//
//

#import "BaseNetworkViewController.h"

@interface CommentVC : BaseNetworkViewController

@property (nonatomic, assign) NSInteger newsId;
@property (nonatomic, copy) NSString *newsTitleStr;
@property (nonatomic, copy) NSString *subTitleStr;

@end
