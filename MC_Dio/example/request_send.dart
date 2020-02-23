import 'package:MC_Dio/MC_Dio.dart';
import 'dart:async';

import 'request_example.dart';

void main() async {
  MCNetworkConfig().baseUrl = 'https://xrurl.cn/';
  MCNetworkConfig().isLog = true;
  sendRequestDemo();
}

void sendRequestDemo() {
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
    print("结束");
  }, (error) {
    print(error);
  });
}
