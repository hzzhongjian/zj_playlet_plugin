//
//  ZJPlayletAdPlatformView.h
//  zj_playlet_plugin
//
//  Created by 麻明康 on 2025/7/21.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJPlayletAdPlatformView : NSObject <FlutterPlatformView>

@end


@interface ZJPlayletAdPlatformViewFactory : NSObject <FlutterPlatformViewFactory>

- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar;

@end

NS_ASSUME_NONNULL_END
