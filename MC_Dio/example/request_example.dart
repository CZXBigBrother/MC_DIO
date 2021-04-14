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
    return "https://github.com/flutterchina/dio/blob/master/README-ZH.md#%E6%8B%A6%E6%88%AA%E5%99%A8";
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
  Map<String, String> requestArgument() {
    return {"username": _username ?? "", "password": _password ?? ""};
  }
// @override
// mock() {
//   return {"mock_key":"mock data"};
// }
}

class RequestHUDAccessory implements MCRequestAccessory {
  @override
  void requestDidStop() {
    print("RequestHUDAccessory requestDidStop");
  }

  @override
  void requestWillStart() {
    print("RequestHUDAccessory requestWillStart");
  }
}
