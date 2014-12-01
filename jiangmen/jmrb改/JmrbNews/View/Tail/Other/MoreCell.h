//
//  MoreCell.h
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-10.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreCell : UITableViewCell {
    
}

@property (nonatomic, assign) IBOutlet UIImageView *cellImageView;
@property (nonatomic, assign) IBOutlet UILabel *cellLabel;
@property (nonatomic, assign) IBOutlet UIImageView *cellLineImageView;
@property (nonatomic, assign) IBOutlet UIImageView *cellArrowImageView;

- (void)showDisplay;

@end
