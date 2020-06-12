import 'dart:convert' show json;

class ActiviList {

  int id;
  int taskworkState;
  String belongDepartmentAndGroupName;
  String levelDesc;
  String taskworkName;
  String taskworkStateDesc;

  ActiviList.fromParams({this.id, this.taskworkState, this.belongDepartmentAndGroupName, this.levelDesc, this.taskworkName, this.taskworkStateDesc});

  factory ActiviList(jsonStr) => jsonStr == null ? null : jsonStr is String ? new ActiviList.fromJson(json.decode(jsonStr)) : new ActiviList.fromJson(jsonStr);

  ActiviList.fromJson(jsonRes) {
    id = jsonRes['id'];
    taskworkState = jsonRes['taskworkState'];
    belongDepartmentAndGroupName = jsonRes['belongDepartmentName'];
    levelDesc = jsonRes['levelDesc'];
    taskworkName = jsonRes['taskworkName'];
    taskworkStateDesc = jsonRes['taskworkStateDesc'];
  }

  @override
  String toString() {
    return '{"id": $id,"taskworkState": $taskworkState,"belongDepartmentAndGroupName": ${belongDepartmentAndGroupName != null?'${json.encode(belongDepartmentAndGroupName)}':'null'},"levelDesc": ${levelDesc != null?'${json.encode(levelDesc)}':'null'},"taskworkName": ${taskworkName != null?'${json.encode(taskworkName)}':'null'},"taskworkStateDesc": ${taskworkStateDesc != null?'${json.encode(taskworkStateDesc)}':'null'}}';
  }
}
 
class ActivilityModel {

  int currentFlowRecordId;
  int id;
  String applyDateTime;
  String applyDepartmentName;
  String applyUserName;
  String belongDepartmentAndGroupName;
  String levelDesc;
  String partName;
  String postName;
  String taskworkName;
  List<Records> records;
  String taskWorkType;

  ActivilityModel.fromParams({this.taskWorkType,this.currentFlowRecordId, this.id, this.applyDateTime, this.applyDepartmentName, this.applyUserName, this.belongDepartmentAndGroupName, this.levelDesc, this.partName, this.postName, this.taskworkName, this.records});

  factory ActivilityModel(jsonStr) => jsonStr == null ? null : jsonStr is String ? new ActivilityModel.fromJson(json.decode(jsonStr)) : new ActivilityModel.fromJson(jsonStr);

  ActivilityModel.fromJson(jsonRes) {
    currentFlowRecordId = jsonRes['currentFlowRecordId'];
    id = jsonRes['id'];
    applyDateTime = jsonRes['applyDate'];
    applyDepartmentName = jsonRes['applyDepartmentName'];
    applyUserName = jsonRes['applyUserName'];
    belongDepartmentAndGroupName = jsonRes['belongDepartmentName'];
    levelDesc = jsonRes['levelName'];
    partName = jsonRes['taskworkPosition'];
    postName = jsonRes['taskworkJob'];
    taskworkName = jsonRes['taskworkName'];
    records = jsonRes['records'] == null ? null : [];
    taskWorkType=jsonRes['taskWorkType'];

    for (var recordsItem in records == null ? [] : jsonRes['records']){
      records.add(recordsItem == null ? null : new Records.fromJson(recordsItem));
    }
  }

  @override
  String toString() {
    return '{"currentFlowRecordId": $currentFlowRecordId,"id": $id,"applyDateTime": ${applyDateTime != null?'${json.encode(applyDateTime)}':'null'},"applyDepartmentName": ${applyDepartmentName != null?'${json.encode(applyDepartmentName)}':'null'},"applyUserName": ${applyUserName != null?'${json.encode(applyUserName)}':'null'},"belongDepartmentAndGroupName": ${belongDepartmentAndGroupName != null?'${json.encode(belongDepartmentAndGroupName)}':'null'},"levelDesc": ${levelDesc != null?'${json.encode(levelDesc)}':'null'},"partName": ${partName != null?'${json.encode(partName)}':'null'},"postName": ${postName != null?'${json.encode(postName)}':'null'},"taskworkName": ${taskworkName != null?'${json.encode(taskworkName)}':'null'},"taskWorkType": ${taskWorkType != null?'${json.encode(taskWorkType)}':'null'},"records": $records}';
  }
}

class Records {

  int createDate;
  int deleted;
  int excuteState;
  int id;
  int taskworkId;
  int updateDate;
  String actionFlag;
  String excuteDepartmentId;
  String excuteResult;
  String excuteUserId;
  String executeDepartmentName;
  String executeTime;
  String executeUserName;
  String flowJson;
  String flowTaskId;
  String flowTaskName;
  String flowTaskUserIds;
  String remark;

  Records.fromParams({this.createDate, this.deleted, this.excuteState, this.id, this.taskworkId, this.updateDate, this.actionFlag, this.excuteDepartmentId, this.excuteResult, this.excuteUserId, this.executeDepartmentName, this.executeTime, this.executeUserName, this.flowJson, this.flowTaskId, this.flowTaskName, this.flowTaskUserIds, this.remark});

  Records.fromJson(jsonRes) {
    createDate = jsonRes['createDate'];
    deleted = jsonRes['deleted'];
    excuteState = jsonRes['excuteState'];
    id = jsonRes['id'];
    taskworkId = jsonRes['taskworkId'];
    updateDate = jsonRes['updateDate'];
    actionFlag = jsonRes['actionFlag'];
    excuteDepartmentId = jsonRes['excuteDepartmentId'];
    excuteResult = jsonRes['excuteResult'];
    excuteUserId = jsonRes['excuteUserId'];
    executeDepartmentName = jsonRes['executeDepartmentName'];
    executeTime = jsonRes['executeTime'];
    executeUserName = jsonRes['executeUserName'];
    flowJson = jsonRes['flowJson'];
    flowTaskId = jsonRes['flowTaskId'];
    flowTaskName = jsonRes['flowTaskName'];
    flowTaskUserIds = jsonRes['flowTaskUserIds'];
    remark = jsonRes['remark'];
  }

  @override
  String toString() {
    return '{"createDate": $createDate,"deleted": $deleted,"excuteState": $excuteState,"id": $id,"taskworkId": $taskworkId,"updateDate": $updateDate,"actionFlag": ${actionFlag != null?'${json.encode(actionFlag)}':'null'},"excuteDepartmentId": ${excuteDepartmentId != null?'${json.encode(excuteDepartmentId)}':'null'},"excuteResult": ${excuteResult != null?'${json.encode(excuteResult)}':'null'},"excuteUserId": ${excuteUserId != null?'${json.encode(excuteUserId)}':'null'},"executeDepartmentName": ${executeDepartmentName != null?'${json.encode(executeDepartmentName)}':'null'},"executeTime": ${executeTime != null?'${json.encode(executeTime)}':'null'},"executeUserName": ${executeUserName != null?'${json.encode(executeUserName)}':'null'},"flowJson": ${flowJson != null?'${json.encode(flowJson)}':'null'},"flowTaskId": ${flowTaskId != null?'${json.encode(flowTaskId)}':'null'},"flowTaskName": ${flowTaskName != null?'${json.encode(flowTaskName)}':'null'},"flowTaskUserIds": ${flowTaskUserIds != null?'${json.encode(flowTaskUserIds)}':'null'},"remark": ${remark != null?'${json.encode(remark)}':'null'}}';
  }
}


