import 'mc_dio.dart';
// import 'package:dio_cookie_manager/dio_cookie_manager.dart';
// import 'package:cookie_jar/cookie_jar.dart';

abstract class MCRequestDelegate {
  void requestFinished(MCBaseRequest request);
  void requestFailed(MCBaseRequest request);
}

///所有支持的请求
enum MCRequestMethod {
  Get,
  Post,
  Head,
  Put,
  Delete,
  Patch,
  Download,
}

typedef MCRequestCallback = void Function(MCRequestData data);

class MCBaseRequest {
  MCRequestDelegate delegate;

  MCRequestData data;

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
    this.start();
    // this.clearCompletionBlock();
  }

  void start() async {
    dio.options.connectTimeout = this.connectTimeout();
    dio.options.receiveTimeout = this.receiveTimeout();
    dio.options.sendTimeout = this.sendTimeout();
    dio.options.contentType = this.contentType();
    dio.options.responseType = this.responseType();
    dio.options.headers = this.setHeader();
    dio.interceptors.clear();
    this.customInterceptorAdd();
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
    // Map param = this.requestArgument();
    Response res;

    dynamic mock = await this.mock();
    if (mock != null) {
      this.data =
          MCRequestData(requestObject: this, response: Response(data: mock));
      this.requestCompleteFilter();
      if (success != null) {
        success(this.data);
      }
      if (this.delegate != null) {
        this.delegate.requestFinished(this);
      }
      return;
    }

    try {
      if (this.requestMethod() == MCRequestMethod.Get) {
        res = await dio.get(path,
            queryParameters: this.requestArgument(),
            cancelToken: this._token,
            onReceiveProgress: this.onReceiveProgress);
      } else if (this.requestMethod() == MCRequestMethod.Post) {
        // print(param);
        res = await dio.post(path,
            data: this.requestArgument(),
            // queryParameters: param,
            cancelToken: this._token,
            onSendProgress: this.onSendProgress,
            onReceiveProgress: this.onReceiveProgress);
      } else if (this.requestMethod() == MCRequestMethod.Head) {
        res = await dio.head(path,
            queryParameters: this.requestArgument(), cancelToken: this._token);
      } else if (this.requestMethod() == MCRequestMethod.Put) {
        res = await dio.put(path,
            queryParameters: this.requestArgument(),
            cancelToken: this._token,
            onSendProgress: this.onSendProgress,
            onReceiveProgress: this.onReceiveProgress);
      } else if (this.requestMethod() == MCRequestMethod.Delete) {
        res = await dio.delete(path,
            queryParameters: this.requestArgument(), cancelToken: this._token);
      } else if (this.requestMethod() == MCRequestMethod.Patch) {
        res = await dio.patch(path,
            queryParameters: this.requestArgument(),
            cancelToken: this._token,
            onSendProgress: this.onSendProgress,
            onReceiveProgress: this.onReceiveProgress);
      } else if (this.requestMethod() == MCRequestMethod.Download) {
        res = await dio.download(path, this.savePath(),
            queryParameters: this.requestArgument(),
            cancelToken: this._token,
            onReceiveProgress: this.onReceiveProgress);
      }
    } on DioError catch (e) {
      this.data = MCRequestData(requestObject: this, error: e);
      this.requestCompleteFilter();
      if (this.failure != null) {
        this.failure(this.data);
      }
      if (this.delegate != null) {
        this.delegate.requestFailed(this);
      }
    }
    if (res == null) {
      this.data = MCRequestData(requestObject: this, error: DioError());
      this.requestCompleteFilter();
      if (this.failure != null) {
        this.failure(this.data);
      }
      if (this.delegate != null) {
        this.delegate.requestFailed(this);
      }
    } else {
      this.data = MCRequestData(requestObject: this, response: res);
      this.requestCompleteFilter();
      if (success != null) {
        success(this.data);
      }
      if (this.delegate != null) {
        this.delegate.requestFinished(this);
      }
    }
  }

  void clearCompletionBlock() {
    this.success = null;
    this.failure = null;
  }

  /// 请求fuction返回之前执行
  void requestCompleteFilter() {}

  ///停止请求
  void stop() {
    _token.cancel("cancelled");
  }

  /// header 返回
  Map<String, String> setHeader() {
    return {};
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
    return MCRequestMethod.Get;
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

  ///mock数据
  dynamic mock() async {
    return null;
  }

  /// 如果需要自定义添加一些拦截器可以重写该方法
  /// 如果添加cookie dio.interceptors.add(CookieManager(cookieJar));
  customInterceptorAdd() {}

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
