//
//  JSPatchRequestManager.m
//  JSPatchDemo
//
//  Created by 龚 俊慧 on 16/9/8.
//  Copyright © 2016年 龚 俊慧. All rights reserved.
//

#import "JSPatchManager.h"
#import <JSPatch/JPEngine.h>
#import "OpenUDID.h"
#import "NetworkStatusManager.h"

static NSString * const kPatchFileName = @"patch.js"; // 执行的补丁文件名

static NSString * const kAppVersionKey = @"kAppVersionKey";
static NSString * const kJSPatchVersionKey = @"kJSPatchVersionKey";

@implementation JSPatchManager

+ (void)requestJSPatch:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
    // 网络连接及URL判断
    if (![NetworkStatusManager isConnectNetwork] || ![URLString isValidString]) {
        return;
    }
    
    /*
     接口地址：
     http://kkpatch.duowan.com/api/patch/getPatch.do?appId=aaa&platform=ppp&appVersion=vvv&patchVersion=0&time=123&md5=mmm&uuid=uuu
     参数：
     appId: string, 产品代号
     platform: string, ios|android
     appVersion: string,  产品版本
     patchVersion: int, 补丁版本，从1开始，没有打过补丁时为0
     time: long：当前时间
     md5: string：生成算法：md5(appId+platform+appVersion+patchVersion+time+key)，key="123456789#$(&*>kl";
     uuid: string：设备id（用户唯一id）
     返回json的data部分包括字段：patchUrl, patchText, patchVersion, appVersion
     有补丁：{"status":200,"message":"","data":{"patchUrl":"http://xyz","appVersion":"1.0.2","patchText":"base64Str","patchVersion":"2"}}
     无补丁：{"status":200,"message":"","data":null}
     */
    NSString *openUDID = [OpenUDID value];
    if (![openUDID isValidString]) {
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if (![dic isValidDictionary]) {
        NSArray *keys = @[@"appId",
                          @"platform",
                          @"appVersion",
                          @"patchVersion",
                          @"time"];
        NSArray *values = @[[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleName"],
                            @"ios",
                            [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
                            @([[[NSUserDefaults standardUserDefaults] objectForKey:kJSPatchVersionKey] integerValue]),
                            @((long)([NSDate date].timeIntervalSince1970 * 1000))];
        
        dic = [NSMutableDictionary dictionaryWithObjects:values forKeys:keys];
        NSString *token = [[NSString stringWithFormat:@"%@%@", [values componentsJoinedByString:@""], @"123456789#$(&*>kl"] md5String];
        [dic setObject:token forKey:@"md5"];
        [dic setObject:openUDID forKey:@"uuid"];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"application/json",
                                                         @"text/html",
                                                         @"text/plain",
                                                         @"text/json",
                                                         @"text/javascript", nil];
    
    [manager GET:URLString
      parameters:dic
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         // 解析数据
         if ([responseObject isValidDictionary] && 200 == [[responseObject objectForKey:@"status"] integerValue]) {
             if (success) {
                 success(task, responseObject);
             }
             
             NSDictionary *dataDic = [responseObject objectForKey:@"data"];
             if ([dataDic isValidDictionary]) {
                 NSString *patchVersion = [dataDic objectForKey:@"patchVersion"];
                 NSString *base64ScriptStr = [dataDic objectForKey:@"patchText"];
                 
                 // 执行并加密保存脚本及版本号
                 [[NSUserDefaults standardUserDefaults] setObject:patchVersion forKey:kJSPatchVersionKey];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 
                 NSString *JSPatchPath = [[self getPatchFileDBFolder] stringByAppendingPathComponent:kPatchFileName];
                 NSData *dicData = [NSJSONSerialization dataWithJSONObject:dataDic
                                                                   options:NSJSONWritingPrettyPrinted
                                                                     error:NULL];
                 [dicData writeToFile:JSPatchPath atomically:YES];
                 
                 // 执行
                 NSString *scriptStr = [NSString stringWithBase64EncodedString:base64ScriptStr];
                 [JPEngine evaluateScript:scriptStr];
             }
         } else {
             if (failure) {
                 NSError *error = [[NSError alloc] initWithDomain:@"JSPATCH_REQUEST_DOMAIN"
                                                             code:[[responseObject objectForKey:@"status"] integerValue]
                                                         userInfo:@{NSLocalizedDescriptionKey: [responseObject objectForKey:@"message"]}];
                 failure(task, error);
             }
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (failure) {
             failure(task, error);
         }
     }];
}

+ (void)setup
{
    // 拷贝工具js文件到沙盒
    NSString *JSResourceFolder = [[NSBundle mainBundle] bundlePath];
    NSArray *commonJsFileNamesArray = @[@"CommonDefine.js"];
    
    for (NSString *jsFileName in commonJsFileNamesArray) {
        NSString *defaultJsFilePath = [JSResourceFolder stringByAppendingPathComponent:jsFileName];
        NSString *dbJsFilePath = [[self getPatchFileDBFolder] stringByAppendingPathComponent:jsFileName];
        
        if (IsFileExists(dbJsFilePath)) {
            if (DeleteFiles(dbJsFilePath)) {
                [[NSFileManager defaultManager] copyItemAtPath:defaultJsFilePath
                                                        toPath:dbJsFilePath
                                                         error:NULL];
            }
        } else {
            [[NSFileManager defaultManager] copyItemAtPath:defaultJsFilePath
                                                    toPath:dbJsFilePath
                                                     error:NULL];
        }
    }
    
    // 当前的app版本
    NSString *nowAppVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    // 保存在本地的版本
    NSString *oldAppVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kAppVersionKey];
    NSString *oldJSPatchVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kJSPatchVersionKey];
    
    if (![nowAppVersion isEqualToString:oldAppVersion]) {
        oldJSPatchVersion = @"0";
        [[NSUserDefaults standardUserDefaults] setObject:nowAppVersion forKey:kAppVersionKey];
        [[NSUserDefaults standardUserDefaults] setObject:oldJSPatchVersion forKey:kJSPatchVersionKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)evaluateExistedPatch
{
    NSString *patchPath = [[self getPatchFileDBFolder] stringByAppendingPathComponent:kPatchFileName];
    if (IsFileExists(patchPath)) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:patchPath]
                                                                options:NSJSONReadingMutableContainers
                                                                  error:NULL];
       
        if ([dataDic isValidDictionary]) {
            NSString *appVersion = [dataDic objectForKey:@"appVersion"];
            NSString *patchVersion = [dataDic objectForKey:@"patchVersion"];
            NSString *base64ScriptStr = [dataDic objectForKey:@"patchText"];
            
            NSString *nowAppVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

            if ([nowAppVersion isEqualToString:appVersion] &&
                [patchVersion isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:kJSPatchVersionKey]] &&
                [base64ScriptStr isValidString]) {
                NSString *scriptStr = [NSString stringWithBase64EncodedString:base64ScriptStr];
                
                [JPEngine evaluateScript:scriptStr];
            }
        }
    }
    
    /**************************** 本地补丁调试代码(测试完请注释掉) ********************************/
    /*
    NSString *testPatchPath = GetApplicationPathFileName(@"Demo", @"js");
    NSString *testScriptStr = [NSString stringWithContentsOfFile:testPatchPath
                                                        encoding:NSUTF8StringEncoding
                                                           error:NULL];
    [JPEngine evaluateScript:testScriptStr];
    */
    /**************************** 本地补丁调试代码(测试完请注释掉) ********************************/
}

+ (NSString *)getPatchFileDBFolder
{
    if (GetDocumentPath()) {
        NSString *path = [GetDocumentPath() stringByAppendingPathComponent:@"JSPatch"];
        if (!IsFileExists(path)) {
            CreateFolder(path);
        }
        
        return path;
    }
    return nil;
}

@end
