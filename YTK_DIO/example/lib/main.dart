import 'package:YTK_DIO_example/test_view.dart';
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
    LoginRequest request =
        LoginRequest(username: "username", password: "password");
    RequestHUDAccessory hudAccessory = RequestHUDAccessory();
    request.onReceiveProgress = (int send, int total) {
      print("send ${send},total ${total}");
    };
    request.addAccessory(hudAccessory);
    request.startWithCompletionBlockWithSuccess((MCRequestData data) {
      print(data.requestObject);
      print(data.response);
      // print("结束");
    }, (error) {
      // print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Text("test01"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TestTestController()));
                // Navigator.of(context).push(new MaterialPageRoute(
                //     builder: (ctx) => testTestController()));
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "123",
        onPressed: () {
          Navigator.of(context).push(
              new MaterialPageRoute(builder: (ctx) => TestTestController()));
        },
      ),
    );
  }
}
