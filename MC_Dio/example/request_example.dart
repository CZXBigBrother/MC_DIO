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
    return "http://any.clubchopp.com/any-starr/api/campaign/find_all_campaigns";
  }

  @override
  MCRequestMethod requestMethod() {
    return MCRequestMethod.Post;
  }

  @override
  bool isLog() {
    return false;
  }

  @override
  requestArgument() {
    FormData data = FormData.fromMap({"campaignJson":json.encode({"start_row": 0, "page_size": 10,"language":"English"})});
    return data;
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
