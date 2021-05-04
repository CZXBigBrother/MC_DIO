class MCNetworkConfig {
  factory MCNetworkConfig() => _getInstance()!;

  static MCNetworkConfig? get shareInstance => _getInstance();
  static MCNetworkConfig? _instance;

  MCNetworkConfig._internal() {
    // 初始化
  }

  static MCNetworkConfig? _getInstance() {
    if (_instance == null) {
      _instance = new MCNetworkConfig._internal();
    }
    return _instance;
  }

  String baseUrl = "";
  bool isLog = false;
}
