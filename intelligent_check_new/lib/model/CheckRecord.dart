import 'dart:convert' show json;

class CheckRecord {

  int catalogId;
  String checkMode;
  String error;
  String remark;
  String checkTime;
  String finishStatus;
  String id;
  String isOk;
  String orgCode;
  String planName;
  String planTaskId;
  String pointId;
  String pointName;
  String pointNo;
  String routeName;
  int score;
  String uploadTime;
  String userId;
  String userName;

  CheckRecord.fromParams({this.catalogId, this.checkMode, this.error, this.remark, this.checkTime, this.finishStatus, this.id, this.isOk, this.orgCode, this.planName, this.planTaskId, this.pointId, this.pointName, this.pointNo, this.routeName, this.score, this.uploadTime, this.userId, this.userName});

  factory CheckRecord(jsonStr) => jsonStr == null ? null : jsonStr is String ? new CheckRecord.fromJson(json.decode(jsonStr)) : new CheckRecord.fromJson(jsonStr);

  CheckRecord.fromJson(jsonRes) {
    catalogId = jsonRes['catalogId'];
    checkMode = jsonRes['checkMode'];
    error = jsonRes['error'];
    remark = jsonRes['remark'];
    checkTime = jsonRes['checkTime'];
    finishStatus = jsonRes['finishStatus'];
    id = jsonRes['id'];
    isOk = jsonRes['isOk'];
    orgCode = jsonRes['orgCode'];
    planName = jsonRes['planName'];
    planTaskId = jsonRes['planTaskId'];
    pointId = jsonRes['pointId'];
    pointName = jsonRes['pointName'];
    pointNo = jsonRes['pointNo'];
    routeName = jsonRes['routeName'];
    score = jsonRes['score'];
    uploadTime = jsonRes['uploadTime'];
    userId = jsonRes['userId'];
    userName = jsonRes['userName'];
  }

  @override
  String toString() {
    return '{"catalogId": $catalogId,"checkMode": ${checkMode != null?'${json.encode(checkMode)}':'null'},"error": ${error != null?'${json.encode(error)}':'null'},"remark": ${remark != null?'${json.encode(remark)}':'null'},"checkTime": ${checkTime != null?'${json.encode(checkTime)}':'null'},"finishStatus": ${finishStatus != null?'${json.encode(finishStatus)}':'null'},"id": ${id != null?'${json.encode(id)}':'null'},"isOk": ${isOk != null?'${json.encode(isOk)}':'null'},"orgCode": ${orgCode != null?'${json.encode(orgCode)}':'null'},"planName": ${planName != null?'${json.encode(planName)}':'null'},"planTaskId": ${planTaskId != null?'${json.encode(planTaskId)}':'null'},"pointId": ${pointId != null?'${json.encode(pointId)}':'null'},"pointName": ${pointName != null?'${json.encode(pointName)}':'null'},"pointNo": ${pointNo != null?'${json.encode(pointNo)}':'null'},"routeName": ${routeName != null?'${json.encode(routeName)}':'null'},"score": ${score != null?'${json.encode(score)}':'null'},"uploadTime": ${uploadTime != null?'${json.encode(uploadTime)}':'null'},"userId": ${userId != null?'${json.encode(userId)}':'null'},"userName": ${userName != null?'${json.encode(userName)}':'null'}}';
  }
}

