//
//  MoreCell.m
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-10.
//  Copyright (c) 2012年 XPG. All rights reserved.
//

#import "MoreCell.h"
#import "ImageContant.h"

@interface MoreCell ()

@end

@implementation MoreCell
@synthesize cellLabel, cellImageView, cellLineImageView, cellArrowImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}

- (void)showDisplay {
    UIImage *image = [UIImage imageByName:@"TarBar_list_background" withExtend:@"png"];
    [self.cellLineImageView setImage:image];
    image = [UIImage imageByName:@"TarBar_arrow_right" withExtend:@"png"];
    [self.cellArrowImageView setImage:image];
}

@end
