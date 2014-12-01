//
//  MPDiscussCellV.h
//  ZhongShangPaper
//
//  Created by COMMINICATIONS GUANGXIN on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSDiscussCellV : UIView {
    UILabel *_lblAuther;
    UITextView *_contentTextView;
}
@property (nonatomic, assign) CGFloat height;

- (void)setText:(NSString *)auther Text:(NSString *)content;

@end
