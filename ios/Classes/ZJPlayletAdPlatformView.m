//
//  ZJPlayletAdPlatformView.m
//  zj_playlet_plugin
//
//  Created by 麻明康 on 2025/7/21.
//

#import "ZJPlayletAdPlatformView.h"
#import "ZJPlayletTool.h"
#import <ZJSDK/ZJTubePageAd.h>
#import "ZJPlayletPlugin.h"


@interface ZJPlayletAdPlatformView () <ZJContentPageVideoStateDelegate,ZJContentPageStateDelegate, ZJContentPageLoadCallBackDelegate, ZJShortPlayCustomViewDelegate, ZJShortPlayInterfaceDelegate, ZJShortPlayCustomDrawAdViewDelegate, ZJShortPlayDrawVideoViewControllerBannerDelegate, ZJShortPlayAdDelegate, ZJShortPlayPlayerDelegate>


@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, assign) int64_t viewId;

@property (nonatomic, strong) ZJTubePageAd *tubePageAd;

@property (nonatomic, weak) UIViewController *weakTubeVC;

@end

@implementation ZJPlayletAdPlatformView

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
                    registrar:(NSObject<FlutterPluginRegistrar> *)registrar
{
    if (self = [super init]) {
        self.viewId = viewId;
        NSString *adId = [args objectForKey:@"adId"];
        NSString *JSONConfigPath = [args objectForKey:@"JSONConfigPath"];
        int freeEpisodesCount = [[args objectForKey:@"freeEpisodesCount"] intValue];
        int unlockEpisodesCountUsingAD = [[args objectForKey:@"unlockEpisodesCountUsingAD"] intValue];
        double width = [[args objectForKey:@"width"] doubleValue];
        double height = [[args objectForKey:@"height"] doubleValue];
        BOOL hideLikeIcon = [[args objectForKey:@"hideLikeIcon"] boolValue];
        BOOL hideCollectIcon = [[args objectForKey:@"hideCollectIcon"] boolValue];
        BOOL disableDoubleClickLike = [[args objectForKey:@"disableDoubleClickLike"] boolValue];
        BOOL disableLongPressSpeed = [[args objectForKey:@"disableLongPressSpeed"] boolValue];
        int adType = [[args objectForKey:@"adType"] intValue];
        NSString *posId = [args objectForKey:@"posId"];
        ZJTubePageConfig *tubePageConfig = [[ZJTubePageConfig alloc] init];
        NSArray *JSONConfigArr = [JSONConfigPath componentsSeparatedByString:@"."];
        if (JSONConfigArr.count > 1) {
            tubePageConfig.JSONConfigPath = [[NSBundle mainBundle] pathForResource:JSONConfigArr.firstObject ofType:JSONConfigArr.lastObject];
        } else {
            tubePageConfig.JSONConfigPath = [[NSBundle mainBundle] pathForResource:JSONConfigArr.firstObject ofType:@"json"];
        }
        tubePageConfig.freeEpisodesCount = freeEpisodesCount;
        tubePageConfig.unlockEpisodesCountUsingAD = unlockEpisodesCountUsingAD;
        tubePageConfig.hideLikeIcon = hideLikeIcon;
        tubePageConfig.hideCollectIcon = hideCollectIcon;
        tubePageConfig.disableLongPressSpeed = disableLongPressSpeed;
        tubePageConfig.disableDoubleClickLike = disableDoubleClickLike;
        tubePageConfig.viewSize = CGSizeMake(width, height);
        tubePageConfig.showCloseButton = NO;
        if (adType == 1) {
            tubePageConfig.adType = ZJTubePageADTypeRewardVideo;
        } else {
            tubePageConfig.adType = ZJTubePageADTypeInterstitial;
        }
        if (posId && posId.length > 0) {
            tubePageConfig.posId = posId;
        }
        self.tubePageAd = [[ZJTubePageAd alloc]initWithPlacementId:adId];
        self.tubePageAd.tubePageConfig = tubePageConfig;
        self.tubePageAd.videoStateDelegate = self;
        self.tubePageAd.stateDelegate = self;
        self.tubePageAd.loadCallBackDelegate = self;
        // ====================
        /// 短剧播放器回调
        self.tubePageAd.playerCallbackDelegate = self;
        /// 广告回调
        self.tubePageAd.adCallbackDelegate = self;

        /// 业务接口回调
        self.tubePageAd.interfaceCallbackDelegate = self;

        /// 自定义详情页cell试图回调
        self.tubePageAd.customViewCallBackDelegate = self;

        /// 自定义Draw流的subview回调
        self.tubePageAd.customDrawAdViewCallBackDelegate = self;

        /// 滑滑溜底部自定义Banner广告
        self.tubePageAd.drawVideoViewBannerCallbackDelegate = self;
        
        [self.tubePageAd loadAd];
        
        
        self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        self.containerView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UIView *)view
{
    return _containerView;
}


#pragma mark - ZJContentPageStateDelegate

/**
* 内容展示
* @param content 内容模型
*/
- (void)zj_contentDidFullDisplay:(id<ZJContentInfo>)content
{
    NSLog(@"---------->>>>>>>%s", __FUNCTION__);
}
/**
* 内容隐藏
* @param content 内容模型
*/
- (void)zj_contentDidEndDisplay:(id<ZJContentInfo>)content
{
    NSLog(@"---------->>>>>>>%s", __FUNCTION__);
}
/**
* 内容暂停显示，ViewController disappear或者Application resign active
* @param content 内容模型
*/
- (void)zj_contentDidPause:(id<ZJContentInfo>)content
{
    NSLog(@"---------->>>>>>>%s", __FUNCTION__);
}
/**
* 内容恢复显示，ViewController appear或者Application become active
* @param content 内容模型
*/
- (void)zj_contentDidResume:(id<ZJContentInfo>)content
{
    NSLog(@"---------->>>>>>>%s", __FUNCTION__);
}

/// 任务完成回调
- (void)zjAdapter_contentTaskComplete:(id<ZJContentInfo>)content
{
    NSLog(@"---------->>>>>>>%s", __FUNCTION__);
}

#pragma mark - ZJContentPageVideoStateDelegate

/**
 * 视频开始播放
 * @param videoContent 内容模型
 */
- (void)zj_videoDidStartPlay:(id<ZJContentInfo>)videoContent
{
    NSLog(@"---------->>>>>>>%s", __FUNCTION__);
//    _videoDidStartPlayBlock ? _videoDidStartPlayBlock() : nil;
}
/**
* 视频暂停播放
* @param videoContent 内容模型
*/
- (void)zj_videoDidPause:(id<ZJContentInfo>)videoContent
{
    NSLog(@"---------->>>>>>>%s", __FUNCTION__);
//    _videoDidPauseBlock ? _videoDidPauseBlock() : nil;
}
/**
* 视频恢复播放
* @param videoContent 内容模型
*/
- (void)zj_videoDidResume:(id<ZJContentInfo>)videoContent
{
    NSLog(@"---------->>>>>>>%s", __FUNCTION__);
//    _videoDidResumeBlock ? _videoDidResumeBlock() : nil;
}
/**
* 视频停止播放
* @param videoContent 内容模型
* @param finished     是否播放完成
*/
- (void)zj_videoDidEndPlay:(id<ZJContentInfo>)videoContent isFinished:(BOOL)finished
{
    NSLog(@"---------->>>>>>>%s", __FUNCTION__);
//    _videoDidEndPlayBlock ? _videoDidEndPlayBlock() : nil;
}
/**
* 视频播放失败
* @param videoContent 内容模型
* @param error        失败原因
*/
- (void)zj_videoDidFailedToPlay:(id<ZJContentInfo>)videoContent withError:(NSError *)error
{
    NSLog(@"---------->>>>>>>%s", __FUNCTION__);
}

/// 一下四个代理方法只在横板视频里面调用
/// 进入横版视频详情页
/// @param viewController 详情页VC
/// @param content 视频信息
- (void)zj_horizontalFeedVideoDetailDidEnter:(UIViewController *)viewController contentInfo:(id<ZJContentInfo>)content
{
    NSLog(@"---------->>>>>>>%s", __FUNCTION__);
}

/// 离开横版视频详情页
/// @param viewController 详情页VC
- (void)zj_horizontalFeedVideoDetailDidLeave:(UIViewController *)viewController
{
    NSLog(@"---------->>>>>>>%s", __FUNCTION__);
}

/// 视频详情页appear
/// @param viewController 详情页VC
- (void)zj_horizontalFeedVideoDetailDidAppear:(UIViewController *)viewController
{
    NSLog(@"---------->>>>>>>%s", __FUNCTION__);
}

/// 详情页disappear
/// @param viewController 详情页VC
- (void)zj_horizontalFeedVideoDetailDidDisappear:(UIViewController *)viewController
{
    NSLog(@"---------->>>>>>>%s", __FUNCTION__);
}

/// 短剧内容加载成功和失败的代理方法，根据加载成功/失败来判断是否可以加载短剧页面
#pragma mark - ZJContentPageLoadCallBackDelegate

/// 内容加载成功
- (void)zj_contentPageLoadSuccess
{
    self.weakTubeVC = self.tubePageAd.tubePageViewController;
    if (self.weakTubeVC) {
        [self.weakTubeVC.view setFrame:self.containerView.bounds];
        [self.containerView addSubview:self.weakTubeVC.view];
        [[ZjPlayletPlugin shareInstance] callbackWithFunctionName:@"loadPlayletAd" eventName:@"PlayletLoadSuccess" otherDic:@{} error:nil];
    } else {
        [[ZjPlayletPlugin shareInstance] callbackWithFunctionName:@"loadPlayletAd" eventName:@"PlayletLoadFailure" otherDic:@{} error:nil];
    }
    
}

/// 内容加载失败
- (void)zj_contentPageLoadFailure:(NSError *)error
{
    [[ZjPlayletPlugin shareInstance] callbackWithFunctionName:@"loadPlayletAd" eventName:@"PlayletLoadFailure" otherDic:@{} error:nil];
}

// 自定义详情页cell试图
#pragma mark - ZJShortPlayCustomViewDelegate

/// 创建自定义View直接返回，外部不要持有，cell自己持有复用
/// @param cell 短剧的cell
- (UIView *)zj_shortplayPlayletDetailCellCustomView:(UITableViewCell *)cell
{
    return nil;
}

/// 根据数据更新UI
/// @param cell 短剧的cell
/// @param customView `djx_playletDetailCellCustomView:`返回的自定义View，短剧的cell内部会持有
/// @param playletInfo 短剧的数据
- (void)zj_shortplayPlayletDetailCell:(UITableViewCell *)cell updateCustomView:(UIView *)customView withPlayletData:(id)playletInfo
{
    NSLog(@"---------->>>>>>>%s", __FUNCTION__);
}

/// 当cell执行到layoutSubviews时会回调此协议方法
/// @param cell 短剧的cell
/// @param customView `djx_playletDetailCellCustomView:`返回的自定义View
- (void)zj_shortplayPlayletDetailCell:(UITableViewCell *)cell layoutSubviews:(UIView *)customView
{
    NSLog(@"---------->>>>>>>%s", __FUNCTION__);
}

/// 当cell执行到layoutSubviews后会回调此协议方法
/// @param cell 短剧的cell
/// @param customView `djx_playletDetailCellCustomView:`返回的自定义View
- (void)zj_shortplayPlayletDetailCell:(UITableViewCell *)cell afterLayoutSubviews:(UIView *)customView
{
    NSLog(@"---------->>>>>>>%s", __FUNCTION__);
}

// 业务接口回调
#pragma mark - ZJShortPlayInterfaceDelegate

/*! @abstract 解锁流程开始 */
- (void)zj_shortplayPlayletDetailUnlockFlowStart:(id<ZJContentInfo>)content
{
    [[ZjPlayletPlugin shareInstance] callbackWithFunctionName:@"loadPlayletAd" eventName:@"ShortplayPlayletDetailUnlockFlowStart" otherDic:@{} error:nil];
}

/*! @abstract 解锁流程取消 */
- (void)zj_shortplayPlayletDetailUnlockFlowCancel:(id<ZJContentInfo>)content
{
    [[ZjPlayletPlugin shareInstance] callbackWithFunctionName:@"loadPlayletAd" eventName:@"ShortplayPlayletDetailUnlockFlowCancel" otherDic:@{} error:nil];
}

- (BOOL)zj_shortplayPlayletDetailCustomUnlockView
{
    return NO;
}

/*! 自定义解锁弹窗 cancelUnlockCallback取消回调，unlockCallback确认的回调 */
- (void)zj_shortplayPlayletDetailUnlockFlowCancelUnlock:(void (^)(void))cancelUnlockCallback
                                                unlockCallback:(void(^)(void))unlockCallback
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"看广告解锁"
                                                                   message:[NSString stringWithFormat:@"看一个激励广告解锁%ld集", self.tubePageAd.tubePageConfig.unlockEpisodesCountUsingAD]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        cancelUnlockCallback();
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"看广告" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        unlockCallback();
    }]];
    [[ZJPlayletTool findCurrentShowingViewController] presentViewController:alert animated:YES completion:^{
            
    }];
}

