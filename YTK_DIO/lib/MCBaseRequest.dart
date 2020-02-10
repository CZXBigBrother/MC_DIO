import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'MCConfig.dart';

enum MCRequestMethod {
  MCRequestMethodGet,
  MCRequestMethodPost,
  MCRequestMethodHead,
  MCRequestMethodPut,
  MCRequestMethodDelete,
  MCRequestMethodPatch,
  MCRequestMethodDownload,
}

abstract class MCRequestAccessory {
  void requestWillStart();
  void requestDidStop();
  // void requestError();
}

class MCRequestData {
  MCRequestData({this.requestObject, this.response, this.error});
  MCBaseRequest requestObject;
  Response response;
  dynamic error;
}

class CustomInterceptors extends InterceptorsWrapper {
  List<MCRequestAccessory> accessory;
  CustomInterceptors({this.accessory});
  @override
  Future onRequest(RequestOptions options) {
    print("onRequest");
    if (accessory != null || accessory.length > 0) {
      for (MCRequestAccessory item in accessory) {
        item.requestWillStart();
      }
    }
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) {
    print("onResponse");
    if (accessory != null || accessory.length > 0) {
      for (MCRequestAccessory item in accessory) {
        item.requestDidStop();
      }
    }
    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) {
    print("onError");
    if (accessory != null || accessory.length > 0) {
      for (MCRequestAccessory item in accessory) {
        item.requestDidStop();
      }
    }
    return super.onError(err);
  }
}

class MCBaseRequest {
  Dio dio = new Dio();
  Function success;
  Function failure;
  List<MCRequestAccessory> _requestAccessories = List();
  void addAccessory(MCRequestAccessory accessory) {
    _requestAccessories.add(accessory);
  }

  CancelToken token = CancelToken();

  void startWithCompletionBlockWithSuccess(
      Function success, Function failure) async {
    this.success = success;
    this.failure = failure;
    dio.options.connectTimeout = this.connectTimeout();
    dio.options.receiveTimeout = this.receiveTimeout();
    dio.options.sendTimeout = this.sendTimeout();
    dio.options.contentType = this.contentType();
    dio.options.responseType = this.responseType();
    if (_requestAccessories.length > 0) {
      dio.interceptors.add(CustomInterceptors(accessory: _requestAccessories));
    }
    if (this.isLog() == true) {
      dio.interceptors.add(LogInterceptor(responseBody: false)); //开启请求日志
    }
    String path = "${this.baseUrl()}${this.requestUrl()}";
    Map param = this.requestArgument();
    Response res;
    try {
      if (this.requestMethod() == MCRequestMethod.MCRequestMethodGet) {
        res = await dio.get(path, queryParameters: param);
      } else if (this.requestMethod() == MCRequestMethod.MCRequestMethodPost) {
        res = await dio.post(path, queryParameters: param);
      } else if (this.requestMethod() == MCRequestMethod.MCRequestMethodHead) {
        res = await dio.head(path, queryParameters: param);
      } else if (this.requestMethod() == MCRequestMethod.MCRequestMethodPut) {
        res = await dio.put(path, queryParameters: param);
      } else if (this.requestMethod() ==
          MCRequestMethod.MCRequestMethodDelete) {
        res = await dio.delete(path, queryParameters: param);
      } else if (this.requestMethod() == MCRequestMethod.MCRequestMethodPatch) {
        res = await dio.patch(path, queryParameters: param);
      } else if (this.requestMethod() ==
          MCRequestMethod.MCRequestMethodDownload) {
        res = await dio.download(path, this.savePath(), queryParameters: param);
      }
    } catch (e) {
      if (failure != null) {
        failure(MCRequestData(requestObject: this, error: failure));
      }
    }

    if (res.statusCode == 200) {
      if (success != null) {
        success(MCRequestData(requestObject: this, response: res));
      }
    } else {
      if (failure != null) {
        // failure(res);
        failure(MCRequestData(requestObject: this, error: failure));
      }
    }
  }

  void clearCompletionBlock() {}
  void stop() {
    token.cancel("cancelled");
  }

  // header 返回
  Map<String, String> setHeader() {
    return null;
  }

  // 请求参数
  Map<String, String> requestArgument() {
    return null;
  }

  // 请求URL
  String requestUrl() {
    return null;
  }

  // 请求base host
  String baseUrl() {
    return MCNetworkConfig().baseUrl;
  }

  // 请求类型
  MCRequestMethod requestMethod() {
    return MCRequestMethod.MCRequestMethodGet;
  }

  // 链接超时时间
  int connectTimeout() {
    return 60000;
  }

  // 发送超时时间
  int sendTimeout() {
    return 60000;
  }

  // 接受超时时间
  int receiveTimeout() {
    return 60000;
  }

  //下载地址
  String savePath() {
    return "";
  }

  bool isLog() {
    return MCNetworkConfig().isLog;
  }

  /// 请求的Content-Type，默认值是"application/json; charset=utf-8".
  /// 如果您想以"application/x-www-form-urlencoded"格式编码请求数据,
  /// 可以设置此选项为 `Headers.formUrlEncodedContentType`,  这样[Dio]
  /// 就会自动编码请求体.
  String contentType() {
    return Headers.formUrlEncodedContentType;
  }

  /// [responseType] 表示期望以那种格式(方式)接受响应数据。
  /// 目前 [ResponseType] 接受三种类型 `JSON`, `STREAM`, `PLAIN`.
  ///
  /// 默认值是 `JSON`, 当响应头中content-type为"application/json"时，dio 会自动将响应内容转化为json对象。
  /// 如果想以二进制方式接受响应数据，如下载一个二进制文件，那么可以使用 `STREAM`.
  ///
  /// 如果想以文本(字符串)格式接收响应数据，请使用 `PLAIN`.
  ResponseType responseType() {
    return ResponseType.plain;
  }
  
}
