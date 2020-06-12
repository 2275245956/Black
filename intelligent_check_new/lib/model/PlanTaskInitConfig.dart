import 'dart:convert' show json;

import 'package:intelligent_check_new/model/CheckItem.dart';
import 'package:intelligent_check_new/model/ExtClass.dart';

class PlanTaskInitConfig {

  List<CheckItem> checkItem = List();
  List<ExtClass> extClass = List();
  PlanTask planTask;
  CheckPoint point;
  String errorMsg;

  PlanTaskInitConfig.fromParams({
    this.checkItem
    , this.extClass
    , this.planTask
    , this.point
    , this.errorMsg
  });

  factory PlanTaskInitConfig(jsonStr) => jsonStr == null ? null : jsonStr is String ? new PlanTaskInitConfig.fromJson(json.decode(jsonStr)) : new PlanTaskInitConfig.fromJson(jsonStr);

  PlanTaskInitConfig.fromJson(jsonRes) {
  checkItem = jsonRes['checkItem'] == null ? null : [];

  for (var checkItemItem in checkItem == null ? [] : jsonRes['checkItem']){
  checkItem.add(checkItemItem == null ? null : new CheckItem.fromJson(checkItemItem));
  }

  extClass = jsonRes['class'] == null ? null : [];

  for (var classItem in extClass == null ? [] : jsonRes['class']){
    extClass.add(classItem == null ? null : new ExtClass.fromJson(classItem));
  }

  planTask = jsonRes['planTask'] == null ? null : new PlanTask.fromJson(jsonRes['planTask']);
  point = jsonRes['point'] == null ? null : new CheckPoint.fromJson(jsonRes['point']);
  errorMsg = jsonRes['errorMsg'];
  }

  @override
  String toString() {
  return '{"checkItem": $checkItem,"class": $extClass,"planTask": $planTask,"point": $point}';
  }
}

//class CheckPoint {
//  int lastUpdateTime;
//  String status;
//  int catalogId;
//  int chargeDeptId;
//  int chargePersonId;
//  String createDate;
//  int creatorId;
//  int distance;
//  int fixedShot;
//  int id;
//  int shotMaxNumber;
//  int shotMinNumber;
//  bool isDelete;
//  bool offline;
//  String address;
//  String coordinates;
//  String extendJson;
//  String isFixed;
//  String isScore;
//  String latitude;
//  String level;
//  String longitude;
//  String name;
//  String orgCode;
//  String pointNo;
//  String remark;
//  String routeId;
//  String routeName;
//  String saveGps;
//  String usuallyShot;
//
//  CheckPoint.fromParams({
//    this.lastUpdateTime,
//    this.status,
//    this.catalogId,
//    this.chargeDeptId,
//    this.chargePersonId,
//    this.createDate,
//    this.creatorId,
//    this.distance,
//    this.fixedShot,
//    this.id,
//    this.shotMaxNumber,
//    this.shotMinNumber,
//    this.isDelete,
//    this.offline,
//    this.address,
//    this.coordinates,
//    this.extendJson,
//    this.isFixed,
//    this.isScore,
//    this.latitude,
//    this.level,
//    this.longitude,
//    this.name,
//    this.orgCode,
//    this.pointNo,
//    this.remark,
//    this.routeId,
//    this.routeName,
//    this.saveGps,
//    this.usuallyShot
//  });
//
//  CheckPoint.fromJson(jsonRes) {
//    lastUpdateTime = jsonRes['lastUpdateTime'];
//    status = jsonRes['status'];
//    catalogId = jsonRes['catalogId'];
//    chargeDeptId = jsonRes['chargeDeptId'];
//    chargePersonId = jsonRes['chargePersonId'];
//    createDate = jsonRes['createDate'];
//    creatorId = jsonRes['creatorId'];
//    distance = jsonRes['distance'];
//    fixedShot = jsonRes['fixedShot'];
//    id = jsonRes['id'];
//    shotMaxNumber = jsonRes['shotMaxNumber'];
//    shotMinNumber = jsonRes['shotMinNumber'];
//    isDelete = jsonRes['isDelete'];
//    offline = jsonRes['offline'];
//    address = jsonRes['address'];
//    coordinates = jsonRes['coordinates'];
//    extendJson = jsonRes['extendJson'];
//    isFixed = jsonRes['isFixed'];
//    isScore = jsonRes['isScore'];
//    latitude = jsonRes['latitude'];
//    level = jsonRes['level'];
//    longitude = jsonRes['longitude'];
//    name = jsonRes['name'];
//    orgCode = jsonRes['orgCode'];
//    pointNo = jsonRes['pointNo'];
//    remark = jsonRes['remark'];
//    routeId = jsonRes['routeId'];
//    routeName = jsonRes['routeName'];
//    saveGps = jsonRes['saveGps'];
//    usuallyShot = jsonRes['usuallyShot'];
//  }
//
//  @override
//  String toString() {
//    return '{"lastUpdateTime": $lastUpdateTime,"status": ${status != null?'${json.encode(status)}':'null'},"catalogId": $catalogId,"chargeDeptId": $chargeDeptId,"chargePersonId": $chargePersonId,"createDate": $createDate,"creatorId": $creatorId,"distance": $distance,"fixedShot": $fixedShot,"id": $id,"shotMaxNumber": $shotMaxNumber,"shotMinNumber": $shotMinNumber,"isDelete": $isDelete,"offline": $offline,"address": ${address != null?'${json.encode(address)}':'null'},"coordinates": ${coordinates != null?'${json.encode(coordinates)}':'null'},"extendJson": ${extendJson != null?'${json.encode(extendJson)}':'null'},"isFixed": ${isFixed != null?'${json.encode(isFixed)}':'null'},"isScore": ${isScore != null?'${json.encode(isScore)}':'null'},"latitude": ${latitude != null?'${json.encode(latitude)}':'null'},"level": ${level != null?'${json.encode(level)}':'null'},"longitude": ${longitude != null?'${json.encode(longitude)}':'null'},"name": ${name != null?'${json.encode(name)}':'null'},"orgCode": ${orgCode != null?'${json.encode(orgCode)}':'null'},"pointNo": ${pointNo != null?'${json.encode(pointNo)}':'null'},"remark": ${remark != null?'${json.encode(remark)}':'null'},"routeId": ${routeId != null?'${json.encode(routeId)}':'null'},"routeName": ${routeName != null?'${json.encode(routeName)}':'null'},"saveGps": ${saveGps != null?'${json.encode(saveGps)}':'null'},"usuallyShot": ${usuallyShot != null?'${json.encode(usuallyShot)}':'null'}}';
//  }
//}

