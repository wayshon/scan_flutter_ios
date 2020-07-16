import 'dart:async';

import 'package:flutter/services.dart';

class ScanFlutterIos {
  static const MethodChannel _channel = const MethodChannel('scan_flutter_ios');

  static Future<String> scan() async {
    final String result = await _channel.invokeMethod('scan');
    return result;
  }

  static Future<bool> share(param) async {
    final bool success = await _channel.invokeMethod('share', param);
    return success;
  }
}
