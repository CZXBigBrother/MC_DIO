import 'package:dio/dio.dart';

/// Accessory实现协议
abstract class MCRequestAccessory {
  void requestWillStart();
  void requestDidStop();
  // void requestError();
}

class MCRequestAccessoryInterceptors extends InterceptorsWrapper {
  List<MCRequestAccessory> accessory;
  MCRequestAccessoryInterceptors({this.accessory});
  @override
  Future onRequest(RequestOptions options) {
    if (accessory != null || accessory.length > 0) {
      for (MCRequestAccessory item in accessory) {
        item.requestWillStart();
      }
    }
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) {
    if (accessory != null || accessory.length > 0) {
      for (MCRequestAccessory item in accessory) {
        item.requestDidStop();
      }
    }
    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) {
    if (accessory != null || accessory.length > 0) {
      for (MCRequestAccessory item in accessory) {
        item.requestDidStop();
      }
    }
    return super.onError(err);
  }
}