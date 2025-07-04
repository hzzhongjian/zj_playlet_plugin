//
//  ZJPlayletConfig.m
//  zj_playlet_plugin
//
//  Created by 麻明康 on 2025/6/30.
//

#import "ZJPlayletConfig.h"

@implementation ZJPlayletConfig

+ (ZJPlayletConfig *)fromMap:(NSDictionary *)map
{
    ZJPlayletConfig *config = [[ZJPlayletConfig alloc] init];
    if ([map.allKeys containsObject:@"adId"]) {
        config.adId = [map objectForKey:@"adId"];
    }
    if ([map.allKeys containsObject:@"JSONConfigPath"]) {
        config.JSONConfigPath = [map objectForKey:@"JSONConfigPath"];
    }
    if ([map.allKeys containsObject:@"freeEpisodesCount"]) {
        config.freeEpisodesCount = [[map objectForKey:@"freeEpisodesCount"] integerValue];
    }
    if ([map.allKeys containsObject:@"unlockEpisodesCountUsingAD"]) {
        config.unlockEpisodesCountUsingAD = [[map objectForKey:@"unlockEpisodesCountUsingAD"] integerValue];
    }
    if ([map.allKeys containsObject:@"hideLikeIcon"]) {
        config.hideLikeIcon = [[map objectForKey:@"hideLikeIcon"] boolValue];
    }
    if ([map.allKeys containsObject:@"hideCollectIcon"]) {
        config.hideCollectIcon = [[map objectForKey:@"hideCollectIcon"] boolValue];
    }
    if ([map.allKeys containsObject:@"disableDoubleClickLike"]) {
        config.disableDoubleClickLike = [[map objectForKey:@"disableDoubleClickLike"] boolValue];
    }
    if ([map.allKeys containsObject:@"disableLongPressSpeed"]) {
        config.disableLongPressSpeed = [[map objectForKey:@"disableLongPressSpeed"] boolValue];
    }
    if ([map.allKeys containsObject:@"offsetY"]) {
        config.offsetY = [[map objectForKey:@"offsetY"] doubleValue];
    }
    return config;
}

@end
