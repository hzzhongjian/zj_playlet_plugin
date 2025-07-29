import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zj_playlet_plugin/zj_playlet_plugin.dart';

enum ZJPlayletADType {
  interstitial,
  rewardVideoAd,
}

class ZjPlayletAdView extends StatelessWidget {
  /// 短剧的广告位ID
  final String adId;

  /// 展示的宽度
  final double width;

  /// 展示的高度
  final double height;

  /// json的名字
  final String JSONConfigPath;

  /// 免费观看的集数n
  final int freeEpisodesCount;

  /// 观看一次激励视频解锁的集数m
  final int unlockEpisodesCountUsingAD;

  /// 隐藏点赞
  final bool hideLikeIcon;

  /// 隐藏收藏
  final bool hideCollectIcon;

  /// 禁用双击点赞
  final bool disableDoubleClickLike;

  /// 禁用长按倍速
  final bool disableLongPressSpeed;

  /// 短剧中激励视频/插屏的广告位ID
  final String? posId;

  /// 短剧中激励视频/插屏的广告类型
  final int? adType;

  void Function(String type, String? msg)? onPlayletListener;

  ZjPlayletAdView(this.adId, this.JSONConfigPath,
      {required this.width,
      required this.height,
      required this.freeEpisodesCount,
      required this.unlockEpisodesCountUsingAD,
      this.hideLikeIcon = false,
      this.hideCollectIcon = false,
      this.disableDoubleClickLike = false,
      this.disableLongPressSpeed = false,
      this.posId,
      this.adType,
      this.onPlayletListener,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget adView;
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      adView = UiKitView(
        viewType: "com.zjplaylet.adsdk/playletAd",
        creationParams: {
          "adId": adId,
          "JSONConfigPath": JSONConfigPath,
          "width": width,
          "height": height,
          "freeEpisodesCount": freeEpisodesCount,
          "unlockEpisodesCountUsingAD": unlockEpisodesCountUsingAD,
          "hideLikeIcon": hideLikeIcon,
          "hideCollectIcon": hideCollectIcon,
          "disableDoubleClickLike": disableDoubleClickLike,
          "disableLongPressSpeed": disableLongPressSpeed,
          "posId": posId ?? "",
          "adType": adType ?? 0
        },
        creationParamsCodec: const JSONMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    } else {
      adView = Text("Platform of $defaultTargetPlatform not support.");
    }
    return Container(
      height: height,
      child: adView,
    );
  }

  void _onPlatformViewCreated(int id) {
    ZjPlayletPlugin.loadPlayletAdCallback = onPlayletListener;
  }
}
