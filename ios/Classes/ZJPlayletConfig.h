//
//  ZJPlayletConfig.h
//  zj_playlet_plugin
//
//  Created by 麻明康 on 2025/6/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJPlayletConfig : NSObject

/// 广告位id
@property (nonatomic, copy) NSString *adId;
/// config配置文件路径
@property (nonatomic, copy) NSString *JSONConfigPath;
/// 免费观看的集数n
@property (nonatomic, assign) NSInteger freeEpisodesCount;
/// 观看一次激励视频解锁的集数m
@property (nonatomic, assign) NSInteger unlockEpisodesCountUsingAD;
/// 隐藏点赞
@property (nonatomic) BOOL hideLikeIcon;
/// 隐藏收藏
@property (nonatomic) BOOL hideCollectIcon;
/// 禁用双击点赞
@property (nonatomic) BOOL disableDoubleClickLike;
/// 禁用长按倍速
@property (nonatomic) BOOL disableLongPressSpeed;
/// 距离屏幕顶端的距离
@property (nonatomic, assign) double offsetY;

+ (ZJPlayletConfig *)fromMap:(NSDictionary *)map;

@end

NS_ASSUME_NONNULL_END
