//
//  PSV2Cell.h
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSV2Cell : UIViewController

@property (nonatomic, assign) IBOutlet UIImageView *imageView;
@property (nonatomic, assign) IBOutlet UILabel *lblTitle;

- (void)setImage:(UIImage *)in_image;

@end
