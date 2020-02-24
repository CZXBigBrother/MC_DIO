import 'package:dio/dio.dart';
import 'MCRequestData.dart';
import 'MCConfig.dart';
import 'MCRequestAccessory.dart';
// import 'package:dio_cookie_manager/dio_cookie_manager.dart';
// import 'package:cookie_jar/cookie_jar.dart';

///所有支持的请求
enum MCRequestMethod {
  MCRequestMethodGet,
  MCRequestMethodPost,
  MCRequestMethodHead,
  MCRequestMethodPut,
  MCRequestMethodDelete,
  MCRequestMethodPatch,
  MCRequestMethodDownload,
}

typedef MCRequestCallback = void Function(MCRequestData data);

class MCBaseRequest {
  Dio dio = new Dio();

  ///成功回调
  MCRequestCallback success;

  ///失败回调
  MCRequestCallback failure;

  ///接收进度
  ProgressCallback onReceiveProgress;

  ///发送进度
  ProgressCallback onSendProgress;

  ///取消token
  CancelToken _token = CancelToken();

  List<MCRequestAccessory> _requestAccessories = List();
  void addAccessory(MCRequestAccessory accessory) {
    _requestAccessories.add(accessory);
  }

  void startWithCompletionBlockWithSuccess(
      MCRequestCallback success, MCRequestCallback failure) async {
    this.success = success;
    this.failure = failure;
    dio.options.connectTimeout = this.connectTimeout();
    dio.options.receiveTimeout = this.receiveTimeout();
    dio.options.sendTimeout = this.sendTimeout();
    dio.options.contentType = this.contentType();
    dio.options.responseType = this.responseType();
    this.CustomInterceptorAdd();
    if (_requestAccessories.length > 0) {
      dio.interceptors
          .add(MCRequestAccessoryInterceptors(accessory: _requestAccessories));
    }
    if (this.isLog() == true) {
      dio.interceptors.add(LogInterceptor(responseBody: false)); //开启请求日志
    }
    String path = "";
    if (this.requestUrl().startsWith("http") ||
        this.requestUrl().startsWith("ftp")) {
      path = this.requestUrl();
    } else {
      path = "${this.baseUrl()}${this.requestUrl()}";
    }
    Map param = this.requestArgument();
    Response res;
    try {
      if (this.requestMethod() == MCRequestMethod.MCRequestMethodGet) {
        res = await dio.get(path,
            queryParameters: param,
            cancelToken: this._token,
            onReceiveProgress: this.onReceiveProgress);
      } else if (this.requestMethod() == MCRequestMethod.MCRequestMethodPost) {
        res = await dio.post(path,
            queryParameters: param,
            cancelToken: this._token,
            onSendProgress: this.onSendProgress,
            onReceiveProgress: this.onReceiveProgress);
      } else if (this.requestMethod() == MCRequestMethod.MCRequestMethodHead) {
        res = await dio.head(path,
            queryParameters: param, cancelToken: this._token);
      } else if (this.requestMethod() == MCRequestMethod.MCRequestMethodPut) {
        res = await dio.put(path,
            queryParameters: param,
            cancelToken: this._token,
            onSendProgress: this.onSendProgress,
            onReceiveProgress: this.onReceiveProgress);
      } else if (this.requestMethod() ==
          MCRequestMethod.MCRequestMethodDelete) {
        res = await dio.delete(path,
            queryParameters: param, cancelToken: this._token);
      } else if (this.requestMethod() == MCRequestMethod.MCRequestMethodPatch) {
        res = await dio.patch(path,
            queryParameters: param,
            cancelToken: this._token,
            onSendProgress: this.onSendProgress,
            onReceiveProgress: this.onReceiveProgress);
      } else if (this.requestMethod() ==
          MCRequestMethod.MCRequestMethodDownload) {
        res = await dio.download(path, this.savePath(),
            queryParameters: param,
            cancelToken: this._token,
            onReceiveProgress: this.onReceiveProgress);
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

  ///停止请求
  void stop() {
    _token.cancel("cancelled");
  }

  /// header 返回
  Map<String, String> setHeader() {
    return null;
  }

  /// 请求参数
  dynamic requestArgument() {
    return null;
  }

  /// 请求URL
  String requestUrl() {
    return null;
  }

  /// 请求base host
  String baseUrl() {
    return MCNetworkConfig().baseUrl;
  }

  /// 请求类型
  MCRequestMethod requestMethod() {
    return MCRequestMethod.MCRequestMethodGet;
  }

  /// 链接超时时间
  int connectTimeout() {
    return 60000;
  }

  /// 发送超时时间
  int sendTimeout() {
    return 60000;
  }

  /// 接受超时时间
  int receiveTimeout() {
    return 60000;
  }

  ///下载地址
  String savePath() {
    return "";
  }

  ///是否打印调试信息
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

  /// 如果需要自定义添加一些拦截器可以重写该方法
  /// 如果添加cookie dio.interceptors.add(CookieManager(cookieJar));
  CustomInterceptorAdd() {}

  /// cookie_jar: ^1.0.1
  /// import 'package:cookie_jar/cookie_jar.dart';
  /// cookie管理
  /// 内存缓存
  /// return CookieManager(CookieJar());
  /// 本地缓存
  /// return CookieManager(PersistCookieJar());
  /// 缓存
  /// Directory appDocDir = await getApplicationDocumentsDirectory();
  /// String appDocPath = appDocDir.path;
  /// var cookieJar=PersistCookieJar(dir:appdocPath+"/.cookies/");
  // CookieManager cookieJar() {
  //   return null;
  // }
}
