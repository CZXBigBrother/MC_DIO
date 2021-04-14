import 'package:dio/dio.dart';

/// Accessory实现协议
abstract class MCRequestAccessory {
  void requestWillStart();
  void requestDidStop();
  // void requestError();
}

class MCRequestAccessoryInterceptors extends InterceptorsWrapper {
  List<MCRequestAccessory>? accessory;
  MCRequestAccessoryInterceptors({this.accessory});
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (accessory != null || accessory!.length > 0) {
      for (MCRequestAccessory item in accessory!) {
        item.requestWillStart();
      }
    }
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (accessory != null || accessory!.length > 0) {
      for (MCRequestAccessory item in accessory!) {
        item.requestDidStop();
      }
    }
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (accessory != null || accessory!.length > 0) {
      for (MCRequestAccessory item in accessory!) {
        item.requestDidStop();
      }
    }
    return super.onError(err, handler);
  }
}
