#import "ZjPlayletPlugin.h"
#import "ZJPlayletTool.h"
#import <ZJSDK/ZJSDK.h>
#import "ZJPlayletWrapper.h"
#import "ZJPlayletConfig.h"
#import "ZJPlayletAdPlatformView.h"

@interface ZjPlayletPlugin ()

@property (nonatomic, strong) ZJPlayletWrapper *playletAd;

@end

@implementation ZjPlayletPlugin

static FlutterMethodChannel *_methodChannel = nil;
static ZjPlayletPlugin *zjPlayletFlutterPlugin = nil;
static FlutterBasicMessageChannel *_messageChannel = nil;

+ (ZjPlayletPlugin *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        zjPlayletFlutterPlugin = [[self alloc] init];
    });
    return zjPlayletFlutterPlugin;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    ZJPlayletAdPlatformViewFactory *playletAdPlatformViewFactory = [[ZJPlayletAdPlatformViewFactory alloc] initWithRegistrar:registrar];
    [registrar registerViewFactory:playletAdPlatformViewFactory withId:@"com.zjplaylet.adsdk/playletAd"];
    
    _methodChannel = [FlutterMethodChannel methodChannelWithName:@"com.zjplaylet.adsdk/method" binaryMessenger:[registrar messenger]];
    [registrar addMethodCallDelegate:[ZjPlayletPlugin shareInstance] channel:_methodChannel];
    [ZjPlayletPlugin shareInstance].messenger = registrar.messenger;
    _messageChannel = [FlutterBasicMessageChannel messageChannelWithName:@"com.zjplaylet.adsdk/sdk_message" binaryMessenger:[registrar messenger] codec:FlutterJSONMessageCodec.sharedInstance];
    
}

- (void)setMessenger:(NSObject<FlutterBinaryMessenger> *)messenger{
    _messenger = messenger;
    __weak __typeof__(self) weakSelf = self;
    [_methodChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf handleMethodCall:call result:result];
    }];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"registerPlayletMethodChannel" isEqualToString:call.method]) {
        [self registerPlayletMethodChannel:call];
    } else if ([@"getSDKVersion" isEqualToString:call.method]) {
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

- (void)registerPlayletMethodChannel:(FlutterMethodCall *)call
{
    [self callbackWithFunctionName:@"registerPlayletMethodChannel"
                         eventName:@"registerPlayletMethodChannel" otherDic:@{@"info": @"success"} error:nil];
}

- (void)registerAppId:(FlutterMethodCall *)call {
    __weak __typeof(self) weakSelf = self;
    NSDictionary *dic = call.arguments;
    NSString *appId = [dic objectForKey:@"appId"];
    [ZJAdSDK registerAppId:appId callback:^(BOOL completed, NSDictionary *info) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf callbackWithFunctionName:@"registerAppId" eventName:@"registerAppId" otherDic:@{@"info": info?info:@{}} error:nil];
    }];
}

