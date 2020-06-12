import 'dart:convert' show json;

class ProssingInfo {

  int createDate;
  int feedbackTime;
  int id;
  int pictureNumber;
  int taskId;
  int userId;
  String message;
  String orgCode;
  String userName;
  String messageType;

  ProssingInfo.fromParams({this.createDate, this.feedbackTime, this.id, this.pictureNumber, this.taskId, this.userId, this.message, this.orgCode, this.userName, this.messageType});

  factory ProssingInfo(jsonStr) => jsonStr == null ? null : jsonStr is String ? new ProssingInfo.fromJson(json.decode(jsonStr)) : new ProssingInfo.fromJson(jsonStr);

  ProssingInfo.fromJson(jsonRes) {
    createDate = jsonRes['createDate'];
    feedbackTime = jsonRes['feedbackTime'];
    id = jsonRes['id'];
    pictureNumber = jsonRes['pictureNumber'];
    taskId = jsonRes['taskId'];
    userId = jsonRes['userId'];
    message = jsonRes['message'];
    orgCode = jsonRes['orgCode'];
    userName = jsonRes['userName'];
    messageType = jsonRes['messageType'];
  }

  @override
  String toString() {
    return '{"createDate": $createDate,"feedbackTime": $feedbackTime,"id": $id,"pictureNumber": $pictureNumber,"taskId": $taskId,"userId": $userId,"message": ${message != null?'${json.encode(message)}':'null'},"orgCode": ${orgCode != null?'${json.encode(orgCode)}':'null'},"userName": ${userName != null?'${json.encode(userName)}':'null'},"messageType": ${messageType != null?'${json.encode(messageType)}':'null'}}';
  }
}

