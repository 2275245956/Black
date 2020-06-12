import 'dart:convert' show json;

class TaskAddModel {

  List<TaskDetail> taskDetails;
  TaskInfo taskInfo;

  TaskAddModel.fromParams({this.taskDetails, this.taskInfo});

  factory TaskAddModel(jsonStr) => jsonStr == null ? null : jsonStr is String ? new TaskAddModel.fromJson(json.decode(jsonStr)) : new TaskAddModel.fromJson(jsonStr);

  TaskAddModel.fromJson(jsonRes) {
    taskDetails = jsonRes['taskDetails'] == null ? null : [];

    for (var taskDetailsItem in taskDetails == null ? [] : jsonRes['taskDetails']){
      taskDetails.add(taskDetailsItem == null ? null : new TaskDetail.fromJson(taskDetailsItem));
    }

    taskInfo = jsonRes['taskInfo'] == null ? null : new TaskInfo.fromJson(jsonRes['taskInfo']);
  }

  @override
  String toString() {
    return '{"taskDetails": $taskDetails,"taskInfo": $taskInfo}';
  }
}

class TaskInfo {

  int depth;
  int executorId;
  int feedbackNum;
  int id;
  int maxDepth;
  int publisher;
  int status;
  String config;
  String createDate;
  String executor;
  String factFinishTime;
  String finishTime;
  String isWarn;
  String orgCode;
  String publishTime;
  String publisherName;
  String remark;
  String title;
  String warnTime;

  TaskInfo.fromParams({this.depth, this.executorId, this.feedbackNum, this.id, this.maxDepth, this.publisher, this.status, this.config, this.createDate, this.executor, this.factFinishTime, this.finishTime, this.isWarn, this.orgCode, this.publishTime, this.publisherName, this.remark, this.title, this.warnTime});

  TaskInfo.fromJson(jsonRes) {
    depth = jsonRes['depth'];
    executorId = jsonRes['executorId'];
    feedbackNum = jsonRes['feedbackNum'];
    id = jsonRes['id'];
    maxDepth = jsonRes['maxDepth'];
    publisher = jsonRes['publisher'];
    status = jsonRes['status'];
    config = jsonRes['config'];
    createDate = jsonRes['createDate'];
    executor = jsonRes['executor'];
    factFinishTime = jsonRes['factFinishTime'];
    finishTime = jsonRes['finishTime'];
    isWarn = jsonRes['isWarn'];
    orgCode = jsonRes['orgCode'];
    publishTime = jsonRes['publishTime'];
    publisherName = jsonRes['publisherName'];
    remark = jsonRes['remark'];
    title = jsonRes['title'];
    warnTime = jsonRes['warnTime'];
  }

  @override
  String toString() {
    return '{"depth": $depth,"executorId": ${executor != null?'${json.encode(executor)}':'null'}Id,"feedbackNum": $feedbackNum,"id": $id,"maxDepth": $maxDepth,"publisher": $publisher,"status": $status,"config": ${config != null?'${json.encode(config)}':'null'},"createDate": ${createDate != null?'${json.encode(createDate)}':'null'},"executor": ${executor != null?'${json.encode(executor)}':'null'},"factFinishTime": ${factFinishTime != null?'${json.encode(factFinishTime)}':'null'},"finishTime": ${finishTime != null?'${json.encode(finishTime)}':'null'},"isWarn": ${isWarn != null?'${json.encode(isWarn)}':'null'},"orgCode": ${orgCode != null?'${json.encode(orgCode)}':'null'},"publishTime": ${publishTime != null?'${json.encode(publishTime)}':'null'},"publisherName": ${publisherName != null?'${json.encode(publisherName)}':'null'},"remark": ${remark != null?'${json.encode(remark)}':'null'},"title": ${title != null?'${json.encode(title)}':'null'},"warnTime": ${warnTime != null?'${json.encode(warnTime)}':'null'}}';
  }
}

class TaskDetail {

  int checkId;
  int id;
  int itemId;
  int pointId;
  int routeId;
  int status;
  String remark;

  TaskDetail.fromParams({this.checkId, this.id, this.itemId, this.pointId, this.routeId, this.status, this.remark});

  TaskDetail.fromJson(jsonRes) {
    checkId = jsonRes['checkId'];
    id = jsonRes['id'];
    itemId = jsonRes['itemId'];
    pointId = jsonRes['pointId'];
    routeId = jsonRes['routeId'];
    status = jsonRes['status'];
    remark = jsonRes['remark'];
  }

