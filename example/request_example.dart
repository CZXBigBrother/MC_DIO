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

  @override
  MCRequestMethod requestMethod() {
    return MCRequestMethod.Get;
  }

  @override
  bool isLog() {
    return false;
  }

  @override
  requestArgument() {
    // FormData data = FormData.fromMap({
    //   "campaignJson":
    //       json.encode({"start_row": 0, "page_size": 10, "language": "English"})
    // });
    // return data;
  }
// @override
// mock() {
//   return {"mock_key":"mock data"};
// }
}

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
