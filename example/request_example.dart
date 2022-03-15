import 'dart:convert';

import 'package:mc_dio/mc_dio.dart';

class LoginRequest extends MCBaseRequest {
  LoginRequest({String? username, String? password}) {
    _username = username;
    _password = password;
  }

  String? _username;
  String? _password;

  @override
  String requestUrl() {
    return "https://download-1257933677.cos.ap-shanghai.myqcloud.com/download/t.json";
  }

  ///请求类型
  @override
  MCRequestMethod requestMethod() {
    return MCRequestMethod.Get;
  }

  ///是否打开log
  @override
  bool isLog() {
    return false;
  }

  ///传参
  @override
  requestArgument() {
    return {};
  }

  ///mock数据
// @override
// mock() {
//   return {"mock_key":"mock data"};
// }
}

///附件对象
class RequestHUDAccessory implements MCRequestAccessory {
  @override
  void requestDidStop(
      {Response? response,
      ResponseInterceptorHandler? handler,
      DioError? err,
      ErrorInterceptorHandler? handlerErr}) {
    print("RequestHUDAccessory requestDidStop");
  }

  @override
  void requestWillStart(
      {RequestOptions? options, RequestInterceptorHandler? handler}) {
    print("RequestHUDAccessory requestWillStart");
  }
}
