import 'mc_dio.dart';

class MCRequestData<T> {
  MCRequestData({required this.requestObject, this.response, this.error});

  T requestObject;
  Response? response;
  DioError? error;
}


// Response
// {
//   /// 响应数据，可能已经被转换了类型, 详情请参考Options中的[ResponseType].
//   T data;
//   /// 响应头
//   Headers headers;
//   /// 本次请求信息
//   Options request;
//   /// Http status code.
//   int statusCode;
//   /// 是否重定向(Flutter Web不可用)
//   bool isRedirect;
//   /// 重定向信息(Flutter Web不可用)
//   List<RedirectInfo> redirects ;
//   /// 真正请求的url(重定向最终的uri)
//   Uri realUri;
//   /// 响应对象的自定义字段（可以在拦截器中设置它），调用方可以在`then`中获取.
//   Map<String, dynamic> extra;
// }
