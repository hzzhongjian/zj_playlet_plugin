//
//  ZJPlayletWrapper.h
//  zj_playlet_plugin
//
//  Created by 麻明康 on 2025/6/30.
//

#import <Foundation/Foundation.h>

@class ZJPlayletConfig;

NS_ASSUME_NONNULL_BEGIN

@interface ZJPlayletWrapper : NSObject


- (void)loadAd:(ZJPlayletConfig *)config;

- (void)showAd;

// ---------------------------------

// 短剧加载成功
@property (nonatomic, copy) void(^playletLoadSuccessBlock)(void);
// 短剧加载失败
@property (nonatomic, copy) void(^playletLoadFailureBlock)(void);

// ---------------------------------

// 视频开始播放
@property (nonatomic, copy) void (^videoDidStartPlayBlock)(void);

// 视频暂停播放
@property (nonatomic, copy) void (^videoDidPauseBlock)(void);

// 视频恢复播放
@property (nonatomic, copy) void (^videoDidResumeBlock)(void);

// 视频停止播放
@property (nonatomic, copy) void (^videoDidEndPlayBlock)(void);

// ---------------------------------

// 视频切换时的回调
@property (nonatomic, copy) void (^shortplayDrawVideoCurrentVideoChangedBlock)(NSInteger index);

// 加载失败按钮点击重试回调
@property (nonatomic, copy) void (^shortplayDrawVideoDidClickedErrorButtonRetryBlock)(void);

// 默认关闭按钮被点击的回调
@property (nonatomic, copy) void (^shortplayDrawVideoCloseButtonClickedBlock)(void);

// 数据刷新完成回调
@property (nonatomic, copy) void (^shortplayDrawVideoDataRefreshCompletionBlock)(void);

// tab栏切换控制器的回调
@property (nonatomic, copy) void (^shortplayPageViewControllerSwitchToIndexBlock)(NSInteger index);

// ---------------------------------

// 解锁流程开始
@property (nonatomic, copy) void (^shortplayPlayletDetailUnlockFlowStartBlock)(void);

// 解锁流程取消
@property (nonatomic, copy) void(^shortplayPlayletDetailUnlockFlowCancelBlock)(void);

// 解锁流程结束，回调解锁结果, success: 是否解锁成功
@property (nonatomic, copy) void(^shortplayPlayletDetailUnlockFlowEndBlock)(BOOL success);

// 点击混排中进入跳转播放页的按钮
@property (nonatomic, copy) void(^shortplayClickEnterViewBlock)(void);

// 本剧集观看完毕，切到下一部短剧回调
@property (nonatomic, copy) void(^shortplayNextPlayletWillPlayBlock)(void);

// ---------------------------------

// 发起广告请求
@property (nonatomic, copy) void (^shortplaySendAdRequestBlock)(void);

// 广告加载成功
@property (nonatomic, copy) void (^shortplayAdLoadSuccessBlock)(void);

// 广告加载失败
@property (nonatomic, copy) void (^shortplayAdLoadFailBlock)(NSError *error);

// 广告填充失败
@property (nonatomic, copy) void (^shortplayAdFillFailBlock)(void);

// 广告曝光
@property (nonatomic, copy) void (^shortplayAdWillShowBlock)(void);

// 点击广告
@property (nonatomic, copy) void (^shortplayClickAdViewEventBlock)(void);

// 激励视频广告结束
@property (nonatomic, copy) void (^shortplayVideoRewardFinishEventBlock)(void);

// 激励视频广告跳过
@property (nonatomic, copy) void (^shortplayVideoRewardSkipEventBlock)(void);

@end

NS_ASSUME_NONNULL_END
