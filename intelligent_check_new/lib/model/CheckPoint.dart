import 'dart:convert' show json;

import 'offline/offline_plan_list_output.dart';

class CheckPoint {
  int id;
  int routeId;
  String departmentName;
  String fixed;
  String name;
  String pointName;
  String pointNo;
  String remark;
  String routeName;
  String userName;
  Point offlinePoint;

  CheckPoint.fromParams({this.id, this.routeId, this.departmentName, this.fixed, this.name, this.pointName, this.pointNo, this.remark, this.routeName, this.userName});

  factory CheckPoint(jsonStr) => jsonStr == null ? null : jsonStr is String ? new CheckPoint.fromJson(json.decode(jsonStr)) : new CheckPoint.fromJson(jsonStr);

  CheckPoint.fromJson(jsonRes) {
    id = jsonRes['id'];
    routeId = jsonRes['routeId'];
    departmentName = jsonRes['departmentName'];
    fixed = jsonRes['fixed'];
    name = jsonRes['name'];
    pointName = jsonRes['pointName'];
    pointNo = jsonRes['pointNo'];
    remark = jsonRes['remark'];
    routeName = jsonRes['routeName'];
    userName = jsonRes['userName'];
  }

  @override
  String toString() {
    return '{"id": $id,"routeId": $routeId,"departmentName": ${departmentName != null?'${json.encode(departmentName)}':'null'},"fixed": ${fixed != null?'${json.encode(fixed)}':'null'},"name": ${name != null?'${json.encode(name)}':'null'},"pointName": ${pointName != null?'${json.encode(pointName)}':'null'},"pointNo": ${pointNo != null?'${json.encode(pointNo)}':'null'},"remark": ${remark != null?'${json.encode(remark)}':'null'},"routeName": ${routeName != null?'${json.encode(routeName)}':'null'},"userName": ${userName != null?'${json.encode(userName)}':'null'}}';
  }
}



class QueryPoint {

  Object catalogName;
  Object classifyName;
  Object inputItemName;
  Object isFixed;
  Object routeName;
  Object shotNumber;
  int classifyId;
  int id;
  int routeId;
  String pointLevel;
  String name;
  String pointNo;

  QueryPoint.fromParams({this.pointLevel,this.catalogName, this.classifyName, this.inputItemName, this.isFixed, this.routeName, this.shotNumber, this.classifyId, this.id, this.routeId, this.name, this.pointNo});

  factory QueryPoint(jsonStr) => jsonStr == null ? null : jsonStr is String ? new QueryPoint.fromJson(json.decode(jsonStr)) : new QueryPoint.fromJson(jsonStr);

  QueryPoint.fromJson(jsonRes) {
    catalogName = jsonRes['catalogName'];
    classifyName = jsonRes['classifyName'];
    inputItemName = jsonRes['inputItemName'];
    isFixed = jsonRes['isFixed'];
    routeName = jsonRes['routeName'];
    shotNumber = jsonRes['shotNumber'];
    classifyId = jsonRes['classifyId'];
    id = jsonRes['id'];
    routeId = jsonRes['routeId'];
    name = jsonRes['name'];
    pointNo = jsonRes['pointNo'];
    pointLevel = jsonRes['pointLevel'];
  }

  @override
  String toString() {
    return '{"catalogName": $catalogName,"classifyName": $classifyName,"inputItemName": $inputItemName,"isFixed": $isFixed,"pointLevel": ${pointLevel != null?'${json.encode(pointLevel)}':'null'},"routeName": $routeName,"shotNumber": $shotNumber,"classifyId": $classifyId,"id": $id,"routeId": $routeId,"name": ${name != null?'${json.encode(name)}':'null'},"pointNo": ${pointNo != null?'${json.encode(pointNo)}':'null'}}';
  }
}




class PointLevelModel {

  Object createUserName;
  Object evaluateModelName;
  int createDate;
  int evaluateModelId;
  int id;
  int isAcceptable;
  int lower;
  int updateDate;
  int upper;
  String code;
  String creatorId;
  String describe;
  String level;
  String manageType;

  PointLevelModel.fromParams({this.createUserName, this.evaluateModelName, this.createDate, this.evaluateModelId, this.id, this.isAcceptable, this.lower, this.updateDate, this.upper, this.code, this.creatorId, this.describe, this.level, this.manageType});

  factory PointLevelModel(jsonStr) => jsonStr == null ? null : jsonStr is String ? new PointLevelModel.fromJson(json.decode(jsonStr)) : new PointLevelModel.fromJson(jsonStr);

  PointLevelModel.fromJson(jsonRes) {
    createUserName = jsonRes['createUserName'];
    evaluateModelName = jsonRes['evaluateModelName'];
    createDate = jsonRes['createDate'];
    evaluateModelId = jsonRes['evaluateModelId'];
    id = jsonRes['id'];
    isAcceptable = jsonRes['isAcceptable'];
    lower = jsonRes['lower'];
    updateDate = jsonRes['updateDate'];
    upper = jsonRes['upper'];
    code = jsonRes['code'];
    creatorId = jsonRes['creatorId'];
    describe = jsonRes['describe'];
    level = jsonRes['level'];
    manageType = jsonRes['manageType'];
  }

  @override
  String toString() {
    return '{"createUserName": $createUserName,"evaluateModelName": $evaluateModelName,"createDate": $createDate,"evaluateModelId": $evaluateModelId,"id": $id,"isAcceptable": $isAcceptable,"lower": $lower,"updateDate": $updateDate,"upper": $upper,"code": ${code != null?'${json.encode(code)}':'null'},"creatorId": ${creatorId != null?'${json.encode(creatorId)}':'null'},"describe": ${describe != null?'${json.encode(describe)}':'null'},"level": ${level != null?'${json.encode(level)}':'null'},"manageType": ${manageType != null?'${json.encode(manageType)}':'null'}}';
  }
}


