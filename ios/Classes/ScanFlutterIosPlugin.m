#import "ScanFlutterIosPlugin.h"
#import "ScanViewController.h"

@implementation ScanFlutterIosPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"scan_flutter_ios"
            binaryMessenger:[registrar messenger]];
    
    [channel invokeMethod:@"sd" arguments:@[]];
  ScanFlutterIosPlugin* instance = [[ScanFlutterIosPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"scan" isEqualToString:call.method]) {
      UIViewController *currentVC = [self getCurrentVC];
      ScanViewController *scanVC = [[ScanViewController alloc] initWithFlutterResult:result];
      [currentVC presentViewController:scanVC animated:YES completion:^() {}];
  } else if ([@"share" isEqualToString:call.method]) {
      [self share:call result:result];
      
      NSURL *url = [[NSBundle mainBundle] URLForResource:@"scan_flutter_ios" withExtension:@"bundle"];
      if (!url) {
          /// 动态库 url 的获取
          url = [[NSBundle bundleForClass:[self class]] URLForResource:@"scan_flutter_ios" withExtension:@"bundle"];
      }
      NSBundle *bundle = [NSBundle bundleWithURL:url];
      
      UIImage *image = [UIImage imageNamed:@"doudou" inBundle:bundle compatibleWithTraitCollection:nil];
      NSLog(@"%@", image);
      
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)share: (FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *param = [call.arguments objectAtIndex:0];
    NSString *textToShare = [param objectForKey:@"text"];
    NSString *urlString = [param objectForKey:@"url"];
    NSString *imageUrlString = [param objectForKey:@"imageUrl"];
    
    NSMutableArray *activityItems = [NSMutableArray new];
    
    if (textToShare != nil) {
        [activityItems addObject:textToShare];
    }
    
    if (urlString != nil) {
        NSURL *urlToShare = [NSURL URLWithString:urlString];
        [activityItems addObject:urlToShare];
    }
    
    if (imageUrlString != nil) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrlString]];
        UIImage *imageToShare = [UIImage imageWithData:data];
        [activityItems addObject:imageToShare];
    }
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    [[self getCurrentVC] presentViewController:activityVC animated:YES completion:nil];
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            result(@(YES));
        } else  {
            result(@(NO));
        }
    };
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
