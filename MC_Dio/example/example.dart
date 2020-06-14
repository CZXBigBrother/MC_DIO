import 'package:mc_dio/mc_dio.dart';

import 'request_example.dart';

void main() async {
  MCNetworkConfig().baseUrl = 'https://xrurl.cn/';
  MCNetworkConfig().isLog = true;
  sendRequestDemo();
  // var xxx = TestWidget();
  // xxx.start();
}

//网络请求 调用 LoginRequest
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

//批量发送请求
void sendBatchRequestDemo() async {
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
  RequestHUDAccessory hudAccessory = RequestHUDAccessory();
  batchRequest.addAccessory(hudAccessory);
  batchRequest.startWithCompletionBlockWithSuccess(
      (List<MCRequestData> success, List<MCRequestData> failure) {
    //成功的请求队列
    print(success);
    print("------");
    //失败的请求队列
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

class TestWidget implements MCRequestDelegate {
  @override
  void requestFailed(MCBaseRequest request) {
    print("requestFailed");
  }

  @override
  void requestFinished(MCBaseRequest request) {
    print("requestFinished");
  }

  void start() {
    LoginRequest request = LoginRequest();
    request.delegate = this;
    request.success = (data) {
      print("success");
    };
    request.failure = (data) {
      print("failure");
    };
    request.start();
  }
}
