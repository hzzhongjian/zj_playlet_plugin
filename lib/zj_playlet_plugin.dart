import 'package:flutter/services.dart';

typedef ZJPlayletCallback = void Function(String msg);
typedef ZJPlayletAdCallback = void Function(String type, String? msg);

class ZjPlayletPlugin {
  /// The method channel used to interact with the native platform.
  static const _methodChannel = MethodChannel('com.zjplaylet.adsdk/method');

  static const _sdkMessageChannel = BasicMessageChannel(
      'com.zjplaylet.adsdk/sdk_message', JSONMessageCodec());

  static ZJPlayletCallback? sdkVersionCallback;

  static ZJPlayletAdCallback? registerSDKCallback;

  static ZJPlayletAdCallback? loadPlayletAdCallback;

  static void registerMethodChannel() {
    _sdkMessageChannel.setMessageHandler((dynamic message) => Future(() {
          dynamic event = message['functionName'];
          print('message = $message, $event');
          if (event == 'registerPlayletMethodChannel') {
          } else if (event == 'registerAppId') {
            registerSDKCallback?.call(message['event'], message['info']);
          } else if (event == 'getSDKVersion') {
            sdkVersionCallback?.call(message['SDKVersion']);
          } else if (event == 'loadPlayletAd') {
            loadPlayletAdCallback?.call(message["event"], message["info"]);
          }
          return "";
        }));
    _methodChannel.invokeMethod("registerPlayletMethodChannel");
  }

  static void getSDKVersion({ZJPlayletCallback? onCallback}) {
    sdkVersionCallback = onCallback;
    _methodChannel.invokeMethod("getSDKVersion");
  }

  static void registerAppId(String appId, {ZJPlayletAdCallback? onCallback}) {
    registerSDKCallback = onCallback;
    _methodChannel.invokeMethod("registerAppId", {"appId": appId});
  }

  static void loadPlayletAd(String adId, String JSONConfigPath,
      int freeEpisodesCount, int unlockEpisodesCountUsingAD,
      {bool? hideLikeIcon,
      bool? hideCollectIcon,
      bool? disableDoubleClickLike,
      bool? disableLongPressSpeed,
      double? offsetY,
      int? adType,
      String? posId,
      ZJPlayletAdCallback? onCallback}) {
    /**
         * event["event"] 事件类型说明
         * PlayletLoadSuccess 短剧加载成功
         * PlayletLoadFailure 剧加载失败
         *
         * ShortplayPlayletDetailUnlockFlowStart 解锁流程开始
         * ShortplayPlayletDetailUnlockFlowCancel 解锁流程取消
         * ShortplayPlayletDetailUnlockFlowEnd 解锁流程结束，回调解锁结果, event["info"]返回success，failure
         * ShortplayClickAdView 点击混排中进入跳转播放页的按钮
         * ShortplayNextPlayletWillPlay 本剧集观看完毕，切到下一部短剧回调
         *
         * ShortplaySendAdRequest 发起广告请求
         * ShortplayAdLoadSuccess 广告加载成功
         * ShortplayAdLoadFail 广告加载失败
         * ShortplayAdFillFail 广告填充失败
         * ShortplayAdWillShow 广告曝光
         * ShortplayClickAdView 点击广告
         * ShortplayVideoRewardFinish 激励视频广告结束
         * ShortplayVideoRewardSkip 激励视频广告跳过
         *
         * VideoDidStartPlay 视频开始播放
         * VideoDidPause 视频暂停播放
         * VideoDidResume 视频恢复播放
         * VideoDidEndPlay 视频停止播放
         *
         * ShortplayDrawVideoCurrentVideoChanged 视频切换时的回调"index"回调切换视频的索引
         * ShortplayDrawVideoDidClickedErrorButtonRetry 加载失败按钮点击重试回调
         * ShortplayDrawVideoCloseButtonClicked 默认关闭按钮被点击的回调
         * ShortplayDrawVideoDataRefreshCompletion 数据刷新完成回调
         *
         */
    loadPlayletAdCallback = onCallback;
    /**
     * 说明：
     * adId：广告位id
     * freeEpisodesCount 免费观看的集数n int类型
     * unlockEpisodesCountUsingAD 观看一次激励视频解锁的集数m int类型
     * hideLikeIcon 隐藏点赞 boolean类型
     * hideCollectIcon 隐藏收藏 boolean类型
     * disableDoubleClickLike 禁用双击点赞 boolean类型
     * disableLongPressSpeed 禁用长按倍速 boolean类型
     * offsetY 距离屏幕顶端的距离，默认为0，number类型，
     */
    _methodChannel.invokeMethod("loadPlayletAd", {
      "adId": adId,
      "JSONConfigPath": JSONConfigPath,
      "freeEpisodesCount": freeEpisodesCount,
      "unlockEpisodesCountUsingAD": unlockEpisodesCountUsingAD,
      "hideLikeIcon": hideLikeIcon ?? false,
      "hideCollectIcon": hideCollectIcon ?? false,
      "disableDoubleClickLike": disableDoubleClickLike ?? false,
      "disableLongPressSpeed": disableLongPressSpeed ?? false,
      "adType": adType ?? 0,
      "posId": posId ?? ""
    });
  }

  static void showPlayletAd() {
    _methodChannel.invokeMethod("showPlayletAd", {});
  }
}
