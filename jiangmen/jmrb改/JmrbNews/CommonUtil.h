//
//  CommonUtil.h
//  WebpayMobile
//
//  Created by dean on 12-10-21.
//  Copyright (c) 2012年 webpay. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CommonUtil : NSObject

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;
+ (UIImage *)getImage:(NSString *)videoURL;
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
+ (NSString *)intervalSinceNow: (NSString *) theDate;
//+ (NSTimeInterval *)intervalDate: (NSDate *) theDate;
@end
