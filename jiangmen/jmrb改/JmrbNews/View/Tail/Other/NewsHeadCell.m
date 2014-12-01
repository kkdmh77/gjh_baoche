//
//  NewsHeadCell.m
//  JmrbNews
//
//  Created by dean on 13-5-21.
//
//

#import "NewsHeadCell.h"

@implementation NewsHeadCell
@synthesize cellLabel, cellImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