/*! @abstract 解锁流程结束，回调解锁结果
 *  - success: 是否解锁成功
 *   - error: 解锁失败错误信息
 */
- (void)zj_shortplayPlayletDetailUnlockFlowEnd:(id<ZJContentInfo>)content
                           success:(BOOL)success
                             error:(NSError * _Nullable)error
{
    [[ZjPlayletPlugin shareInstance] callbackWithFunctionName:@"loadPlayletAd" eventName:@"ShortplayPlayletDetailUnlockFlowEnd" otherDic:@{@"info": success ? @"success" : @"failure" } error:nil];
}


/*! @abstract 点击混排中进入跳转播放页的按钮 */
- (void)zj_shortplayClickEnterView:(id<ZJContentInfo>)content
{
    [[ZjPlayletPlugin shareInstance] callbackWithFunctionName:@"loadPlayletAd" eventName:@"ShortplayClickEnterView" otherDic:@{} error:nil];
}

/*! @abstract 本剧集观看完毕，切到下一部短剧回调 */
- (void)zj_shortplayNextPlayletWillPlay:(id<ZJContentInfo>)content
{
    [[ZjPlayletPlugin shareInstance] callbackWithFunctionName:@"loadPlayletAd" eventName:@"ShortplayNextPlayletWillPlay" otherDic:@{} error:nil];
}

