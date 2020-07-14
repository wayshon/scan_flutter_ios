import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scan_flutter_ios/scan_flutter_ios.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: RaisedButton(
            child: Text("scan"),
            onPressed: () async {
              String platformVersion;
              try {
                platformVersion = await ScanFlutterIos.scan();
              } on PlatformException {
                platformVersion = 'Failed to get platform version.';
              }
              print(platformVersion);
            },
          ),
        ),
      ),
    );
  }
}
