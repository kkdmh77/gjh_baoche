//
//  BaseTableViewCell.m
//  Biuu
//
//  Created by 龚 俊慧 on 2017/7/26.
//  Copyright © 2017年 com.gjh. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "UITableViewCell+BackgroundColor.h"

@implementation BaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configureCellBackgroundColors];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self configureCellBackgroundColors];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
