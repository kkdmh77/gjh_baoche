//
//  UserCenter_TabHeaderView.h
//  BaoChe
//
//  Created by 龚 俊慧 on 14/12/20.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCenter_TabHeaderView : UIView

+ (CGFloat)getViewHeight;

@end

////////////////////////////////////////////////////////////////////////////////

@interface UserCenter_TabSectionHeaderView : UIButton

- (void)setTitleString:(NSString *)title;

@end

