import 'package:mc_dio/mc_dio.dart';

class LoginRequest extends MCBaseRequest {
  LoginRequest({String username, String password}) {
    _username = username;
    _password = password;
  }
  String _username;
  String _password;
  @override
  String requestUrl() {
    return "user/login";
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
    return {"username": _username, "password": _password};
  }
  @override
  mock() {
    return {"mock_key":"mock data"};
  }
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
