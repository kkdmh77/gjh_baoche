//
//  CommentView.h
//  JmrbNews
//
//  Created by swift on 14/12/21.
//
//

#import <UIKit/UIKit.h>

@class CommentView;

typedef NS_ENUM(NSInteger, CommentViewOperationType)
{
    CommentViewOperationType_Input = 0,
    
    CommentViewOperationType_RightBtn
};

typedef void (^CommentViewOperationHandle) (CommentView *view, CommentViewOperationType type);

@interface CommentView : UIView

@property (nonatomic, copy) CommentViewOperationHandle operationHandle;

- (void)setRightBtnTitle:(NSString *)title;

@end
