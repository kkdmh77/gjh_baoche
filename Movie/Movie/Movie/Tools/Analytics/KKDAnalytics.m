//
//  KKDAnalytics.m
//  kkpoem
//
//  Created by KungJack on 20/4/15.
//  Copyright (c) 2015 KungJack. All rights reserved.
//

#import "KKDAnalytics.h"
#import "MobClick.h"

@interface KKDAnalytics ()

@end

@implementation KKDAnalytics

DEF_SINGLETON(KKDAnalytics);

-(id)init {

    self= [super init];
    if(self){
    }
    return self;
}

///---------------------------------------------------------------------------------------
/// @name  设置
///---------------------------------------------------------------------------------------

/** 设置app版本号。由于历史原因需要和xcode3工程兼容,友盟提取的是Build号(CFBundleVersion),如果需要和App Store上的版本一致,需要调用此方法。
 
 @param appVersion 版本号，例如设置成`XcodeAppVersion`.
 @return void.
 */
-(void)setAppVersion:(NSString *)appVersion{
    [ MobClick setAppVersion:appVersion];
}


/** 开启CrashReport收集, 默认是开启状态.
 
 @param value 设置成NO,就可以关闭友盟CrashReport收集.
 @return void.
 */
- (void)setCrashReportEnabled:(BOOL)value{
    [ MobClick setCrashReportEnabled:value];
}


/** 设置是否打印sdk的log信息,默认不开启
 @param value 设置为YES,umeng SDK 会输出log信息,记得release产品时要设置回NO.
 @return .
 @exception .
 */

- (void)setLogEnabled:(BOOL)value{
    [ MobClick setLogEnabled:value];
}


///---------------------------------------------------------------------------------------
/// @name  开启统计
///---------------------------------------------------------------------------------------


/** 开启友盟统计,默认以BATCH方式发送log.
 
 @param appKey 友盟appKey.
 @param reportPolicy 发送策略.
 @param channelId 渠道名称,为nil或@""时,默认会被被当作@"App Store"渠道
 @return void
 */
- (void)startWithAppkey{
    
    // NSString *channelStr = CHANNEL_STR;
    // [MobClick startWithAppkey:kUMengAppKey reportPolicy:BATCH channelId:channelStr];
    
    [MobClick startWithAppkey:kUMengAppKey];
    [[HiidoSDK sharedObject] appStartLaunchWithAppKey:kHiidoKey appId:@"" version:APP_VERSION from:@"AppStore" delegate:self];
    
}
//+ (void)startWithAppkey:(NSString *)appKey reportPolicy:(ReportPolicy)rp channelId:(NSString *)cid;

/** 当reportPolicy == SEND_INTERVAL 时设定log发送间隔
 
 @param second 单位为秒,最小为10,最大为86400(一天).
 @return void.
 */

- (void)setLogSendInterval:(double)second{
    [ MobClick setLogSendInterval:second];
}

- (void)logPageView:(NSString *)pageName seconds:(int)seconds{
    [ MobClick logPageView:pageName seconds:seconds];
    
}

- (void)beginLogPageView:(NSString *)pageName{
    [ MobClick beginLogPageView:pageName];
    [[HiidoSDK sharedObject] enterPage:0 pageId:pageName];
}

- (void)endLogPageView:(NSString *)pageName{
    [ MobClick endLogPageView:pageName];
    [[HiidoSDK sharedObject] leavePageId:pageName destPageId:nil pageParm:nil needReport:YES];
}

#pragma mark event logs


///---------------------------------------------------------------------------------------
/// @name  事件统计
///---------------------------------------------------------------------------------------


/** 自定义事件,数量统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID
 
 @param  eventId 网站上注册的事件Id.
 @param  label 分类标签。不同的标签会分别进行统计，方便同一事件的不同标签的对比,为nil或空字符串时后台会生成和eventId同名的标签.
 @param  accumulation 累加值。为减少网络交互，可以自行对某一事件ID的某一分类标签进行累加，再传入次数作为参数。
 @return void.
 */
- (void)event:(NSString *)eventId{
    [ MobClick event:eventId];
    [[HiidoSDK sharedObject] reportTimesEvent:0 eventId:eventId timesParm:nil];
}//等同于 event:eventId label:eventId
/** 自定义事件,数量统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID
 */
