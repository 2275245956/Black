import 'dart:convert' show json;

class NoPlanPlanInfo {

  int batchNo;
  int finishNum;
  int finishStatus;
  int planTaskId;
  int pointId;
  String status;
  int userId;
  String OrgCode;
  String beginTime;
  String checkDate;
  String endTime;
  String taskName;
  int id;//point id
  String message;
  bool success;

  NoPlanPlanInfo.fromParams({this.batchNo, this.finishNum, this.finishStatus, this.planTaskId, this.pointId, this.status, this.userId, this.OrgCode, this.beginTime, this.checkDate, this.endTime, this.taskName,this.message,this.success});

  factory NoPlanPlanInfo(jsonStr) => jsonStr == null ? null : jsonStr is String ? new NoPlanPlanInfo.fromJson(json.decode(jsonStr)) : new NoPlanPlanInfo.fromJson(jsonStr);

  NoPlanPlanInfo.fromJson(jsonRes) {
    batchNo = jsonRes['batchNo'];
    finishNum = jsonRes['finishNum'];
    finishStatus = jsonRes['finishStatus'];
    planTaskId = jsonRes['planTaskId'];
    pointId = jsonRes['pointId'];
    status = jsonRes['status'];
    userId = jsonRes['userId'];
    OrgCode = jsonRes['OrgCode'];
    beginTime = jsonRes['beginTime'];
    checkDate = jsonRes['checkDate'];
    endTime = jsonRes['endTime'];
    taskName = jsonRes['taskName'];
    id = jsonRes['id'];
    ////////////////////////////////////////////////////////
    //20190521
    message = jsonRes['message'];
    success = jsonRes['success'];
  }

  @override
  String toString() {
    return '{"batchNo": $batchNo,"finishNum": $finishNum,"finishStatus": $finishStatus,"planTaskId": $planTaskId,"pointId": $pointId,"status": $status,"userId": $userId,"OrgCode": ${OrgCode != null?'${json.encode(OrgCode)}':'null'},"beginTime": ${beginTime != null?'${json.encode(beginTime)}':'null'},"checkDate": ${checkDate != null?'${json.encode(checkDate)}':'null'},"endTime": ${endTime != null?'${json.encode(endTime)}':'null'},"taskName": ${taskName != null?'${json.encode(taskName)}':'null'},"message": ${message != null?'${json.encode(message)}':'null'}}';
  }
}

