import 'package:YTK_DIO/MC_YTK_DIO.dart';

class LoginRequest extends MCBaseRequest {
  @override
  String requestUrl() {
    return "user/login";
  }

  @override
  MCRequestMethod requestMethod() {
    return MCRequestMethod.MCRequestMethodGet;
  }

  @override
  bool isLog() {
    return false;
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
