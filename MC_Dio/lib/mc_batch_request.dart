import 'mc_dio.dart';

typedef MCBatchCallback = void Function(
    List<MCRequestData> successRequest, List<MCRequestData> failureRequest);

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
  List<MCRequestAccessory> _requestAccessories = List();
  bool _isStop = false;

  void addAccessory(MCRequestAccessory accessory) {
    _requestAccessories.add(accessory);
  }

  void startWithCompletionBlockWithSuccess(MCBatchCallback success) async {
    for (MCRequestAccessory item in _requestAccessories) {
      item.requestWillStart();
    }
    for (MCBaseRequest request in this._requestArray) {
      request.startWithCompletionBlockWithSuccess((MCRequestData data) {
        this.successRequest.add(data);
        _currentEnd++;
        if (_currentEnd == this._requestArray.length && _isStop == false) {
          print("完成请求${_currentEnd}");
          success(this.successRequest, this.failureRequest);
          for (MCRequestAccessory item in _requestAccessories) {
            item.requestDidStop();
          }
        }
      }, (MCRequestData error) {
        this.failureRequest.add(error);
        _currentEnd++;
        if (_currentEnd == this._requestArray.length && _isStop == false) {
          print("完成请求${_currentEnd}");
          success(this.successRequest, this.failureRequest);
          for (MCRequestAccessory item in _requestAccessories) {
            item.requestDidStop();
          }
        }
      });
    }
  }

  void stop() {
    _isStop = true;
    for (MCBaseRequest request in _requestArray) {
      request.stop();
    }
  }
}
