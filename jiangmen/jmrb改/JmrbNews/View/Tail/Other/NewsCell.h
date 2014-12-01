//
//  NewsCell.h
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-9.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell{
    
}

@property (nonatomic, assign) IBOutlet UIImageView *newsImageView;
@property (nonatomic, assign) IBOutlet UILabel *newsTitle;
@property (nonatomic, assign) IBOutlet UILabel *newsDetailTitle;
@property (nonatomic, assign) IBOutlet UIImageView *newstypeImageView;
@property (nonatomic, assign) IBOutlet UILabel *newsReplayView;

- (void)setCellImage:(UIImage *)in_image;

@end
