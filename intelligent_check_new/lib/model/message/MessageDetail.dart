import 'dart:convert' show json;


class MessageDetail {

  String createBy;
  String fixedTime;
  String pushBody;
  String targetTel;
  int createDate;
  int id;
  int relationId;
  int sendTime;
  int status;
  bool isImmediately;
  bool isRead;
  String body;
  String msgType;
  String orgCode;
  String title;
  String userId;

  MessageDetail.fromParams({this.createBy, this.fixedTime, this.pushBody, this.targetTel, this.createDate, this.id, this.relationId, this.sendTime, this.status, this.isImmediately, this.isRead, this.body, this.msgType, this.orgCode, this.title, this.userId});

  factory MessageDetail(jsonStr) => jsonStr == null ? null : jsonStr is String ? new MessageDetail.fromJson(json.decode(jsonStr)) : new MessageDetail.fromJson(jsonStr);

  MessageDetail.fromJson(jsonRes) {
    createBy = jsonRes['createBy'];
    fixedTime = jsonRes['fixedTime'].toString();
    pushBody = jsonRes['pushBody'];
    targetTel = jsonRes['targetTel'];
    createDate = jsonRes['createDate'];
    id = jsonRes['id'];
    relationId = jsonRes['relationId'];
    sendTime = jsonRes['sendTime'];
    status = jsonRes['status'];
    isImmediately = jsonRes['isImmediately'];
    isRead = jsonRes['isRead'];
    body = jsonRes['body'];
    msgType = jsonRes['msgType'];
    orgCode = jsonRes['orgCode'];
    title = jsonRes['title'];
    userId = jsonRes['userId'];
  }

  @override
  String toString() {
    return '{"createBy": ${createBy != null?'${json.encode(createBy)}':'null'},"fixedTime": ${fixedTime != null?'${json.encode(fixedTime)}':'null'},"pushBody": ${pushBody != null?'${json.encode(pushBody)}':'null'},"targetTel": ${targetTel != null?'${json.encode(targetTel)}':'null'},"createDate": $createDate,"id": $id,"relationId": $relationId,"sendTime": $sendTime,"status": $status,"isImmediately": $isImmediately,"isRead": $isRead,"body": ${body != null?'${json.encode(body)}':'null'},"msgType": ${msgType != null?'${json.encode(msgType)}':'null'},"orgCode": ${orgCode != null?'${json.encode(orgCode)}':'null'},"title": ${title != null?'${json.encode(title)}':'null'},"userId": ${userId != null?'${json.encode(userId)}':'null'}}';
  }
}

