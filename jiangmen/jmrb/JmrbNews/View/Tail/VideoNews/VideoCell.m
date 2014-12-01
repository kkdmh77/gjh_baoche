//
//  VideoCell.m
//  JmrbNews
//
//  Created by dean on 12-11-13.
//
//

#import "VideoCell.h"
#import "CommonUtil.h"

@implementation VideoCell

@synthesize imageView,captionLabel,displayLable,replayLable;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        //self.contentView.opaque = NO;
        //self.opaque = NO;
        
        self.selectionStyle = AQGridViewCellSelectionStyleNone;
        
        
        UIImageView *bgview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 125)];
        [bgview setImage:[UIImage imageNamed:@"shipinbeijing.png"]];
        
        UIImageView *pingimageview=[[UIImageView alloc] initWithFrame:CGRectMake(10, 110, 13, 10)];
        [pingimageview setImage:[UIImage imageNamed:@"pinglun.png"]];
        replayLable = [[UILabel alloc] initWithFrame:CGRectMake(25, 109, 33, 10)];
        replayLable.text=@"0";
        replayLable.backgroundColor=[UIColor clearColor];
        replayLable.font = [UIFont systemFontOfSize:14];
        replayLable.textColor=[CommonUtil colorWithHexString:@"#b6b6b6"];
        //replayLable.backgroundColor=[UIColor clearColor];
        
        UIImageView *diangimageview=[[UIImageView alloc] initWithFrame:CGRectMake(60, 110, 13, 10)];
        [diangimageview setImage:[UIImage imageNamed:@"guankan.png"]];
        displayLable = [[UILabel alloc] initWithFrame:CGRectMake(75, 109, 33, 10)];
        displayLable.text=@"0";
        displayLable.backgroundColor=[UIColor clearColor];
        displayLable.font = [UIFont systemFontOfSize:14];
        displayLable.textColor=[CommonUtil colorWithHexString:@"#b6b6b6"];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 5, 147, 98)];
        [self.imageView setImage:[UIImage imageNamed:@"list_default.png"]];

        
        UIImageView *bofangimageview=[[UIImageView alloc] initWithFrame:CGRectMake(60, 40, 33, 25)];
        [bofangimageview setImage:[UIImage imageNamed:@"bofang.png"]];
        
        //标题
        self.captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, 150, 60)];
        //captionLabel.font = [UIFont boldSystemFontOfSize:12];
        captionLabel.numberOfLines = 2;
        //captionLabel.textAlignment=UITextAlignmentCenter;
        //captionLabel.text=@"手机充值";
        captionLabel.backgroundColor=[UIColor clearColor];
        captionLabel.font = [UIFont systemFontOfSize:14];
        //captionLabel.textColor = [UIColor whiteColor];
        //captionLabel.shadowColor = [UIColor blackColor];
       // captionLabel.shadowOffset = CGSizeMake(1.0,1.0);
        
        //添加边框
        // CALayer *layer = [imageView layer];
        //layer.borderColor = [[UIColor grayColor] CGColor];
        //layer.borderWidth = 2.0f;
        
        
        [self.contentView addSubview:bgview];
        [self.contentView addSubview:pingimageview];
        
        [self.contentView addSubview:replayLable];
        [self.contentView addSubview:diangimageview];
        [self.contentView addSubview:displayLable];
        [self.contentView addSubview:imageView];
        [self.contentView addSubview:captionLabel];
        [self.contentView addSubview:bofangimageview];
        
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