- (void)event:(NSString *)eventId label:(NSString *)label{
    [ MobClick event:eventId label:label];
    [[HiidoSDK sharedObject] reportTimesEvent:0 eventId:eventId timesParm:nil];
}// label为nil或@""时，等同于 event:eventId label:eventId{
/** 自定义事件,数量统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID
 */
- (void)event:(NSString *)eventId acc:(NSInteger)accumulation{
    [ MobClick event:eventId acc:accumulation];
}
/** 自定义事件,数量统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID
 */
- (void)event:(NSString *)eventId label:(NSString *)label acc:(NSInteger)accumulation{
    [ MobClick event:eventId label:label acc:accumulation];
}
/** 自定义事件,数量统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID
 */
- (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes{
    [ MobClick event:eventId attributes:attributes];
}

- (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes counter:(int)number{
    [ MobClick event:eventId attributes:attributes counter:number];
}

/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 beginEvent,endEvent要配对使用,也可以自己计时后通过durations参数传递进来
 
 @param  eventId 网站上注册的事件Id.
 @param  label 分类标签。不同的标签会分别进行统计，方便同一事件的不同标签的对比,为nil或空字符串时后台会生成和eventId同名的标签.
 @param  primarykey 这个参数用于和event_id一起标示一个唯一事件，并不会被统计；对于同一个事件在beginEvent和endEvent 中要传递相同的eventId 和 primarykey
 @param millisecond 自己计时需要的话需要传毫秒进来
 @return void.
 
 
 @warning 每个event的attributes不能超过10个
 eventId、attributes中key和value都不能使用空格和特殊字符，且长度不能超过255个字符（否则将截取前255个字符）
 id， ts， du是保留字段，不能作为eventId及key的名称
 
 */
- (void)beginEvent:(NSString *)eventId{
    [ MobClick beginEvent:eventId];
}
/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */
- (void)endEvent:(NSString *)eventId{
    [ MobClick endEvent:eventId];
}
/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */

- (void)beginEvent:(NSString *)eventId label:(NSString *)label{
    [ MobClick beginEvent:eventId label:label];
}
/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */

- (void)endEvent:(NSString *)eventId label:(NSString *)label{
    [ MobClick endEvent:eventId label:label];
}
/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */

- (void)beginEvent:(NSString *)eventId primarykey :(NSString *)keyName attributes:(NSDictionary *)attributes{
    [ MobClick beginEvent:eventId primarykey:keyName attributes:attributes];
}
/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */

- (void)endEvent:(NSString *)eventId primarykey:(NSString *)keyName{
    [ MobClick endEvent:eventId primarykey:keyName];
}
/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */

- (void)event:(NSString *)eventId durations:(int)millisecond{
    [ MobClick event:eventId durations:millisecond];
}
/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */

- (void)event:(NSString *)eventId label:(NSString *)label durations:(int)millisecond{
    [ MobClick event:eventId label:label durations:millisecond];
}
/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */

- (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes durations:(int)millisecond{
    [ MobClick event:eventId attributes:attributes durations:millisecond];
}

///---------------------------------------------------------------------------------------
/// @name helper方法
///---------------------------------------------------------------------------------------


/** 判断设备是否越狱，判断方法根据 apt和Cydia.app的path来判断
 */
- (BOOL)isJailbroken{
    return [ MobClick isJailbroken];
}
/** 判断你的App是否被破解
 */
- (BOOL)isPirated{
    return [ MobClick isPirated];
}

#pragma mark DEPRECATED methods from version 1.7

/** 友盟模块启动
 [[KKDAnalytics sharedObject]startWithAppkey:]通常在application:didFinishLaunchingWithOptions:里被调用监听
 App启动和退出事件，如果你没法在application:didFinishLaunchingWithOptions:里添加友盟的[[KKDAnalytics sharedObject]startWithAppkey:]
 方法，App的启动事件可能会无法监听，此时你就可以手动调用[[KKDAnalytics sharedObject]startSession:nil]来启动友盟的session。
 通常发生在某些第三方框架生成的app里，普通app使用不到.
 
 */

- (void)startSession:(NSNotification *)notification{
    [ MobClick startSession:notification];
}

-(uint64_t)getCurrentUid{

    return 0;
}

@end
