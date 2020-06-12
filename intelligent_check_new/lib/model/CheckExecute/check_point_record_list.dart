import 'dart:convert';

class CheckPointRecordList{
  String strDate;
  List<CheckPointRecordDetail> details;
}

class CheckPointRecordDetail {

  num id;
  String checkDate;
  String checkTime;
  String is_ok;
  String planName;
  String userName;

  CheckPointRecordDetail.fromParams({this.id, this.checkDate, this.checkTime, this.is_ok, this.planName, this.userName});

  factory CheckPointRecordDetail(jsonStr) => jsonStr == null ? null : jsonStr is String ? new CheckPointRecordDetail.fromJson(json.decode(jsonStr)) : new CheckPointRecordDetail.fromJson(jsonStr);

  CheckPointRecordDetail.fromJson(jsonRes) {
    id = jsonRes['id'];
    checkDate = jsonRes['checkDate'];
    checkTime = jsonRes['checkTime'];
    is_ok = jsonRes['is_ok'];
    planName = jsonRes['planName'];
    userName = jsonRes['userName'];
  }

  @override
  String toString() {
    return '{"id": $id,"checkDate": ${checkDate != null?'${json.encode(checkDate)}':'null'},"checkTime": ${checkTime != null?'${json.encode(checkTime)}':'null'},"is_ok": ${is_ok != null?'${json.encode(is_ok)}':'null'},"planName": ${planName != null?'${json.encode(planName)}':'null'},"userName": ${userName != null?'${json.encode(userName)}':'null'}}';
  }
}