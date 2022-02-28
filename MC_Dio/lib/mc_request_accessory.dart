import 'package:dio/dio.dart';

/// Accessory实现协议
abstract class MCRequestAccessory {
  void requestWillStart(
      {RequestOptions? options, RequestInterceptorHandler? handler});

  void requestDidStop(
      {Response? response,
      ResponseInterceptorHandler? handler,
      DioError? err,
      ErrorInterceptorHandler? handlerErr});

// void requestError();
}

class MCRequestAccessoryInterceptors extends InterceptorsWrapper {
  List<MCRequestAccessory>? accessory;

  MCRequestAccessoryInterceptors({this.accessory});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (accessory != null) {
      for (MCRequestAccessory item in accessory!) {
        item.requestWillStart(options: options, handler: handler);
      }
    }
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (accessory != null) {
      for (MCRequestAccessory item in accessory!) {
        item.requestDidStop(response: response, handler: handler);
      }
    }
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (accessory != null) {
      for (MCRequestAccessory item in accessory!) {
        item.requestDidStop(err: err, handlerErr: handler);
      }
    }
    return super.onError(err, handler);
  }
}