- (UIView *)zj_shortplayPlayletDetailBottomBanner:(id<ZJContentInfo>)content
{
    return nil;
}

/// 自定义Draw流的subview
#pragma mark - ZJShortPlayCustomDrawAdViewDelegate

- (UIView *)zj_shortplayDetailCellCreateAdView:(UITableViewCell *)cell adInputIndex:(NSUInteger)adIndex
{
    return nil;
}

- (void)zj_shortplayDetailCell:(UITableViewCell *)cell bindDataToDrawAdView:(UIView *)drawAdView adInputIndex:(NSUInteger)adIndex
{
    
}

- (void)zj_shortplayDetailCell:(UITableViewCell *)cell layoutSubview:(UIView *)drawAdView adInputIndex:(NSUInteger)adIndex
{
    
}

- (void)zj_shortplayDetailCell:(UITableViewCell *)cell willDisplayDrawAdView:(UIView *)drawAdView adInputIndex:(NSUInteger)adIndex
{
    
}

- (void)zj_shortplayDetailCell:(UITableViewCell *)cell didEndDisplayDrawAdView:(UIView *)drawAdView adInputIndex:(NSUInteger)adIndex
{
    
}

/// 滑滑溜底部自定义Banner广告
#pragma mark - ZJShortPlayDrawVideoViewControllerBannerDelegate
- (UIView *)zj_shortplayDrawVideoVCBottomBannerView:(UIViewController *)vc
{
    return nil;
}