- (void)getSDKVersion:(FlutterMethodCall *)call
{
    [self callbackWithFunctionName:@"getSDKVersion" eventName:@"SDKVersion" otherDic:@{@"SDKVersion": [ZJAdSDK SDKVersion]} error:nil];
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
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf callbackWithFunctionName:@"loadPlayletAd" eventName:@"PlayletLoadSuccess" otherDic:@{} error:nil];
    }];
    // 短剧加载失败
    [self.playletAd setPlayletLoadFailureBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf callbackWithFunctionName:@"loadPlayletAd" eventName:@"PlayletLoadFailure" otherDic:@{} error:nil];
    }];
    // 视频开始播放
    [self.playletAd setVideoDidStartPlayBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf callbackWithFunctionName:@"loadPlayletAd" eventName:@"VideoDidStartPlay" otherDic:@{} error:nil];
    }];
    // 视频暂停播放
    [self.playletAd setVideoDidPauseBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf callbackWithFunctionName:@"loadPlayletAd" eventName:@"VideoDidPause" otherDic:@{} error:nil];
    }];
    // 视频恢复播放
    [self.playletAd setVideoDidResumeBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf callbackWithFunctionName:@"loadPlayletAd" eventName:@"VideoDidResume" otherDic:@{} error:nil];
    }];
    // 视频停止播放
    [self.playletAd setVideoDidEndPlayBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf callbackWithFunctionName:@"loadPlayletAd" eventName:@"VideoDidEndPlay" otherDic:@{} error:nil];
    }];
    
    // 解锁流程开始
    [self.playletAd setShortplayPlayletDetailUnlockFlowStartBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf callbackWithFunctionName:@"loadPlayletAd" eventName:@"ShortplayPlayletDetailUnlockFlowStart" otherDic:@{} error:nil];
    }];
    // 解锁流程取消
    [self.playletAd setShortplayPlayletDetailUnlockFlowCancelBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf callbackWithFunctionName:@"loadPlayletAd" eventName:@"ShortplayPlayletDetailUnlockFlowCancel" otherDic:@{} error:nil];
    }];
    // 解锁流程结束，回调解锁结果, success: 是否解锁成功
    [self.playletAd setShortplayPlayletDetailUnlockFlowEndBlock:^(BOOL success) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf callbackWithFunctionName:@"loadPlayletAd" eventName:@"ShortplayPlayletDetailUnlockFlowEnd" otherDic:@{@"info": success ? @"success" : @"failure" } error:nil];
    }];
    // 点击混排中进入跳转播放页的按钮
    [self.playletAd setShortplayClickEnterViewBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf callbackWithFunctionName:@"loadPlayletAd" eventName:@"ShortplayClickEnterView" otherDic:@{} error:nil];
    }];
    // 本剧集观看完毕，切到下一部短剧回调
    [self.playletAd setShortplayNextPlayletWillPlayBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf callbackWithFunctionName:@"loadPlayletAd" eventName:@"ShortplayNextPlayletWillPlay" otherDic:@{} error:nil];
    }];
    // 发起广告请求
    [self.playletAd setShortplaySendAdRequestBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf callbackWithFunctionName:@"loadPlayletAd" eventName:@"ShortplaySendAdRequest" otherDic:@{} error:nil];
    }];
    // 广告加载成功
    [self.playletAd setShortplayAdLoadSuccessBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf callbackWithFunctionName:@"loadPlayletAd" eventName:@"ShortplayAdLoadSuccess" otherDic:@{} error:nil];
    }];
    // 广告加载失败
    [self.playletAd setShortplayAdLoadFailBlock:^(NSError * _Nonnull error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf callbackWithFunctionName:@"loadPlayletAd" eventName:@"ShortplayAdLoadFail" otherDic:@{} error:error];
    }];
    // 广告填充失败
    [self.playletAd setShortplayAdFillFailBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf callbackWithFunctionName:@"loadPlayletAd" eventName:@"ShortplayAdFillFail" otherDic:@{} error:nil];
    }];
    // 广告曝光
    [self.playletAd setShortplayAdWillShowBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf callbackWithFunctionName:@"loadPlayletAd" eventName:@"ShortplayAdWillShow" otherDic:@{} error:nil];
    }];
    // 点击广告
    [self.playletAd setShortplayClickAdViewEventBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf callbackWithFunctionName:@"loadPlayletAd" eventName:@"ShortplayClickAdView" otherDic:@{} error:nil];
    }];
    // 激励视频广告结束
    [self.playletAd setShortplayVideoRewardFinishEventBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf callbackWithFunctionName:@"loadPlayletAd" eventName:@"ShortplayVideoRewardFinish" otherDic:@{} error:nil];
    }];
    // 激励视频广告跳过
    [self.playletAd setShortplayVideoRewardSkipEventBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf callbackWithFunctionName:@"loadPlayletAd" eventName:@"ShortplayVideoRewardSkip" otherDic:@{} error:nil];
    }];
    // 视频切换时的回调
    [self.playletAd setShortplayDrawVideoCurrentVideoChangedBlock:^(NSInteger index) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf callbackWithFunctionName:@"loadPlayletAd" eventName:@"ShortplayDrawVideoCurrentVideoChanged" otherDic:@{@"info":[NSString stringWithFormat:@"%ld", index]} error:nil];
    }];
    // 加载失败按钮点击重试回调
    [self.playletAd setShortplayDrawVideoDidClickedErrorButtonRetryBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf callbackWithFunctionName:@"loadPlayletAd" eventName:@"ShortplayDrawVideoDidClickedErrorButtonRetry" otherDic:@{} error:nil];
    }];
    // 默认关闭按钮被点击的回调
    [self.playletAd setShortplayDrawVideoCloseButtonClickedBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf callbackWithFunctionName:@"loadPlayletAd" eventName:@"ShortplayDrawVideoCloseButtonClicked" otherDic:@{} error:nil];
    }];
    // 数据刷新完成回调
    [self.playletAd setShortplayDrawVideoDataRefreshCompletionBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf callbackWithFunctionName:@"loadPlayletAd" eventName:@"ShortplayDrawVideoDataRefreshCompletion" otherDic:@{} error:nil];
    }];
    // tab栏切换控制器的回调
    [self.playletAd loadAd:config];
}

- (void)showPlayletAd:(FlutterMethodCall*)call
{
    [self.playletAd showAd];
}

/**回调事件*/
- (void)callbackWithFunctionName:(NSString *)functionName
                       eventName:(NSString *)eventName
                        otherDic:(NSDictionary *)otherDic 
                           error:(NSError *)error {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setObject:eventName.length > 0 ?eventName :@"未知事件" forKey:@"event"];
    if (error) {
        [result setObject:[error convertJSONString] forKey:@"error"];
    } else {
        [result setObject:@"" forKey:@"error"];
    }
    if (otherDic) {
        [result addEntriesFromDictionary:otherDic];
    }
    if (functionName && functionName.length > 0) {
        [result setValue:functionName forKey:@"functionName"];
    }
    [_messageChannel sendMessage:result];
}


@end
