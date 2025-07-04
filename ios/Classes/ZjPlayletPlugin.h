#import <Flutter/Flutter.h>

@interface ZjPlayletPlugin : NSObject<FlutterPlugin, FlutterStreamHandler>

@property (nonatomic, strong) NSObject <FlutterBinaryMessenger> *messenger;

@property (nonatomic, strong)  FlutterMethodChannel  *methodChannel;

+ (ZjPlayletPlugin *)shareInstance;

@end
