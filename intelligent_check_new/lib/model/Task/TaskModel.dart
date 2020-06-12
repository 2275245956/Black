import 'dart:convert' show json;

class TaskModel {

  List<FeedBack> feedback;
  List<TaskDetails> taskDetails;
  TaskInfo taskInfo;

  TaskModel.fromParams({this.feedback, this.taskDetails, this.taskInfo});

  factory TaskModel(jsonStr) => jsonStr == null ? null : jsonStr is String ? new TaskModel.fromJson(json.decode(jsonStr)) : new TaskModel.fromJson(jsonStr);

  TaskModel.fromJson(jsonRes) {
    feedback = jsonRes['feedback'] == null ? null : [];

    for (var feedbackItem in feedback == null ? [] : jsonRes['feedback']){
      feedback.add(feedbackItem == null ? null : new FeedBack.fromJson(feedbackItem));
    }

    taskDetails = jsonRes['taskDetails'] == null ? null : [];

    for (var taskDetailsItem in taskDetails == null ? [] : jsonRes['taskDetails']){
      taskDetails.add(taskDetailsItem == null ? null : new TaskDetails.fromJson(taskDetailsItem));
    }

    taskInfo = jsonRes['taskInfo'] == null ? null : new TaskInfo.fromJson(jsonRes['taskInfo']);
  }

  @override
  String toString() {
    return '{"feedback": $feedback,"taskDetails": $taskDetails,"taskInfo": $taskInfo}';
  }
}

class TaskInfo {

  Object factFinishTime;
  int createDate;
  int depth;
  String executorId;
  int feedbackNum;
  int finishTime;
  int id;
  int maxDepth;
  int publishTime;
  int publisher;
  int status;
  int warnTime;
  String config;
  String executor;
  String isWarn;
  String orgCode;
  String publisherName;
  String remark;
  String title;
  num checkId;
  bool isScan;

  TaskInfo();
  TaskInfo.fromParams({this.factFinishTime, this.createDate, this.depth, this.executorId, this.feedbackNum, this.finishTime, this.id, this.maxDepth, this.publishTime, this.publisher, this.status, this.warnTime, this.config, this.executor, this.isWarn, this.orgCode, this.publisherName, this.remark, this.title,this.checkId});

  TaskInfo.fromJson(jsonRes) {
    factFinishTime = jsonRes['factFinishTime'];
    createDate = jsonRes['createDate'];
    depth = jsonRes['depth'];
    executorId = jsonRes['executorId'];
    feedbackNum = jsonRes['feedbackNum'];
    finishTime = jsonRes['finishTime'];
    id = jsonRes['id'];
    maxDepth = jsonRes['maxDepth'];
    publishTime = jsonRes['publishTime'];
    publisher = jsonRes['publisher'];
    status = jsonRes['status'];
    warnTime = jsonRes['warnTime'];
    config = jsonRes['config'];
    executor = jsonRes['executor'];
    isWarn = jsonRes['isWarn'];
    orgCode = jsonRes['orgCode'];
    publisherName = jsonRes['publisherName'];
    remark = jsonRes['remark'];
    title = jsonRes['title'];
    checkId = jsonRes['checkId'];
    isScan = jsonRes['isScan'];
  }

  @override
  String toString() {
    return '{"factFinishTime": $factFinishTime,"createDate": $createDate,"depth": $depth,"executorId": ${executor != null?'${json.encode(executor)}':'null'}Id,"feedbackNum": $feedbackNum,"finishTime": $finishTime,"id": $id,"maxDepth": $maxDepth,"publishTime": $publishTime,"publisher": $publisher,"status": $status,"warnTime": $warnTime,"config": ${config != null?'${json.encode(config)}':'null'},"executor": ${executor != null?'${json.encode(executor)}':'null'},"isWarn": ${isWarn != null?'${json.encode(isWarn)}':'null'},"orgCode": ${orgCode != null?'${json.encode(orgCode)}':'null'},"publisherName": ${publisherName != null?'${json.encode(publisherName)}':'null'},"remark": ${remark != null?'${json.encode(remark)}':'null'},"title": ${title != null?'${json.encode(title)}':'null'}}';
  }
}

class TaskDetails {

  Object createDate;
  Object itemName;
  Object remark;
  int checkId;
  int id;
  int itemId;
  int pointId;
  int routeId;
  int status;
  int taskId;
  String pointName;
  String pointNo;
  TaskDetails();
  TaskDetails.fromParams({this.createDate, this.itemName, this.remark, this.checkId, this.id, this.itemId, this.pointId, this.routeId, this.status, this.taskId, this.pointName});

  TaskDetails.fromJson(jsonRes) {
    createDate = jsonRes['createDate'];
    itemName = jsonRes['itemName'];
    remark = jsonRes['remark'];
    checkId = jsonRes['checkId'];
    id = jsonRes['id'];
    itemId = jsonRes['itemId'];
    pointId = jsonRes['pointId'];
    routeId = jsonRes['routeId'];
    status = jsonRes['status'];
    taskId = jsonRes['taskId'];
    pointName = jsonRes['pointName'];
    pointNo = jsonRes['pointNo'];
  }

  @override
  String toString() {
    return '{"createDate": $createDate,"itemName": $itemName,"remark": $remark,"checkId": $checkId,"id": $id,"itemId": $itemId,"pointId": $pointId,"routeId": $routeId,"status": $status,"taskId": $taskId,"pointName": ${pointName != null?'${json.encode(pointName)}':'null'}}';
  }
}

class FeedBack {
  int id;
  int feedbackTime;
  int pictureNumber;
  int userId;
  String message;
  String userName;
  List<String> feedbackPics;

  FeedBack.fromParams({this.id, this.feedbackTime, this.pictureNumber, this.userId, this.message, this.userName, this.feedbackPics});

  FeedBack.fromJson(jsonRes) {
    id = jsonRes['id'];
    feedbackTime = jsonRes['feedbackTime'];
    pictureNumber = jsonRes['pictureNumber'];
    userId = jsonRes['userId'];
    message = jsonRes['message'];
    userName = jsonRes['userName'];
    feedbackPics = jsonRes['feedbackPics'] == null ? null : [];
    for (var imgbase64Item in feedbackPics == null ? [] : jsonRes['feedbackPics']){
      feedbackPics.add(imgbase64Item);
    }
  }

  @override
  String toString() {
    return '{"id": $id, "feedbackTime": $feedbackTime,"pictureNumber": $pictureNumber,"userId": $userId,"message": ${message != null?'${json.encode(message)}':'null'},"userName": ${userName != null?'${json.encode(userName)}':'null'},"feedbackPics": ${feedbackPics != null?'${json.encode(feedbackPics)}':'null'}}';
  }
}

