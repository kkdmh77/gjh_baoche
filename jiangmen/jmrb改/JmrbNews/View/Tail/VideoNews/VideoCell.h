//
//  VideoCell.h
//  JmrbNews
//
//  Created by dean on 12-11-13.
//
//

#import "AQGridViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface VideoCell : AQGridViewCell


@property(nonatomic, retain)UIImageView *imageView;
@property(nonatomic, retain)UILabel *captionLabel;
@property(nonatomic, retain)UILabel *displayLable;
@property(nonatomic, retain)UILabel *replayLable;
@end
