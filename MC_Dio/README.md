[![Pub](https://img.shields.io/pub/v/dio.svg?style=flat-square)](https://pub.dev/packages/mc_dio)

# MC_DIO
简书地址:https://www.jianshu.com/u/82ce13e5e1fc
 根据YTK的封装思路封装了dio的网络请求框架
 还在开发测试中,请勿使用在实际项目

# 已实现功能
### 1.MCNetworkConfig 类有两个作用：

 1. 统一设置网络请求的服务器和 CDN 的地址。

我们为什么需要统一设置服务器地址呢？因为：

 1. 按照设计模式里的 `Do Not Repeat Yourself` 原则，我们应该把服务器地址统一写在一个地方。
 2. 在实际业务中，我们的测试人员需要切换不同的服务器地址来测试。统一设置服务器地址到 MCNetworkConfig 类中，也便于我们统一切换服务器地址。

具体的用法是，在程序刚启动的回调中，设置好 MCNetworkConfig 的信息，如下所示：
```
 MCNetworkConfig().baseUrl = 'https://xrurl.cn/';
 MCNetworkConfig().isLog = true;
```
### 2.MCBaseRequest
MCBaseRequest 的基本的思想是把每一个网络请求封装成对象。所以使用 MCBaseRequest，你的每一种请求都需要继承 MCBaseRequest 类，通过覆盖父类的一些方法来构造指定的网络请求。把每一个网络请求封装成对象其实是使用了设计模式中的 Command 模式。

每一种网络请求继承 MCBaseRequest 类后，需要用方法覆盖（overwrite）的方式，来指定网络请求的具体信息。如下是一个示例：

假如我们要向网址 `https://xrurl.cn/user/login` 发送一个 `GET` 请求，，这个类应该如下所示：
```
class LoginRequest extends MCBaseRequest {
  LoginRequest({String username, String password}) {
    _username = username;
    _password = password;
  }
  String _username;
  String _password;
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

  @override
  Map<String, String> requestArgument() {
    // TODO: implement requestArgument
    return {"username": _username, "password": _password};
  }
}
```
在上面这个示例中，我们可以看到：

我们通过覆盖 MCBaseRequest 类的 requestUrl 方法，实现了指定网址信息。并且我们只需要指定除去域名剩余的网址信息，因为域名信息在 MCNetworkConfig 中已经设置过了。
我们通过覆盖 MCBaseRequest 类的 requestMethod 方法，实现了指定 GET 方法来传递参数。
我们通过覆盖 MCBaseRequest 类的 requestArgument 方法，提供了 GET 的信息。这里面的参数 username 和 password 
## 调用 LoginRequest
```
LoginRequest request = LoginRequest();
    RequestHUDAccessory hudAccessory = RequestHUDAccessory();
    request.addAccessory(hudAccessory);
    request.startWithCompletionBlockWithSuccess((MCRequestData data) {
      print(data.requestObject);
      print(data.response);
      // print("结束");
    }, (error) {
      // print(error);
    });
```

### 3.MCBatchRequest 批量发送
MCBatchRequest 类：用于方便地发送批量的网络请求，MCBatchRequest 是一个容器类，它可以放置多个 MCBaseRequest 子类，并统一处理这多个网络请求的成功和失败。
在如下的示例中，我们发送了 8 个批量的请求，并统一处理这 8 个请求同时成功的回调。
```
  void loadNetwork() async {
    LoginRequest request1 = LoginRequest();
    LoginRequest request2 = LoginRequest();
    LoginRequest request3 = LoginRequest();
    LoginRequest request4 = LoginRequest();
    LoginRequest request5 = LoginRequest();
    LoginRequest request6 = LoginRequest();
    LoginRequest request7 = LoginRequest();
    LoginRequest request8 = LoginRequest();

    MCBatchRequest batchRequest = MCBatchRequest([
      request1,
      request2,
      request3,
      request4,
      request5,
      request6,
      request7,
      request8
    ]);
    batchRequest.startWithCompletionBlockWithSuccess((success, failure) {
     //成功的请求队列
      print(success);
      //失败的请求队列
      print(failure);
    });
  }
```
### 4.MCRequestAccessory 请求附件
继承实现
```
class RequestHUDAccessory implements MCRequestAccessory {
  @override
  void requestDidStop() {
    //请求结束
    print("RequestHUDAccessory requestDidStop");
  }

  @override
  void requestWillStart() {
  //请求开始
    print("RequestHUDAccessory requestWillStart");
  }
}
```
使用方法
```
    LoginRequest request = LoginRequest();
    RequestHUDAccessory hudAccessory = RequestHUDAccessory();
    直接添加进请求对象队列
    request.addAccessory(hudAccessory);
```
#### 使用场景
1.hud生命周期管理统一通过RequestHUDAccessory实现
2.成功失败特殊任务实现

### 5.mock功能
重写mock函数
```
  @override
  mock() {
    return {"mock_key":"mock data"};
  }
```
重写之后data.response返回就为mock内容,且不会发起实际请求