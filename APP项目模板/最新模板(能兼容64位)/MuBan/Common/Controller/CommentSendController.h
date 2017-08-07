//
//  CommentSendController.h
//  Sephome
//
//  Created by swift on 14/12/9.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPGrowingTextView.h"

typedef NS_ENUM(NSInteger, SendCommentActionType) {
    SendCommentActionTypeToSend = 0, ///< 点击发送
    SendCommentActionTypeCancel ///< 取消
};

typedef void(^SendCommentCompleteHandle) (SendCommentActionType actionType, NSString *inputText);

@interface CommentSendController : NSObject

AS_SINGLETON(CommentSendController);

@property (nonatomic, strong, readonly) HPGrowingTextView *inputTV;
/**
 @ 方法描述    显示评论输入界面
 @ 输入参数    SendCommentCompleteHandle: 回调block
 @ 返回值      void
 @ 创建人      龚俊慧
 @ 创建时间    2014-12-10
 */
- (void)showCommentInputViewWithCompleteHandle:(SendCommentCompleteHandle)handle;

@end
