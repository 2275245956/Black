import 'dart:convert' show json;

class APIResponse {

  String message;
  dynamic dataList;
  bool success;
  String result;

  APIResponse.fromParams({this.message, this.dataList, this.success, this.result});

  factory APIResponse(jsonStr) => jsonStr == null ? null : jsonStr is String ? new APIResponse.fromJson(json.decode(jsonStr)) : new APIResponse.fromJson(jsonStr);

  APIResponse.fromJson(jsonRes) {
    message = jsonRes['message'];
    dataList = jsonRes['dataList'];
    success = jsonRes['success'];
    result = jsonRes['result'];
  }

  // 请求错误返回
  APIResponse.error(msg) {
    message = msg;
    dataList = null;
    success = false;
    result = "FAILURE";
  }

  // 请求成功返回
  APIResponse.success(msg) {
    message = msg;
    dataList = null;
    success = true;
    result = "SUCCESS";
  }

  bool isOk(){
    return this.result == "SUCCESS";
  }

  @override
  String toString() {
    return '{"message": ${message != null?'${json.encode(message)}':'null'},"dataList": $dataList,"success": $success,"result": ${result != null?'${json.encode(result)}':'null'}}';
  }
}

