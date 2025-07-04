import 'package:flutter/material.dart';
import 'dart:async';
import 'package:zj_playlet_plugin/zj_playlet_plugin.dart';

void main() {
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
                        print('初始化结果$result, 初始化消息$msg');
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
                      onCallback: (type, msg) {
                        switch (type) {
                          case "PlayletLoadSuccess":
                            print("短剧加载成功PlayletLoadSuccess");
                            break;
                          case "PlayletLoadFailure":
                            print("短剧加载失败PlayletLoadFailure");
                            break;
                          // 以下添加自己需要的方法回调判断，事件类型参照ZjPlayletPlugin文件的事件类型说明
                          default:
                        }
                      },
                    );
                  },
                  child: const Text("加载短剧广告")),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    // 短剧的展示
                    ZjPlayletPlugin.showPlayletAd();
                  },
                  child: const Text("展示短剧广告"))
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
