//
//  UserInfoModel.h
//  zmt
//
//  Created by gongjunhui on 13-8-12.
//  Copyright (c) 2013年 com.ygsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"

@interface UserInfoModel : Jastor

AS_SINGLETON(UserInfoModel);

/// 保存用户信息到磁盘
- (void)saveGlobalUserInfoModel;

//////////////////////////////////////////////////////////////////////////////////////////

+ (void)setObject:(id)value forKey:(NSString *)key;
+ (id)objectForKey:(NSString *)key;

@property (nonatomic, strong) NSMutableDictionary *parameterDic;

@property (nonatomic, copy  ) NSString *email;
@property (nonatomic, copy  ) NSString *session;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, copy  ) NSString *loginName;
@property (nonatomic, copy  ) NSString *userName;
@property (nonatomic, copy  ) NSString *password;
@property (nonatomic, strong) NSNumber *userHeaderImgId;
@property (nonatomic, strong) NSData   *userHeaderImgData;
@property (nonatomic, copy  ) NSString *idCard;
@property (nonatomic, copy  ) NSString *deviceToken;
@property (nonatomic, assign) CGFloat  brightness_Device;
@property (nonatomic, assign) CGFloat  brightness_App;

/****************************************用户向导相关**************************************/

@property (nonatomic, assign) BOOL isLoadedThemeChoosePage; // 是否已经点击过换肤按钮
@property (nonatomic, assign) BOOL hasShowUerGuide_StudyPlanLearn; // 是否已经显示学习计划学习页的指引

@end
