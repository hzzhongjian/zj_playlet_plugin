import 'package:flutter/services.dart';

typedef ZJPlayletCallback = void Function(String msg);
typedef ZJPlayletAdCallback = void Function(String type, String? msg);

class ZjPlayletPlugin {
  static const int _channelId = 8080;

  /// The method channel used to interact with the native platform.
  static const methodChannel = MethodChannel('com.zjplaylet.adsdk/method');

  static void getSDKVersion({ZJPlayletCallback? onCallback}) async {
    methodChannel.invokeMethod("getSDKVersion");
    EventChannel eventChannel =
        const EventChannel("com.zjplaylet.adsdk/event_$_channelId");
    eventChannel.receiveBroadcastStream().listen((event) {
      switch (event["event"]) {
        case "SDKVersion":
          onCallback?.call(event["SDKVersion"].toString());
          break;
      }
    });
  }

  static void registerAppId(String appId, {ZJPlayletAdCallback? onCallback}) {
    methodChannel.invokeMethod("registerAppId", {"appId": appId});
    EventChannel eventChannel =
        const EventChannel("com.zjplaylet.adsdk/event_$_channelId");
    eventChannel.receiveBroadcastStream().listen((event) {
      switch (event["event"]) {
        case "success":
          onCallback?.call("success", event["info"].toString());
          break;
        case "fail":
          onCallback?.call("fail", event["info"].toString());
          break;
      }
    });
  }

  static void loadPlayletAd(String adId, {ZJPlayletAdCallback? onCallback}) {
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
    methodChannel.invokeMethod("loadPlayletAd", {
      "adId": adId,
      "JSONConfigPath": "SDK_Setting_5702576.json",
      "freeEpisodesCount": 5,
      "unlockEpisodesCountUsingAD": 5,
      "hideLikeIcon": false,
      "hideCollectIcon": false,
      "disableDoubleClickLike": false,
      "disableLongPressSpeed": true,
    });
    EventChannel eventChannel =
        const EventChannel("com.zjplaylet.adsdk/event_$_channelId");
    eventChannel.receiveBroadcastStream().listen((event) {
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
       */
      onCallback?.call(event["event"], event["info"]);
    });
  }

  static void showPlayletAd() {
    methodChannel.invokeMethod("showPlayletAd", {});
  }
}
