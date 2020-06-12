import 'dart:convert' show json;

class PlanTaskDetail {

  int batchNo;
  int finishStatus;
  int finshNum;
  int omission;
  int taskPlanNum;
  int unplan;
  int unqualified;
  String userId;
  int planTaskId;
  String beginTime;
  String checkDate;
  String endTime;
  String inOrder;
  String taskName;
  List<Point> points;
  String message;

  PlanTaskDetail.fromParams({this.batchNo, this.finishStatus, this.finshNum, this.omission, this.taskPlanNum, this.unplan, this.unqualified, this.userId, this.beginTime, this.checkDate, this.endTime, this.inOrder, this.taskName});

  factory PlanTaskDetail(jsonStr) => jsonStr == null ? null : jsonStr is String ? new PlanTaskDetail.fromJson(json.decode(jsonStr)) : new PlanTaskDetail.fromJson(jsonStr);

  PlanTaskDetail.fromJson(jsonRes) {
    batchNo = jsonRes['batchNo'];
    finishStatus = jsonRes['finishStatus'];
    finshNum = jsonRes['finshNum'];
    omission = jsonRes['omission'];
    taskPlanNum = jsonRes['taskPlanNum'];
    unplan = jsonRes['unplan'];
    unqualified = jsonRes['unqualified'];
    userId = jsonRes['userId'];
    beginTime = jsonRes['beginTime'];
    checkDate = jsonRes['checkDate'].toString();
    endTime = jsonRes['endTime'];
    inOrder = jsonRes['inOrder'];
    taskName = jsonRes['taskName'];
    planTaskId = jsonRes['planTaskId'];
  }

  @override
  String toString() {
    return '{"batchNo": $batchNo,"finishStatus": $finishStatus,"finshNum": $finshNum,"omission": $omission,"taskPlanNum": $taskPlanNum,"unplan": $unplan,"unqualified": $unqualified,"userId": $userId,"beginTime": ${beginTime != null?'${json.encode(beginTime)}':'null'},"checkDate": ${checkDate != null?'${json.encode(checkDate)}':'null'},"endTime": ${endTime != null?'${json.encode(endTime)}':'null'},"inOrder": ${inOrder != null?'${json.encode(inOrder)}':'null'},"taskName": ${taskName != null?'${json.encode(taskName)}':'null'}}';
  }
}

class Point {

  int pointId;
  String status;
  String isFixed;
  String name;
  String pointNO;
  num finish;
  num orderNo;

  Point.fromParams({this.pointId, this.status, this.isFixed, this.name, this.pointNO,this.finish,this.orderNo});

  factory Point(jsonStr) => jsonStr == null ? null : jsonStr is String ? new Point.fromJson(json.decode(jsonStr)) : new Point.fromJson(jsonStr);

  Point.fromJson(jsonRes) {
    pointId = jsonRes['pointId'];
    status = jsonRes['status'];
    isFixed = jsonRes['isFixed'];
    name = jsonRes['name'];
    pointNO = jsonRes['pointNO'];
    finish = jsonRes['finish'];
    orderNo = jsonRes['orderNo'];
  }

  @override
  String toString() {
    return '{"pointId": $pointId,"status": $status,"isFixed": ${isFixed != null?'${json.encode(isFixed)}':'null'},"name": ${name != null?'${json.encode(name)}':'null'},"pointNO": ${pointNO != null?'${json.encode(pointNO)}':'null'}}';
  }
}