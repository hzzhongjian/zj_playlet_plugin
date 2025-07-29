import 'package:flutter/material.dart';
import 'package:zj_playlet_plugin/zj_playlet_ad_view.dart';

class PlayletAd extends StatefulWidget {
  const PlayletAd({super.key});

  @override
  State<PlayletAd> createState() => _PlayletAdState();
}

class _PlayletAdState extends State<PlayletAd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: LayoutBuilder(builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;
        return ZjPlayletAdView(
          "J4470424195",
          "SDK_Setting_5702576.json",
          width: maxWidth,
          height: maxHeight,
          freeEpisodesCount: 2,
          unlockEpisodesCountUsingAD: 2,
          // posId: 'J3924100066',
          // adType: ZJPlayletADType.rewardVideoAd.index,
          onPlayletListener: (type, msg) {
            print("msg = $msg, type = $type");
          },
        );
      })),
    );
  }
}
