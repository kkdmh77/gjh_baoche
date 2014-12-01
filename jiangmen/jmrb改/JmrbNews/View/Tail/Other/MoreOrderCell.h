//
//  MoreOrderCell.h
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreOrderCell : UITableViewCell

@property (nonatomic, assign) IBOutlet UIImageView *cellImageView;
@property (nonatomic, assign) IBOutlet UILabel *cellLabel;
@property (nonatomic, assign) IBOutlet UIButton *btnUp;
@property (nonatomic, assign) NSInteger newsId;

@end
