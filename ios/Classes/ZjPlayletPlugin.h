#import <Flutter/Flutter.h>

@interface ZjPlayletPlugin : NSObject<FlutterPlugin>

@property (nonatomic, strong) NSObject <FlutterBinaryMessenger> *messenger;

+ (ZjPlayletPlugin *)shareInstance;

/**回调事件*/
- (void)callbackWithFunctionName:(NSString *)functionName
                       eventName:(NSString *)eventName
                        otherDic:(NSDictionary *)otherDic
                           error:(NSError *)error;

@end
