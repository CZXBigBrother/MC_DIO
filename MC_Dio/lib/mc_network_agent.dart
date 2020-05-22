import 'mc_dio.dart';

class MCNetworkAgent {
  factory MCNetworkAgent() => _getInstance();
  static MCNetworkAgent get shareInstance => _getInstance();
  static MCNetworkAgent _instance;
  MCNetworkAgent._internal() {
    // 初始化
  }
  static MCNetworkAgent _getInstance() {
    if (_instance == null) {
      _instance = new MCNetworkAgent._internal();
    }
    return _instance;
  }

  Dio dio = new Dio();

  void addRequest(MCBaseRequest request) {
    Options options = Options();
    options.contentType = request.contentType();
    // options.connectTimeout = request.connectTimeout();
    options.receiveTimeout = request.receiveTimeout();
    options.sendTimeout = request.sendTimeout();
    options.contentType = request.contentType();
    options.responseType = request.responseType();
    options.headers = request.setHeader();
    
  }

  void cancelRequest(MCBaseRequest request) {}

  void cancelAllRequests() {}
}
