#import "ZjPlayletPlugin.h"
#import "ZJPlayletTool.h"
#import <ZJSDK/ZJSDK.h>
#import "ZJPlayletWrapper.h"
#import "ZJPlayletConfig.h"

@interface ZjPlayletPlugin ()

@property (nonatomic, strong) FlutterResult callback;

@property (nonatomic, strong) ZJPlayletWrapper *playletAd;

@end

@implementation ZjPlayletPlugin

static ZjPlayletPlugin *zjPlayletFlutterPlugin = nil;

+ (ZjPlayletPlugin *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        zjPlayletFlutterPlugin = [[self alloc] init];
    });
    return zjPlayletFlutterPlugin;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    
    [ZjPlayletPlugin shareInstance].messenger = registrar.messenger;
    NSString *channelId = @"8080";
    NSString *channel = [NSString stringWithFormat:@"com.zjplaylet.adsdk/event_%@", channelId];
    FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:channel binaryMessenger:[ZjPlayletPlugin shareInstance].messenger];
    //设置FlutterStreamHandler协议代理
    [eventChannel setStreamHandler:[ZjPlayletPlugin shareInstance]];

}

- (void)setMessenger:(NSObject<FlutterBinaryMessenger> *)messenger{
    _messenger = messenger;
    ///建立通信通道 用来 监听Flutter 的调用和 调用Fluttter 方法 这里的名称要和Flutter 端保持一致
    _methodChannel = [FlutterMethodChannel methodChannelWithName:@"com.zjplaylet.adsdk/method" binaryMessenger:messenger];
    __weak __typeof__(self) weakSelf = self;
    [_methodChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        [weakSelf handleMethodCall:call result:result];
    }];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  NSLog(@"====>>>> flutter 调用了 %@方法", call.method);
  if ([@"getSDKVersion" isEqualToString:call.method]) {
      [self getSDKVersion:call];
  } else if ([@"registerAppId" isEqualToString:call.method]) {
    [self registerAppId:call];
  } else if ([@"loadPlayletAd" isEqualToString:call.method]) {
      [self loadPlayletAd:call];
  } else if ([@"showPlayletAd" isEqualToString:call.method]) {
      [self showPlayletAd:call];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)registerAppId:(FlutterMethodCall *)call {
    __weak __typeof(self) weakSelf = self;
    NSDictionary  *dic = call.arguments;
    NSString *appId = [dic objectForKey:@"appId"];
    [ZJAdSDK registerAppId:appId callback:^(BOOL completed, NSDictionary * _Nonnull info) {
        [weakSelf callbackWithEvent:completed?@"success":@"fail" otherDic:@{@"info":info} error:nil];
    }];
}

- (void)getSDKVersion:(FlutterMethodCall *)call
{
    [self callbackWithEvent:@"SDKVersion" otherDic:@{@"SDKVersion": [ZJAdSDK SDKVersion]} error:nil];
}

