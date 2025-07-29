import 'package:flutter/material.dart';
import 'dart:async';
import 'package:zj_playlet_plugin/zj_playlet_plugin.dart';
import './playlet_ad.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // 新增注册方法通道
  ZjPlayletPlugin.registerMethodChannel();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    // 第一步，sdk对接要先调用注册AppId的方法
                    ZjPlayletPlugin.registerAppId(
                      "Z6515902486",
                      onCallback: (result, msg) {
                        print('------初始化结果$result, 初始化消息$msg');
                      },
                    );
                  },
                  child: const Text("初始化")),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    // 短剧的加载
                    ZjPlayletPlugin.loadPlayletAd(
                      "J4470424195",
                      "SDK_Setting_5702576.json",
                      1,
                      2,
                      hideLikeIcon: false,
                      hideCollectIcon: false,
                      disableDoubleClickLike: false,
                      disableLongPressSpeed: true,
                      // adType: 1,
                      // posId: "J3924100066",
                      onCallback: (type, msg) {
                        print('type == $type, msg == $msg');
                        switch (type) {
                          case "PlayletLoadSuccess":
                            print("短剧加载成功PlayletLoadSuccess");
                            break;
                          case "PlayletLoadFailure":
                            print("短剧加载失败PlayletLoadFailure");
                            break;
                          case "VideoDidStartPlay":
                            print("视频开始播放");
                            break;
                          case "VideoDidPause":
                            print("视频暂停播放");
                            break;
                          case "VideoDidResume":
                            print("视频恢复播放");
                            break;
                          case "VideoDidEndPlay":
                            print("视频停止播放");
                            break;
                          case "ShortplayPlayletDetailUnlockFlowStart":
                            print("解锁流程开始");
                            break;
                          case "ShortplayPlayletDetailUnlockFlowCancel":
                            print("解锁流程取消");
                            break;
                          case "ShortplayPlayletDetailUnlockFlowEnd":
                            print("解锁流程结束，回调解锁结果, success: 是否解锁成功 == $msg");
                            break;
                          case "ShortplayClickEnterView":
                            print(" 点击混排中进入跳转播放页的按钮");
                            break;
                          case "ShortplayNextPlayletWillPlay":
                            print("本剧集观看完毕，切到下一部短剧回调");
                            break;
                          case "ShortplaySendAdRequest":
                            print("发起广告请求");
                            break;
                          case "ShortplayAdLoadSuccess":
                            print("广告加载成功");
                            break;
                          case "ShortplayAdLoadFail":
                            print("广告加载失败");
                            break;
                          case "ShortplayAdFillFail":
                            print("广告填充失败");
                            break;
                          case "ShortplayAdWillShow":
                            print("广告曝光");
                            break;
                          case "ShortplayClickAdView":
                            print("点击广告");
                            break;
                          case "ShortplayVideoRewardFinish":
                            print("激励视频广告结束");
                            break;
                          case "ShortplayVideoRewardSkip":
                            print("激励视频广告跳过");
                            break;
                          case "ShortplayDrawVideoCurrentVideoChanged":
                            print("视频切换时的回调 == $msg");
                            break;
                          case "ShortplayDrawVideoDidClickedErrorButtonRetry":
                            print("加载失败按钮点击重试回调");
                            break;
                          case "ShortplayDrawVideoCloseButtonClicked":
                            print("默认关闭按钮被点击的回调");
                            break;
                          case "ShortplayDrawVideoDataRefreshCompletion":
                            print("数据刷新完成回调");
                            break;
                          // 以下添加自己需要的方法回调判断，事件类型参照ZjPlayletPlugin文件的事件类型说明
                          default:
                            break;
                        }
                      },
                    );
                  },
                  child: const Text("原生加载短剧广告")),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    // 短剧的展示
                    ZjPlayletPlugin.showPlayletAd();
                  },
                  child: const Text("原生展示短剧广告")),
              const SizedBox(
                height: 20,
              ),
              Builder(builder: (context) {
                return ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return const PlayletAd();
                      }));
                    },
                    child: const Text("Widget加载短剧广告"));
              })
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // 获取SDK的版本号
            ZjPlayletPlugin.getSDKVersion(onCallback: (version) {
              print('====>>>>>$version');
            });
          },
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}
