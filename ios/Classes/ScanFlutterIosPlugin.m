#import "ScanFlutterIosPlugin.h"
#import "ScanViewController.h"

@implementation ScanFlutterIosPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"scan_flutter_ios"
            binaryMessenger:[registrar messenger]];
  ScanFlutterIosPlugin* instance = [[ScanFlutterIosPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"scan" isEqualToString:call.method]) {
      UIViewController *currentVC = [self getCurrentVC];
      ScanViewController *scanVC = [ScanViewController new];
      [currentVC presentViewController:scanVC animated:YES completion:^() {
          result(@"show sacn vc");
      }];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;

    return result;
}

@end