- (void)loadPlayletAd:(FlutterMethodCall*)call
{
    NSDictionary *dic = call.arguments;
    NSString *adId = [dic objectForKey:@"adId"];
    if ([ZJPlayletTool isEmptyString:adId]) {
        NSLog(@"广告位不能为空!");
        return;
    }
    NSString *JSONConfigPath = [dic objectForKey:@"JSONConfigPath"];
    if ([ZJPlayletTool isEmptyString:JSONConfigPath]) {
        NSLog(@"请设置JSONConfig文件的路径!");
        return;
    }
    self.playletAd = [[ZJPlayletWrapper alloc] init];
    ZJPlayletConfig *config = [ZJPlayletConfig fromMap:dic];
    __weak __typeof__(self) weakSelf = self;
    // 短剧加载成功
    [self.playletAd setPlayletLoadSuccessBlock:^{
        [weakSelf callbackWithEvent:@"PlayletLoadSuccess" otherDic:@{} error:nil];
    }];
    // 短剧加载失败
    [self.playletAd setPlayletLoadFailureBlock:^{
        [weakSelf callbackWithEvent:@"PlayletLoadFailure" otherDic:@{} error:nil];
    }];
//    // 视频开始播放
//    [self.playletAd setVideoDidStartPlayBlock:^{
//        [weakSelf callbackWithEvent:@"VideoDidStartPlay" otherDic:@{} error:nil];
//    }];
//    // 视频暂停播放
//    [self.playletAd setVideoDidPauseBlock:^{
//        [weakSelf callbackWithEvent:@"VideoDidPause" otherDic:@{} error:nil];
//    }];
//    // 视频恢复播放
//    [self.playletAd setVideoDidResumeBlock:^{
//        [weakSelf callbackWithEvent:@"VideoDidResume" otherDic:@{} error:nil];
//    }];
//    // 视频停止播放
//    [self.playletAd setVideoDidEndPlayBlock:^{
//        [weakSelf callbackWithEvent:@"VideoDidEndPlay" otherDic:@{} error:nil];
//    }];
    
    // 解锁流程开始
    [self.playletAd setShortplayPlayletDetailUnlockFlowStartBlock:^{
        [weakSelf callbackWithEvent:@"ShortplayPlayletDetailUnlockFlowStart" otherDic:@{} error:nil];
    }];
    // 解锁流程取消
    [self.playletAd setShortplayPlayletDetailUnlockFlowCancelBlock:^{
        [weakSelf callbackWithEvent:@"ShortplayPlayletDetailUnlockFlowCancel" otherDic:@{} error:nil];
    }];
    // 解锁流程结束，回调解锁结果, success: 是否解锁成功
    [self.playletAd setShortplayPlayletDetailUnlockFlowEndBlock:^(BOOL success) {
        [weakSelf callbackWithEvent:@"ShortplayPlayletDetailUnlockFlowEnd" otherDic:@{@"info": success ? @"success" : @"failure" } error:nil];
    }];
    // 点击混排中进入跳转播放页的按钮
    [self.playletAd setShortplayClickAdViewEventBlock:^{
        [weakSelf callbackWithEvent:@"ShortplayClickAdView" otherDic:@{} error:nil];
    }];
    // 本剧集观看完毕，切到下一部短剧回调
    [self.playletAd setShortplayNextPlayletWillPlayBlock:^{
        [weakSelf callbackWithEvent:@"ShortplayNextPlayletWillPlay" otherDic:@{} error:nil];
    }];
    // 发起广告请求
    [self.playletAd setShortplaySendAdRequestBlock:^{
        [weakSelf callbackWithEvent:@"ShortplaySendAdRequest" otherDic:@{} error:nil];
    }];
    // 广告加载成功
    [self.playletAd setShortplayAdLoadSuccessBlock:^{
        [weakSelf callbackWithEvent:@"ShortplayAdLoadSuccess" otherDic:@{} error:nil];
    }];
    // 广告加载失败
    [self.playletAd setShortplayAdLoadFailBlock:^(NSError * _Nonnull error) {
        [weakSelf callbackWithEvent:@"ShortplayAdLoadFail" otherDic:@{} error:nil];
    }];
    // 广告填充失败
    [self.playletAd setShortplayAdFillFailBlock:^{
        [weakSelf callbackWithEvent:@"ShortplayAdFillFail" otherDic:@{} error:nil];
    }];
    // 广告曝光
    [self.playletAd setShortplayAdWillShowBlock:^{
        [weakSelf callbackWithEvent:@"ShortplayAdWillShow" otherDic:@{} error:nil];
    }];
    // 点击广告
    [self.playletAd setShortplayClickAdViewEventBlock:^{
        [weakSelf callbackWithEvent:@"ShortplayClickAdView" otherDic:@{} error:nil];
    }];
    // 激励视频广告结束
    [self.playletAd setShortplayVideoRewardFinishEventBlock:^{
        [weakSelf callbackWithEvent:@"ShortplayVideoRewardFinish" otherDic:@{} error:nil];
    }];
    // 激励视频广告跳过
    [self.playletAd setShortplayVideoRewardSkipEventBlock:^{
        [weakSelf callbackWithEvent:@"ShortplayVideoRewardSkip" otherDic:@{} error:nil];
    }];
    
    [self.playletAd loadAd:config];
}

- (void)showPlayletAd:(FlutterMethodCall*)call
{
    [self.playletAd showAd];
}

/**回调事件*/
- (void)callbackWithEvent:(NSString *)event otherDic:(NSDictionary *)otherDic error:(NSError *)error {
    if (self.callback) {
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [result setObject:event.length > 0 ?event :@"未知事件" forKey:@"event"];
        if (error) {
            [result setObject:[error convertJSONString] forKey:@"error"];
        } else {
            [result setObject:@"" forKey:@"error"];
        }
        if (otherDic) {
            [result addEntriesFromDictionary:otherDic];
        }
        self.callback(result);
    }
}

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments { 
    self.callback = nil;
    return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    if (events) {
        self.callback = events;
    }
    return nil;
}

@end
