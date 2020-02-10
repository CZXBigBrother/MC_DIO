import 'package:YTK_DIO/MC_YTK_DIO.dart';

class MCBatchRequest {
  MCBatchRequest(List<MCBaseRequest> requestArray) {
    this._requestArray = requestArray;
  }
  List<MCBaseRequest> _requestArray;
  Function success;
  Function failure;
  int _currentEnd = 0;
  List<MCRequestData> successRequest = [];
  List<MCRequestData> failureRequest = [];

  void startWithCompletionBlockWithSuccess(Function success) async {
    for (MCBaseRequest request in this._requestArray) {
      request.startWithCompletionBlockWithSuccess((MCRequestData data) {
        this.successRequest.add(data);
        _currentEnd++;
        if (_currentEnd == this._requestArray.length) {
          print("完成请求${_currentEnd}");
          success(this.successRequest, this.failureRequest);
        }
      }, (MCRequestData error) {
        this.failureRequest.add(error);
        _currentEnd++;
        if (_currentEnd == this._requestArray.length) {
          print("完成请求${_currentEnd}");
          success(this.successRequest, this.failureRequest);
        }
      });
    }
  }

  void stop() {}
}
