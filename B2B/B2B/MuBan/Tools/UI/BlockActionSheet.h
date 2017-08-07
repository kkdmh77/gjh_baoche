//
//  BlockActionSheet.h
//  kkunion
//
//  Created by 龚 俊慧 on 2016/11/24.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlockActionSheet : UIActionSheet

/**
 * @method block形式的ActionSheet
 * @param  otherButtonTitles：最多支持5个
 * @return void
 * @创建人  龚俊慧
 * @creat  2016-11-24
 */
+ (void)showWithTitle:(nullable NSString *)title
          cancelTitle:(nullable NSString *)cancelTitle
          cancelBlock:(nullable void (^) (BlockActionSheet * _Nonnull actionSheet))cancelBlock
           otherBlock:(nullable void (^) (BlockActionSheet * _Nonnull actionSheet, NSInteger buttonIndex))otherBlock
     destructiveTitle:(nullable NSString *)destructiveTitle
    otherButtonTitles:(nullable NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end