class CheckPoint {

  Object address;
  Object chargePersonId;
  Object extendJson;
  Object latitude;
  Object level;
  int longitude;
  Object remark;
  int catalogId;
  String chargeDeptId;
  int createDate;
  int distance;
  int fixedShot;
  int floor;
  int id;
  int lastUpdateTime;
//  String lastUpdateTime;
  int shotMaxNumber;
  int shotMinNumber;
  bool isDelete;
  bool isIndoor;
  bool offline;
  String coordinates;
  String creatorId;
  String isFixed;
  String isScore;
  String name;
  String orgCode;
  String originalId;
  String pointNo;
  String routeId;
  String routeName;
  String saveGps;
  String status;
  String usuallyShot;

  CheckPoint.fromParams({this.address, this.chargePersonId, this.extendJson, this.latitude, this.level, this.longitude, this.remark, this.catalogId, this.chargeDeptId, this.createDate, this.distance, this.fixedShot, this.floor, this.id, this.lastUpdateTime, this.shotMaxNumber, this.shotMinNumber, this.isDelete, this.isIndoor, this.offline, this.coordinates, this.creatorId, this.isFixed, this.isScore, this.name, this.orgCode, this.originalId, this.pointNo, this.routeId, this.routeName, this.saveGps, this.status, this.usuallyShot});

  factory CheckPoint(jsonStr) => jsonStr == null ? null : jsonStr is String ? new CheckPoint.fromJson(json.decode(jsonStr)) : new CheckPoint.fromJson(jsonStr);

