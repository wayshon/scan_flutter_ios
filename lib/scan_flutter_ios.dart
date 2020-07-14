import 'dart:async';

import 'package:flutter/services.dart';

class ScanFlutterIos {
  static const MethodChannel _channel =
      const MethodChannel('scan_flutter_ios');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
