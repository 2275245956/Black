import 'dart:convert' show json;

class PlanListOutput {

  num batchNo;
  num finishStatus;
  num finshNum;
  num planTaskId;
  num taskPlanNum;
  String userId;
  String OrgCode;
  String beginTime;
  String checkDate;
  String endTime;
  String taskName;
  String executiveName;

  PlanListOutput.fromParams({this.batchNo, this.finishStatus, this.finshNum, this.planTaskId, this.taskPlanNum, this.userId, this.OrgCode, this.beginTime, this.checkDate, this.endTime, this.taskName});

  factory PlanListOutput(jsonStr) => jsonStr == null ? null : jsonStr is String ? new PlanListOutput.fromJson(json.decode(jsonStr)) : new PlanListOutput.fromJson(jsonStr);

  PlanListOutput.fromJson(jsonRes) {
    batchNo = jsonRes['batchNo'];
    finishStatus = jsonRes['finishStatus'];
    finshNum = jsonRes['finshNum'];
    planTaskId = jsonRes['planTaskId'];
    taskPlanNum = jsonRes['taskPlanNum'];
    userId = jsonRes['userId'];
    OrgCode = jsonRes['OrgCode'];
    beginTime = jsonRes['beginTime'].toString();
    checkDate = jsonRes['checkDate'].toString();
    endTime = jsonRes['endTime'];
    taskName = jsonRes['taskName'];
    executiveName = jsonRes['executiveName'];
  }

  PlanListOutput.fromJsonByOffline(jsonRes) {
    batchNo = jsonRes.batchNo==null?0:int.parse(jsonRes.batchNo);
    finishStatus = jsonRes.finishStatus==null?0:int.parse(jsonRes.finishStatus);
    finshNum = jsonRes.finshNum==null||jsonRes.finshNum=="" || jsonRes.finshNum=="null"?0:int.parse(jsonRes.finshNum);
    planTaskId = jsonRes.planTaskId==null||jsonRes.planTaskId==""||jsonRes.planTaskId=="null"?0:int.parse(jsonRes.planTaskId);
    taskPlanNum = jsonRes.taskPlanNum==null||jsonRes.taskPlanNum==""||jsonRes.taskPlanNum=="null"?0:int.parse(jsonRes.taskPlanNum);
    userId = jsonRes.userId==null||jsonRes.userId==""||jsonRes.userId=="null"?0:jsonRes.userId;
    OrgCode = jsonRes.OrgCode;
    beginTime = jsonRes.beginTime;
    checkDate = jsonRes.checkDate;
    endTime = jsonRes.endTime;
    taskName = jsonRes.taskName;
//    executiveName = jsonRes.executiveName;
  }

  @override
  String toString() {
    return '{"batchNo": $batchNo,"finishStatus": $finishStatus,"finshNum": $finshNum,"planTaskId": $planTaskId,"taskPlanNum": $taskPlanNum,"userId": $userId,"OrgCode": ${OrgCode != null?'${json.encode(OrgCode)}':'null'},"beginTime": ${beginTime != null?'${json.encode(beginTime)}':'null'},"checkDate": ${checkDate != null?'${json.encode(checkDate)}':'null'},"endTime": ${endTime != null?'${json.encode(endTime)}':'null'},"taskName": ${taskName != null?'${json.encode(taskName)}':'null'}}';
  }
}