// 广告回调
#pragma mark - ZJShortPlayAdDelegate
/*! @abstract 发起广告请求 */
- (void)zj_shortplaySendAdRequest:(id<ZJContentInfo>)content
{
    [[ZjPlayletPlugin shareInstance] callbackWithFunctionName:@"loadPlayletAd" eventName:@"ShortplaySendAdRequest" otherDic:@{} error:nil];
}

/*! @abstract 广告加载成功 */
- (void)zj_shortplayAdLoadSuccess:(id<ZJContentInfo>)content
{
    [[ZjPlayletPlugin shareInstance] callbackWithFunctionName:@"loadPlayletAd" eventName:@"ShortplayAdLoadSuccess" otherDic:@{} error:nil];
}

/*! @abstract 广告加载失败 */
- (void)zj_shortplayAdLoadFail:(id<ZJContentInfo>)content error:(NSError *)error
{
    [[ZjPlayletPlugin shareInstance] callbackWithFunctionName:@"loadPlayletAd" eventName:@"ShortplayAdLoadFail" otherDic:@{} error:error];
}

/*! @abstract 广告填充失败 */
- (void)zj_shortplayAdFillFail:(id<ZJContentInfo>)content
{
    [[ZjPlayletPlugin shareInstance] callbackWithFunctionName:@"loadPlayletAd" eventName:@"ShortplayAdFillFail" otherDic:@{} error:nil];
}

/*! @abstract 广告曝光 */
- (void)zj_shortplayAdWillShow:(id<ZJContentInfo>)content
{
    [[ZjPlayletPlugin shareInstance] callbackWithFunctionName:@"loadPlayletAd" eventName:@"ShortplayAdWillShow" otherDic:@{} error:nil];
}

/*! @abstract 视频广告开始播放 */
- (void)zj_shortplayVideoAdStartPlay:(id<ZJContentInfo>)content
{
    NSLog(@"---------->>>>>>>%s", __FUNCTION__);
}

/*! @abstract 视频广告暂停播放 */
- (void)zj_shortplayVideoAdPause:(id<ZJContentInfo>)content
{
    NSLog(@"---------->>>>>>>%s", __FUNCTION__);
}

