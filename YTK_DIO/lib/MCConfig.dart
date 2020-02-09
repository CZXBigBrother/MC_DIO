class MCNetworkConfig {
  static final MCNetworkConfig _netWork = MCNetworkConfig._internal();
  factory MCNetworkConfig() {
    return _netWork;
  }
  MCNetworkConfig._internal();
  String baseUrl = "";
  bool isLog = false;
}
