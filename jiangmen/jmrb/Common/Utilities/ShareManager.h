//
//  ShareManager.h
//  JmrbNews
//
//  Created by swift on 15/1/9.
//
//

#import <Foundation/Foundation.h>

@interface ShareManager : NSObject

AS_SINGLETON(ShareManager);

- (void)shareNewsWithContent:(NSString *)content
                      NewsId:(NSInteger)newsId
                 imageUrlStr:(NSString *)urlStr
                       title:(NSString *)title
              showCollectBtn:(BOOL)showCollect
                      sender:(id)sender;

@end
