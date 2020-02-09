import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:YTK_DIO/MC_YTK_DIO.dart';
import 'request_example.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    MCNetworkConfig().baseUrl = 'https://xrurl.cn/';
    MCNetworkConfig().isLog = true;
    initPlatformState();
    LoginRequest request = LoginRequest();
    RequestHUDAccessory hudAccessory = RequestHUDAccessory();
    request.addAccessory(hudAccessory);
    request.startWithCompletionBlockWithSuccess((data) {
      print(data.statusCode);
      print("结束");
    }, (error) {
      print(error);
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
