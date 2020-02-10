# MC_DIO
简书地址:[https://www.jianshu.com/u/82ce13e5e1fc](https://www.jianshu.com/u/82ce13e5e1fc)
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
}
```
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
填写中....
### 4.MCRequestAccessory 请求附件
填写中....