  CheckPoint.fromJson(jsonRes) {
    address = jsonRes['address'];
    chargePersonId = jsonRes['chargePersonId'];
    extendJson = jsonRes['extendJson'];
    latitude = jsonRes['latitude'];
    level = jsonRes['level'];
    longitude = jsonRes['longitude'];
    remark = jsonRes['remark'];
    catalogId = jsonRes['catalogId'];
    chargeDeptId = jsonRes['chargeDeptId'].toString();
    createDate = jsonRes['createDate'];
    distance = jsonRes['distance'];
    fixedShot = jsonRes['fixedShot'];
    floor = jsonRes['floor'];
    id = jsonRes['id'];
    lastUpdateTime = jsonRes['lastUpdateTime'];
    shotMaxNumber = jsonRes['shotMaxNumber'];
    shotMinNumber = jsonRes['shotMinNumber'];
    isDelete = jsonRes['isDelete'];
    isIndoor = jsonRes['isIndoor'];
    offline = jsonRes['offline'];
    coordinates = jsonRes['coordinates'];
    creatorId = jsonRes['creatorId'];
    isFixed = jsonRes['isFixed'];
    isScore = jsonRes['isScore'];
    name = jsonRes['name'];
    orgCode = jsonRes['orgCode'];
    originalId = jsonRes['originalId'];
    pointNo = jsonRes['pointNo'];
    routeId = jsonRes['routeId'];
    routeName = jsonRes['routeName'];
    saveGps = jsonRes['saveGps'];
    status = jsonRes['status'];
    usuallyShot = jsonRes['usuallyShot'];
  }

  @override
  String toString() {
    return '{"address": $address,"chargePersonId": $chargePersonId,"extendJson": $extendJson,"latitude": $latitude,"level": ${level != null?'${json.encode(level)}':'null'},"longitude": $longitude,"remark": $remark,"catalogId": $catalogId,"chargeDeptId": $chargeDeptId,"createDate": $createDate,"distance": $distance,"fixedShot": $fixedShot,"floor": ${floor != null?'${json.encode(floor)}':'null'},"id": $id,"lastUpdateTime": $lastUpdateTime,"shotMaxNumber": $shotMaxNumber,"shotMinNumber": $shotMinNumber,"isDelete": $isDelete,"isIndoor": $isIndoor,"offline": ${offline != null?'${json.encode(offline)}':'null'},"coordinates": ${coordinates != null?'${json.encode(coordinates)}':'null'},"creatorId": ${creatorId != null?'${json.encode(creatorId)}':'null'},"isFixed": ${isFixed != null?'${json.encode(isFixed)}':'null'},"isScore": ${isScore != null?'${json.encode(isScore)}':'null'},"name": ${name != null?'${json.encode(name)}':'null'},"orgCode": ${orgCode != null?'${json.encode(orgCode)}':'null'},"originalId": ${originalId != null?'${json.encode(originalId)}':'null'},"pointNo": ${pointNo != null?'${json.encode(pointNo)}':'null'},"routeId": ${routeId != null?'${json.encode(routeId)}':'null'},"routeName": ${routeName != null?'${json.encode(routeName)}':'null'},"saveGps": ${saveGps != null?'${json.encode(saveGps)}':'null'},"status": ${status != null?'${json.encode(status)}':'null'},"usuallyShot": ${usuallyShot != null?'${json.encode(usuallyShot)}':'null'}}';
  }
}



class PlanTask {

  //int beginTime;
  String beginTime;
//  int endTime;
  String endTime;
  int planTaskDetailId;
  int shotMaxNumber;
  int shotMinNumber;
  String planName;
  String pointName;
  String pointNo;

  PlanTask.fromParams({this.beginTime, this.endTime, this.planTaskDetailId, this.shotMaxNumber, this.shotMinNumber, this.planName, this.pointName, this.pointNo});

  PlanTask.fromJson(jsonRes) {
    beginTime = jsonRes['beginTime'].toString();
    endTime = jsonRes['endTime'].toString();
    planTaskDetailId = jsonRes['planTaskDetailId'];
    shotMaxNumber = jsonRes['shotMaxNumber'];
    shotMinNumber = jsonRes['shotMinNumber'];
    planName = jsonRes['planName'];
    pointName = jsonRes['pointName'];
    pointNo = jsonRes['pointNo'];
  }

  @override
  String toString() {
    return '{"beginTime": $beginTime,"endTime": $endTime,"planTaskDetailId": $planTaskDetailId,"shotMaxNumber": $shotMaxNumber,"shotMinNumber": $shotMinNumber,"planName": ${planName != null?'${json.encode(planName)}':'null'},"pointName": ${pointName != null?'${json.encode(pointName)}':'null'},"pointNo": ${pointNo != null?'${json.encode(pointNo)}':'null'}}';
  }
}