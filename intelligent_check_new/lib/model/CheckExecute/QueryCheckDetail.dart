import 'dart:convert';

class QueryCheckDetail{
  QueryCheckDetailCheckInfo checkInfo;
  List<QueryCheckDetailInputItem> inputItems;
  List<String> images = List();
}

class QueryCheckDetailCheckInfo {

  int id;
  String checkDate;
  String checkTime;
  String is_ok;
  String planName;
  String pointName;
  String userName;

  QueryCheckDetailCheckInfo.fromParams({this.id, this.checkDate, this.checkTime, this.is_ok, this.planName, this.pointName, this.userName});

  factory QueryCheckDetailCheckInfo(jsonStr) => jsonStr == null ? null : jsonStr is String ? new QueryCheckDetailCheckInfo.fromJson(json.decode(jsonStr)) : new QueryCheckDetailCheckInfo.fromJson(jsonStr);

  QueryCheckDetailCheckInfo.fromJson(jsonRes) {
    id = jsonRes['id'];
    checkDate = jsonRes['checkDate'];
    checkTime = jsonRes['checkTime'];
    is_ok = jsonRes['is_ok'];
    planName = jsonRes['planName'];
    pointName = jsonRes['pointName'];
    userName = jsonRes['userName'];
  }

  @override
  String toString() {
    return '{"id": $id,"checkDate": ${checkDate != null?'${json.encode(checkDate)}':'null'},"checkTime": ${checkTime != null?'${json.encode(checkTime)}':'null'},"is_ok": ${is_ok != null?'${json.encode(is_ok)}':'null'},"planName": ${planName != null?'${json.encode(planName)}':'null'},"pointName": ${pointName != null?'${json.encode(pointName)}':'null'},"userName": ${userName != null?'${json.encode(userName)}':'null'}}';
  }
}

class QueryCheckDetailInputItem {

  int id;
  String inputItem;
  String input_value;
  String is_ok;

  QueryCheckDetailInputItem.fromParams({this.id, this.inputItem, this.input_value, this.is_ok});

  factory QueryCheckDetailInputItem(jsonStr) => jsonStr == null ? null : jsonStr is String ? new QueryCheckDetailInputItem.fromJson(json.decode(jsonStr)) : new QueryCheckDetailInputItem.fromJson(jsonStr);

  QueryCheckDetailInputItem.fromJson(jsonRes) {
    id = jsonRes['id'];
    inputItem = jsonRes['inputItem'];
    input_value = jsonRes['input_value'];
    is_ok = jsonRes['is_ok'];
  }

  @override
  String toString() {
    return '{"id": $id,"inputItem": ${inputItem != null?'${json.encode(inputItem)}':'null'},"input_value": ${input_value != null?'${json.encode(input_value)}':'null'},"is_ok": ${is_ok != null?'${json.encode(is_ok)}':'null'}}';
  }
}