  @override
  String toString() {
    return '{"checkId": $checkId,"id": $id,"itemId": $itemId,"pointId": $pointId,"routeId": $routeId,"status": $status,"remark": ${remark != null?'${json.encode(remark)}':'null'}}';
  }
}

// =======================================================================
class TaskInfoForAdd {

  String title;
  num finishTime;
  String remark;
  String executor;
  String executorId;
//  num depth;
  num maxDepth;
  String isWarn;
  num warnTime;
  num checkId;
  List<TaskConfig> config;
//  String config;
//  List<TaskDetailForAdd> taskDetails;

  TaskInfoForAdd();

  TaskInfoForAdd.fromParams({this.maxDepth, this.executorId,  this.config, this.executor, this.finishTime, this.isWarn, this.remark, this.title, this.warnTime,this.checkId});

  TaskInfoForAdd.fromJson(jsonRes) {
    maxDepth = jsonRes['maxDepth'];
    executorId = jsonRes['executorId'];
    config = jsonRes['config'];
    executor = jsonRes['executor'];
    finishTime = jsonRes['finishTime'];
    isWarn = jsonRes['isWarn'];
    remark = jsonRes['remark'];
    title = jsonRes['title'];
    warnTime = jsonRes['warnTime'];
    checkId = jsonRes['checkId'];
  }

  @override
  String toString() {
    return '{"maxDepth": $maxDepth,"executorId": $executorId,'
        '"config": $config,'
        '"executor":${executor != null?'${json.encode(executor)}':'null'},'
        '"finishTime":$finishTime,'
        '"isWarn":${isWarn != null?'${json.encode(isWarn)}':'null'},"remark": ${remark != null?'${json.encode(remark)}':'null'},'
        '"title":${title != null?'${json.encode(title)}':'null'},"warnTime": $warnTime,"checkId": $checkId}';
  }
}

class TaskDetailForAdd {

  int checkId;
  int itemId;
  int pointId;
  int routeId;

  String limitDate;
  int dangerLevel;
  num routePointItemId;

  TaskDetailForAdd.fromParams({this.checkId,this.itemId, this.pointId, this.routeId,this.limitDate,this.dangerLevel,this.routePointItemId});

  TaskDetailForAdd.fromJson(jsonRes) {
    checkId = jsonRes['checkId'];
    itemId = jsonRes['itemId'];
    pointId = jsonRes['pointId'];
    routeId = jsonRes['routeId'];
    dangerLevel = jsonRes['dangerLevel'];
    limitDate = jsonRes['limitDate'];
    routePointItemId = jsonRes['routePointItemId'];
  }

  @override
  String toString() {
    return '{"checkId": $checkId,"itemId": $itemId,"pointId": $pointId,"routeId": $routeId},"limitDate": $limitDate},"dangerLevel": $dangerLevel}';
  }
}

class TaskConfig{
  num start;
  num end;
  String isMust;
  String name;

  TaskConfig.fromParams({this.start,this.end,this.isMust,this.name});

  @override
  String toString() {
    return '{"start": $start,"end": $end,"isMust": ${isMust != null?'${json.encode(isMust)}':'null'},"name": ${name != null?'${json.encode(name)}':'null'}}';
  }
}

class TaskErrorItem{
  String name; //检查项名称
  num checkId; //检查id
  String inputValue; //检查结果
  num pointId; //巡检点id
  num routeId; //路线id
  num itemId;  //检查项id
  bool selected = false;
  num route_point_item_id;
  String limitDate;
  int dangerLevel;

  TaskErrorItem.fromJson(jsonRes) {
    name = jsonRes['name'];
    checkId = jsonRes['checkId'];
    inputValue = jsonRes['inputValue'];
    pointId = jsonRes['pointId'];
    routeId = jsonRes['routeId'];
    itemId = jsonRes['itemId'];
    limitDate = jsonRes['limitDate'];
    dangerLevel = jsonRes['dangerLevel'];
    route_point_item_id = jsonRes['route_point_item_id'];
  }

  TaskErrorItem.fromParams({this.name,this.checkId,this.inputValue,
    this.pointId,this.routeId,this.itemId,this.limitDate,this.dangerLevel,this.route_point_item_id});
}


class TaskAdd {
  TaskInfoForAdd taskInfo;
  List<TaskDetailForAdd> taskDetails=List();

  @override
  String toString() {
    return '{"taskInfo": $taskInfo,"taskDetails": $taskDetails}';
  }
}



