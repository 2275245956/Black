import 'dart:convert' show json;

//class ExtClass {
//
//  int createBy;
//  int createDate;
//  int creatorId;
//  int id;
//  int orderNo;
//  int parentId;
//  String name;
//  String orgCode;
//  String title;
//
//  ExtClass.fromParams({this.createBy, this.createDate, this.creatorId, this.id, this.orderNo, this.parentId, this.name, this.orgCode, this.title});
//
//  factory ExtClass(jsonStr) => jsonStr == null ? null : jsonStr is String ? new ExtClass.fromJson(json.decode(jsonStr)) : new ExtClass.fromJson(jsonStr);
//
//  ExtClass.fromJson(jsonRes) {
//    createBy = jsonRes['createBy'];
//    createDate = jsonRes['createDate'];
//    creatorId = jsonRes['creatorId'];
//    id = jsonRes['id'];
//    orderNo = jsonRes['orderNo'];
//    parentId = jsonRes['parentId'];
//    name = jsonRes['name'];
//    orgCode = jsonRes['orgCode'];
//    title = jsonRes['name'];
//  }
//
//  @override
//  String toString() {
//    return '{"createBy": $createBy,"createDate": $createDate,"creatorId": $creatorId,"id": $id,"orderNo": $orderNo,"parentId": $parentId,"name": ${name != null?'${json.encode(name)}':'null'},"title": ${title != null?'${json.encode(title)}':'null'},"orgCode": ${orgCode != null?'${json.encode(orgCode)}':'null'}}';
//  }
//}


class ExtClass {
  int id;
  int orderNo;
  String name;
  num pointId;
  bool hasDone=false;

  ExtClass.fromParams({this.id, this.orderNo, this.name, this.pointId});

  factory ExtClass(jsonStr) => jsonStr == null ? null : jsonStr is String ? new ExtClass.fromJson(json.decode(jsonStr)) : new ExtClass.fromJson(jsonStr);

  ExtClass.fromJson(jsonRes) {
    id = jsonRes['id'];
    orderNo = jsonRes['orderNo'];
    name = jsonRes['name'];
    pointId = jsonRes['pointId'];
  }

  @override
  String toString() {
    return '{"id": $id,"orderNo": $orderNo,"name": ${name != null?'${json.encode(name)}':'null'},"pointId": $pointId,"hasDone":$hasDone}';
  }
}