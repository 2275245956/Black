import 'dart:convert' show json;
//
//class SubscribeInfo{
//  List<CheckPlan> checks;
//  List<CheckPlan> plans;
//  List<CheckPlan> emails;
//}
//class CheckPlan {
//
//  String attribute3;
//  String attribute4;
//  String attribute5;
//  int createDate;
//  int id;
//  String attribute1;
//  String attribute2;
//  String msgType;
//  String orgCode;
//  String userId;
//  String userName;
//
//  CheckPlan.fromParams({this.attribute3, this.attribute4, this.attribute5, this.createDate, this.id, this.attribute1, this.attribute2, this.msgType, this.orgCode, this.userId, this.userName});
//
//  factory CheckPlan(jsonStr) => jsonStr == null ? null : jsonStr is String ? new CheckPlan.fromJson(json.decode(jsonStr)) : new CheckPlan.fromJson(jsonStr);
//
//  CheckPlan.fromJson(jsonRes) {
//    attribute3 = jsonRes['attribute3'];
//    attribute4 = jsonRes['attribute4'];
//    attribute5 = jsonRes['attribute5'];
//    createDate = jsonRes['createDate'];
//    id = jsonRes['id'];
//    attribute1 = jsonRes['attribute1'];
//    attribute2 = jsonRes['attribute2'];
//    msgType = jsonRes['msgType'];
//    orgCode = jsonRes['orgCode'];
//    userId = jsonRes['userId'];
//    userName = jsonRes['userName'];
//  }
//
//  @override
//  String toString() {
//    return '{"attribute3": ${attribute3 != null?'${json.encode(attribute3)}':'null'},"attribute4": ${attribute4 != null?'${json.encode(attribute4)}':'null'},"attribute5": ${attribute5 != null?'${json.encode(attribute5)}':'null'},"createDate": $createDate,"id": $id,"attribute1": ${attribute1 != null?'${json.encode(attribute1)}':'null'},"attribute2": ${attribute2 != null?'${json.encode(attribute2)}':'null'},"msgType": ${msgType != null?'${json.encode(msgType)}':'null'},"orgCode": ${orgCode != null?'${json.encode(orgCode)}':'null'},"userId": ${userId != null?'${json.encode(userId)}':'null'},"userName": ${userName != null?'${json.encode(userName)}':'null'}}';
//  }
//}
//
//class ItemInfo {
//
//  String code;
//  String message;
//  String ower;
//
//  ItemInfo.fromParams({this.code, this.message, this.ower});
//
//  factory ItemInfo(jsonStr) => jsonStr == null ? null : jsonStr is String ? new ItemInfo.fromJson(json.decode(jsonStr)) : new ItemInfo.fromJson(jsonStr);
//
//  ItemInfo.fromJson(jsonRes) {
//    code = jsonRes['code'];
//    message = jsonRes['message'];
//    ower = jsonRes['ower'];
//  }
//
//  @override
//  String toString() {
//    return '{"code": ${code != null?'${json.encode(code)}':'null'},"message": ${message != null?'${json.encode(message)}':'null'},"ower": ${ower != null?'${json.encode(ower)}':'null'}}';
//  }
//}



class SubscribeInfo {

  List<SubItem> check;
  List<SubItem> plan;
  List<SubItem> email;

  SubscribeInfo.fromParams({this.check,this.plan,this.email});

  factory SubscribeInfo(jsonStr) => jsonStr == null ? null : jsonStr is String ? new SubscribeInfo.fromJson(json.decode(jsonStr)) : new SubscribeInfo.fromJson(jsonStr);

  SubscribeInfo.fromJson(jsonRes) {
    check  = jsonRes['check'] == null ? null : [];

    for (var checkItem in check == null ? [] : jsonRes['check']){
      check.add(checkItem == null ? null : new SubItem.fromJson(checkItem));
    }

    plan  = jsonRes['plan'] == null ? null : [];

    for (var planItem in plan == null ? [] : jsonRes['plan']){
      plan.add(planItem == null ? null : new SubItem.fromJson(planItem));
    }

    email = jsonRes['email'] == null ? null : [];

    for (var emailItem in email == null ? [] : jsonRes['email']){
      email.add(emailItem == null ? null : new SubItem.fromJson(emailItem));
    }
  }

  @override
  String toString() {
    return '{"check": $check}';
  }
}

class SubItem {

  int createDate;
  int id;
  String attribute1;
  String attribute2;
  String attribute3;
  String attribute4;
  String attribute5;
  String msgType;
  String orgCode;
  String userId;
  String userName;

  SubItem.fromParams({this.createDate, this.id, this.attribute1, this.attribute2, this.attribute3, this.attribute4, this.attribute5, this.msgType, this.orgCode, this.userId, this.userName});

  SubItem.fromJson(jsonRes) {
    createDate = jsonRes['createDate'];
    id = jsonRes['id'];
    attribute1 = jsonRes['attribute1'];
    attribute2 = jsonRes['attribute2'];
    attribute3 = jsonRes['attribute3'];
    attribute4 = jsonRes['attribute4'];
    attribute5 = jsonRes['attribute5'];
    msgType = jsonRes['msgType'];
    orgCode = jsonRes['orgCode'];
    userId = jsonRes['userId'].toString();
    userName = jsonRes['userName'];
  }

  @override
  String toString() {
    return '{"createDate": $createDate,"id": $id,"attribute1": ${attribute1 != null?'${json.encode(attribute1)}':'null'},"attribute2": ${attribute2 != null?'${json.encode(attribute2)}':'null'},"attribute3": ${attribute3 != null?'${json.encode(attribute3)}':'null'},"attribute4": ${attribute4 != null?'${json.encode(attribute4)}':'null'},"attribute5": ${attribute5 != null?'${json.encode(attribute5)}':'null'},"msgType": ${msgType != null?'${json.encode(msgType)}':'null'},"orgCode": ${orgCode != null?'${json.encode(orgCode)}':'null'},"userId": ${userId != null?'${json.encode(userId)}':'null'},"userName": ${userName != null?'${json.encode(userName)}':'null'}}';
  }
}

