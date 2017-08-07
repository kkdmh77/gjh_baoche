//
//  NSMutableArray+SafeAction.h
//  kkyingyu100k
//
//  Created by 龚 俊慧 on 16/9/12.
//  Copyright © 2016年 com.gjh. All rights reserved.
//

#import <Foundation/Foundation.h>

/**************************** 此类需要加-fno-objc-arc不然会造成键盘释放崩溃 ********************************/

@interface NSMutableArray (SafeAction)

@end

////////////////////////////////////////////////////////////////////////////////

@interface NSArray (SafeAction)

@end

////////////////////////////////////////////////////////////////////////////////

@interface NSMutableDictionary (SafeAction)

@end

/**************************** 此类需要加-fno-objc-arc不然会造成键盘释放崩溃 ********************************/
