import 'package:mc_dio/mc_dio.dart';

import 'request_example.dart';

void main() async {
  ///配置base,也可以直接传回自动判断是不是http 或者 https
  MCNetworkConfig().baseUrl = 'https://xrurl.cn/';

  ///统一打开日志
  MCNetworkConfig().isLog = true;

  ///正常请求
  sendRequestDemo();
  var delegateRequest = TestWidget();
  delegateRequest.start();
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
    LoginRequest request2 = data.requestObject;
    print(request2);
    print(data.response);
  }, (error) {
    print(error.error!.message);
    // print(error.error!.response);
  });
}

///批量发送请求
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
      (List<MCRequestData?> success, List<MCRequestData?> failure) {
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

/// 代理模式
class TestWidget implements MCRequestDelegate {
  @override
  void requestFailed(request) {
    print("代理回调requestFailed");
  }

  @override
  void requestFinished(request) {
    LoginRequest request2 = request;
    print(request2.response!.data);
    print("代理回调requestFinished");
  }

  void start() {
    LoginRequest request = LoginRequest();
    request.delegate = this;
    request.start();
  }
}
