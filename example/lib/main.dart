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
  String _result = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: Text(_result),
              ),
            ),
            Expanded(
              child: Center(
                child: RaisedButton(
                  child: Text("scan"),
                  onPressed: () async {
                    String result;
                    try {
                      result = await ScanFlutterIos.scan();
                    } on PlatformException {
                      result = 'Failed to get platform version.';
                    }
                    setState(() {
                      _result = result;
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: RaisedButton(
                  child: Text("share"),
                  onPressed: () async {
                    bool result;
                    try {
                      result = await ScanFlutterIos.share([
                        {
                          'text': '哈哈哈哈哈哈哈哈',
                          'url': 'https://calcbit.com',
                          'imageUrl':
                              'https://calcbit.com/resource/doudou/doudou.jpeg'
                        }
                      ]);
                    } on PlatformException {
                      result = false;
                    }
                    setState(() {
                      _result = result ? '分享成功' : '分享失败';
                    });
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