/*! @abstract 视频广告继续播放 */
- (void)zj_shortplayVideoAdContinue:(id<ZJContentInfo>)content
{
    NSLog(@"---------->>>>>>>%s", __FUNCTION__);
}

/*! @abstract 视频广告停止播放 */
- (void)zj_shortplayVideoAdOverPlay:(id<ZJContentInfo>)content
{
    NSLog(@"---------->>>>>>>%s", __FUNCTION__);
}

/*! @abstract 点击广告 */
- (void)zj_shortplayClickAdViewEvent:(id<ZJContentInfo>)content
{
    [[ZjPlayletPlugin shareInstance] callbackWithFunctionName:@"loadPlayletAd" eventName:@"ShortplayClickAdView" otherDic:@{} error:nil];
}
/*! @abstract 广告缓冲 */
- (void)zj_shortplayVideoBufferEvent:(id<ZJContentInfo>)content
{
    NSLog(@"---------->>>>>>>%s", __FUNCTION__);
}

/*! @abstract 激励视频广告结束 */
- (void)zj_shortplayVideoRewardFinishEvent:(id<ZJContentInfo>)content
{
    [[ZjPlayletPlugin shareInstance] callbackWithFunctionName:@"loadPlayletAd" eventName:@"ShortplayVideoRewardFinish" otherDic:@{} error:nil];
}

/*! @abstract 激励视频广告跳过 */
- (void)zj_shortplayVideoRewardSkipEvent:(id<ZJContentInfo>)content
{
    [[ZjPlayletPlugin shareInstance] callbackWithFunctionName:@"loadPlayletAd" eventName:@"ShortplayVideoRewardSkip" otherDic:@{} error:nil];
}

// 从csj开始使用
/// 短剧播放器回调
#pragma mark - ZJShortPlayPlayerDelegate

/*! @abstract 视频切换时的回调 */
- (void)zj_shortplayDrawVideoCurrentVideoChanged:(NSInteger)index adapter:(id<ZJContentInfo>)content
{
    [[ZjPlayletPlugin shareInstance] callbackWithFunctionName:@"loadPlayletAd" eventName:@"ShortplayDrawVideoCurrentVideoChanged" otherDic:@{@"info":[NSString stringWithFormat:@"%ld", index]} error:nil];
}

/*! @abstract 加载失败按钮点击重试回调 */
- (void)zj_shortplayDrawVideoDidClickedErrorButtonRetry:(id<ZJContentInfo>)content
{
    [[ZjPlayletPlugin shareInstance] callbackWithFunctionName:@"loadPlayletAd" eventName:@"ShortplayDrawVideoDidClickedErrorButtonRetry" otherDic:@{} error:nil];
}

/*! @abstract 默认关闭按钮被点击的回调 */
- (void)zj_shortplayDrawVideoCloseButtonClicked:(id<ZJContentInfo>)content
{
    [[ZjPlayletPlugin shareInstance] callbackWithFunctionName:@"loadPlayletAd" eventName:@"ShortplayDrawVideoCloseButtonClicked" otherDic:@{} error:nil];
}

/*! @abstract 数据刷新完成回调 */
- (void)zj_shortplayDrawVideoDataRefreshCompletion:(NSError *)error content:(id<ZJContentInfo>)content
{
    [[ZjPlayletPlugin shareInstance] callbackWithFunctionName:@"loadPlayletAd" eventName:@"ShortplayDrawVideoDataRefreshCompletion" otherDic:@{} error:nil];
}

/*! @abstract tab栏切换控制器的回调*/
- (void)zj_shortplayPageViewControllerSwitchToIndex:(NSInteger)index content:(id<ZJContentInfo>)content
{
//    _shortplayPageViewControllerSwitchToIndexBlock ? _shortplayPageViewControllerSwitchToIndexBlock(index) : nil;
}

/**! @abstract 推荐页面底部banner视图**/
- (UIView *)zj_shortplayDrawVideoVCBottomBannerView:(UIViewController *)vc content:(id<ZJContentInfo>)content
{
    return nil;
}


@end


//**********************************************************************************//

@interface ZJPlayletAdPlatformViewFactory ()

@property (nonatomic, strong) NSObject <FlutterPluginRegistrar> *registrar;

@end

@implementation ZJPlayletAdPlatformViewFactory

- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar
{
    if (self = [super init]) {
        _registrar = registrar;
    }
    return self;
}

- (NSObject<FlutterMessageCodec> *)createArgsCodec
{
    return [FlutterJSONMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args {
    return [[ZJPlayletAdPlatformView alloc] initWithFrame:frame viewIdentifier:viewId arguments:args registrar:_registrar];
}

@end
