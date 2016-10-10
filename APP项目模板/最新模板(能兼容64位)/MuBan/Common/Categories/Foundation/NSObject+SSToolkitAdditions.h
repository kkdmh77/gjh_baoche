//
//  NSObject+SSToolkitAdditions.h
//  o2o
//
//  Created by swift on 14-8-18.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SSToolkitAdditions)

- (BOOL)isSafeObject;

/* *
 *  If Object is not Kind of NSString, will always return NO;
 *  And this instance method will be override by NSString. In NSString
 *  this method will return YES when self not only contains whitespace
 *  and NSString's valid charactor count is not 0. Such as " " will return NO;
 */
/// Object.class != NSString => NO; String != "" & String != " " => YES
- (BOOL)isValidString;

/* *
 *  If Object is not Kind of NSNumber, will always return NO;
 *  And this instance method will be override by NSNumber. In NSNumber
 *  this method will return YES anytime;
 */
/// Object.class != NSNumber => NO; else => YES;
- (BOOL)isValidNumber;

/* *
 *  If Object is not Kind of NSArray, will always return NO;
 *  And this instance method will be override by NSArray. In NSArray
 *  this method will return YES when NSArray's element count is not 0;
 */
/// Object.class != NSArray => NO; Array.count != 0 => YES;
- (BOOL)isValidArray;

/* *
 *  If Object is not Kind of NSDictionary, will always return NO;
 *  And this instance method will be override by NSDictionary. In NSDictionary
 *  this method will return YES when NSDictionary's key-value count is not 0;
 */
/// Object.class != NSDictionary => NO; Dictionary.count != 0 => YES;
- (BOOL)isValidDictionary;

/* *
 *  If Object is not Kind of NSData, will always return NO;
 *  And this instance method will be override by NSData. In NSData
 *  this method will return YES when NSData's length is not 0;
 */
/// Object.class != NSData => NO; Data.length != 0 => YES;
- (BOOL)isValidData;

@end
