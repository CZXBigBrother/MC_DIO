import 'package:YTK_DIO_example/request_example.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:YTK_DIO/MC_YTK_DIO.dart';

class TestTestController extends StatefulWidget {
  @override
  State createState() {
    return TestTestControllerState();
  }
}

class TestTestControllerState extends State<TestTestController> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadNetwork();
  }

  void loadNetwork() async {
    LoginRequest request1 = LoginRequest();
    LoginRequest request2 = LoginRequest();
    LoginRequest request3 = LoginRequest();
    LoginRequest request4 = LoginRequest();
    LoginRequest request5 = LoginRequest();
    LoginRequest request6 = LoginRequest();
    LoginRequest request7 = LoginRequest();
    LoginRequest request8 = LoginRequest();

    MCBatchRequest batchRequest = MCBatchRequest([
      request1,
      request2,
      request3,
      request4,
      request5,
      request6,
      request7,
      request8
    ]);
    batchRequest.startWithCompletionBlockWithSuccess((success, failure) {
      print(success);
      print("------");
      print(failure);
    });
    // Dio dio = Dio();
    // List<Response> response = await Future.wait(
    //     [dio.get("https://xrurl.cn/"), dio.get("https://xrurl.cn/")]);
    // print(response.length);
    // for (Response item in response) {
    //   print(item.statusCode);
    // }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      body: Container(),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("dispose");
  }
}
