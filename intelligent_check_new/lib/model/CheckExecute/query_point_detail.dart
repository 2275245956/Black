import 'dart:convert' show json;


class QueryPointDetail{
  PointInfo pointInfo;
//  List<InputItems> inputItems;
  Map<String,List<InputItems>> inputItems = Map();
  List<Classify> classifies = List();
  List<Route> routs = List();
}

class PointInfo {
  int id;
  String departmentName;
  String fixed;
  String pointName;
  String pointNo;
  String remark;
  String routeName;
  String userName;

  PointInfo.fromParams({this.id, this.departmentName, this.fixed, this.pointName, this.pointNo, this.remark, this.routeName, this.userName});

  factory PointInfo(jsonStr) => jsonStr == null ? null : jsonStr is String ? new PointInfo.fromJson(json.decode(jsonStr)) : new PointInfo.fromJson(jsonStr);

  PointInfo.fromJson(jsonRes) {
    id = jsonRes['id'];
    departmentName = jsonRes['departmentName'];
    fixed = jsonRes['fixed'];
    pointName = jsonRes['pointName'];
    pointNo = jsonRes['pointNo'];
    remark = jsonRes['remark'];
    routeName = jsonRes['routeName'];
    userName = jsonRes['userName'];
  }

  @override
  String toString() {
    return '{"id": $id,"departmentName": ${departmentName != null?'${json.encode(departmentName)}':'null'},"fixed": ${fixed != null?'${json.encode(fixed)}':'null'},"pointName": ${pointName != null?'${json.encode(pointName)}':'null'},"pointNo": ${pointNo != null?'${json.encode(pointNo)}':'null'},"remark": ${remark != null?'${json.encode(remark)}':'null'},"routeName": ${routeName != null?'${json.encode(routeName)}':'null'},"userName": ${userName != null?'${json.encode(userName)}':'null'}}';
  }
}

class InputItems {

  int inputItemNO;
  int pointId;
  String inputItenName;

  InputItems.fromParams({this.inputItemNO, this.pointId, this.inputItenName});

  factory InputItems(jsonStr) => jsonStr == null ? null : jsonStr is String ? new InputItems.fromJson(json.decode(jsonStr)) : new InputItems.fromJson(jsonStr);

  InputItems.fromJson(jsonRes) {
    inputItemNO = jsonRes['inputItemNO'];
    pointId = jsonRes['pointId'];
    inputItenName = jsonRes['inputItenName'];
  }

  @override
  String toString() {
    return '{"inputItemNO": $inputItemNO,"pointId": $pointId,"inputItenName": ${inputItenName != null?'${json.encode(inputItenName)}':'null'}}';
  }
}

class Classify {

  int pointId;
  String classifyName;

  Classify.fromParams({this.pointId, this.classifyName});

  factory Classify(jsonStr) => jsonStr == null ? null : jsonStr is String ? new Classify.fromJson(json.decode(jsonStr)) : new Classify.fromJson(jsonStr);

  Classify.fromJson(jsonRes) {
    pointId = jsonRes['pointId'];
    classifyName = jsonRes['classifyName'];
  }

  @override
  String toString() {
    return '{"pointId": $pointId,"classifyName": ${classifyName != null?'${json.encode(classifyName)}':'null'}}';
  }
}

class Route {

  int pointId;
  String routeName;

  Route.fromParams({this.pointId, this.routeName});

  factory Route(jsonStr) => jsonStr == null ? null : jsonStr is String ? new Route.fromJson(json.decode(jsonStr)) : new Route.fromJson(jsonStr);

  Route.fromJson(jsonRes) {
    pointId = jsonRes['pointId'];
    routeName = jsonRes['routeName'];
  }

  @override
  String toString() {
    return '{"pointId": $pointId,"routeName": ${routeName != null?'${json.encode(routeName)}':'null'}}';
  }
}


/*固有风险点详情  添加    范文强*/

class InherentPointDetail {

  int pointId;
  bool offline;
  String pointLevel;
  String pointName;
  String pointNo;
  String pointType;
  String pointTypeName;
  List<EquipmentList> equipmentList;
  List<RiskFactorList> riskFactorList;

  InherentPointDetail.fromParams({this.pointTypeName,this.pointId, this.offline, this.pointLevel, this.pointName, this.pointNo, this.pointType, this.equipmentList, this.riskFactorList});

  factory InherentPointDetail(jsonStr) => jsonStr == null ? null : jsonStr is String ? new InherentPointDetail.fromJson(json.decode(jsonStr)) : new InherentPointDetail.fromJson(jsonStr);

  InherentPointDetail.fromJson(jsonRes) {
    pointId = jsonRes['pointId'];
    offline = jsonRes['offline'];
    pointLevel = jsonRes['pointLevel'];
    pointName = jsonRes['pointName'];
    pointNo = jsonRes['pointNo'];
    pointType = jsonRes['pointType'];
    pointTypeName = jsonRes['pointTypeName'];
    equipmentList = jsonRes['equipmentList'] == null ? null : [];

    for (var equipmentListItem in equipmentList == null ? [] : jsonRes['equipmentList']){
      equipmentList.add(equipmentListItem == null ? null : new EquipmentList.fromJson(equipmentListItem));
    }

    riskFactorList = jsonRes['riskFactorList'] == null ? null : [];

    for (var riskFactorListItem in riskFactorList == null ? [] : jsonRes['riskFactorList']){
      riskFactorList.add(riskFactorListItem == null ? null : new RiskFactorList.fromJson(riskFactorListItem));
    }
  }

  @override
  String toString() {
    return '{"pointId": $pointId,"pointTypeName": ${pointTypeName != null?'${json.encode(pointTypeName)}':'null'},"offline": $offline,"pointLevel": ${pointLevel != null?'${json.encode(pointLevel)}':'null'}"pointNo": ${pointNo != null?'${json.encode(pointNo)}':'null'},"pointType": ${pointType != null?'${json.encode(pointType)}':'null'},"equipmentList": $equipmentList,"riskFactorList": $riskFactorList}';
  }
}

class RiskFactorList {

  Object aftermathIds;
  Object controlObjectName;
  Object controlStatus;
  Object createDate;
  String creatorId;
  Object equipmentCode;
  Object equipmentDepartmentId;
  Object equipmentName;
  Object equipmentOrgCode;
  Object evaluateId;
  Object evaluateMethodNames;
  Object evaluateUserNames;
  Object flowOrderNo;
  Object hazardSourceClassifyId;
  Object identificationMethodIds;
  Object identificationMethodNames;
  Object regionId;
  Object rfValue;
  Object riskResourceName;
  Object riskSourceId;
  Object startFlowTime;
  Object startFlowUserId;
  Object status;
  Object type;
  Object updateDate;
  Object userIds;
  Object userNames;
  Object workshopSection;
  int controlObjectId;
  int id;
  String name;
  String rfLevel;

  RiskFactorList.fromParams({this.aftermathIds, this.controlObjectName, this.controlStatus, this.createDate, this.creatorId, this.equipmentCode, this.equipmentDepartmentId, this.equipmentName, this.equipmentOrgCode, this.evaluateId, this.evaluateMethodNames, this.evaluateUserNames, this.flowOrderNo, this.hazardSourceClassifyId, this.identificationMethodIds, this.identificationMethodNames, this.regionId, this.rfValue, this.riskResourceName, this.riskSourceId, this.startFlowTime, this.startFlowUserId, this.status, this.type, this.updateDate, this.userIds, this.userNames, this.workshopSection, this.controlObjectId, this.id, this.name, this.rfLevel});

  RiskFactorList.fromJson(jsonRes) {
    aftermathIds = jsonRes['aftermathIds'];
    controlObjectName = jsonRes['controlObjectName'];
    controlStatus = jsonRes['controlStatus'];
    createDate = jsonRes['createDate'];
    creatorId = jsonRes['creatorId'];
    equipmentCode = jsonRes['equipmentCode'];
    equipmentDepartmentId = jsonRes['equipmentDepartmentId'];
    equipmentName = jsonRes['equipmentName'];
    equipmentOrgCode = jsonRes['equipmentOrgCode'];
    evaluateId = jsonRes['evaluateId'];
    evaluateMethodNames = jsonRes['evaluateMethodNames'];
    evaluateUserNames = jsonRes['evaluateUserNames'];
    flowOrderNo = jsonRes['flowOrderNo'];
    hazardSourceClassifyId = jsonRes['hazardSourceClassifyId'];
    identificationMethodIds = jsonRes['identificationMethodIds'];
    identificationMethodNames = jsonRes['identificationMethodNames'];
    regionId = jsonRes['regionId'];
    rfValue = jsonRes['rfValue'];
    riskResourceName = jsonRes['riskResourceName'];
    riskSourceId = jsonRes['riskSourceId'];
    startFlowTime = jsonRes['startFlowTime'];
    startFlowUserId = jsonRes['startFlowUserId'];
    status = jsonRes['status'];
    type = jsonRes['type'];
    updateDate = jsonRes['updateDate'];
    userIds = jsonRes['userIds'];
    userNames = jsonRes['userNames'];
    workshopSection = jsonRes['workshopSection'];
    controlObjectId = jsonRes['controlObjectId'];
    id = jsonRes['id'];
    name = jsonRes['name'];
    rfLevel = jsonRes['rfLevel'];
  }

  @override
  String toString() {
    return '{"aftermathIds": $aftermathIds,"controlObjectName": $controlObjectName,"controlStatus": $controlStatus,"createDate": $createDate,"creatorId": ${creatorId != null?'${json.encode(creatorId)}':'null'},"equipmentCode": $equipmentCode,"equipmentDepartmentId": $equipmentDepartmentId,"equipmentName": $equipmentName,"equipmentOrgCode": $equipmentOrgCode,"evaluateId": $evaluateId,"evaluateMethodNames": $evaluateMethodNames,"evaluateUserNames": $evaluateUserNames,"flowOrderNo": $flowOrderNo,"hazardSourceClassifyId": $hazardSourceClassifyId,"identificationMethodIds": $identificationMethodIds,"identificationMethodNames": $identificationMethodNames,"regionId": $regionId,"rfValue": $rfValue,"riskResourceName": $riskResourceName,"riskSourceId": $riskSourceId,"startFlowTime": $startFlowTime,"startFlowUserId": $startFlowUserId,"status": $status,"type": $type,"updateDate": $updateDate,"userIds": $userIds,"userNames": $userNames,"workshopSection": $workshopSection,"controlObjectId": $controlObjectId,"id": $id,"name": ${name != null?'${json.encode(name)}':'null'},"rfLevel": ${rfLevel != null?'${json.encode(rfLevel)}':'null'}}';
  }
}

class EquipmentList {

  Object createDate;
  int creatorId;
  int departmentId;
  int floor3d;
  Object height;
  Object orgCode;
  Object position3d;
  Object regionId;
  Object type;
  int workshopSection;
  int id;
  String code;
  String name;

  EquipmentList.fromParams({this.createDate, this.creatorId, this.departmentId, this.floor3d, this.height, this.orgCode, this.position3d, this.regionId, this.type, this.workshopSection, this.id, this.code, this.name});

  EquipmentList.fromJson(jsonRes) {
    createDate = jsonRes['createDate'];
    creatorId = jsonRes['creatorId'];
    departmentId = jsonRes['departmentId'];
    floor3d = jsonRes['floor3d'];
    height = jsonRes['height'];
    orgCode = jsonRes['orgCode'];
    position3d = jsonRes['position3d'];
    regionId = jsonRes['regionId'];
    type = jsonRes['type'];
    workshopSection = jsonRes['workshopSection'];
    id = jsonRes['id'];
    code = jsonRes['code'];
    name = jsonRes['name'];
  }

  @override
  String toString() {
    return '{"createDate": $createDate,"creatorId": $creatorId,"departmentId": $departmentId,"floor3d": $floor3d,"height": $height,"orgCode": $orgCode,"position3d": $position3d,"regionId": $regionId,"type": $type,"workshopSection": $workshopSection,"id": ${id != null?'${json.encode(id)}':'null'},"code": ${code != null?'${json.encode(code)}':'null'},"name": ${name != null?'${json.encode(name)}':'null'}}';
  }
}


class EquipmentDetail {

  String equipmentCode;
  String equipmentDepartmentName;
  String equipmentName;
  String equipmentRegionName;
  String equipmentUserName;
  String equipmentWorkshopSection;
  List<dynamic> riskFactorList;

  EquipmentDetail.fromParams({this.equipmentCode, this.equipmentDepartmentName, this.equipmentName, this.equipmentRegionName, this.equipmentUserName, this.equipmentWorkshopSection, this.riskFactorList});

  factory EquipmentDetail(jsonStr) => jsonStr == null ? null : jsonStr is String ? new EquipmentDetail.fromJson(json.decode(jsonStr)) : new EquipmentDetail.fromJson(jsonStr);

  EquipmentDetail.fromJson(jsonRes) {
    equipmentCode = jsonRes['equipmentCode'];
    equipmentDepartmentName = jsonRes['equipmentDepartmentName'];
    equipmentName = jsonRes['equipmentName'];
    equipmentRegionName = jsonRes['equipmentRegionName'];
    equipmentUserName = jsonRes['equipmentUserName'];
    equipmentWorkshopSection = jsonRes['equipmentWorkshopSection'];
    riskFactorList = jsonRes['riskFactorList'] == null ? null : [];

    for (var riskFactorListItem in riskFactorList == null ? [] : jsonRes['riskFactorList']){
      riskFactorList.add(riskFactorListItem);
    }
  }

  @override
  String toString() {
    return '{"equipmentCode": ${equipmentCode != null?'${json.encode(equipmentCode)}':'null'},"equipmentDepartmentName": ${equipmentDepartmentName != null?'${json.encode(equipmentDepartmentName)}':'null'},"equipmentName": ${equipmentName != null?'${json.encode(equipmentName)}':'null'},"equipmentRegionName": ${equipmentRegionName != null?'${json.encode(equipmentRegionName)}':'null'},"equipmentUserName": ${equipmentUserName != null?'${json.encode(equipmentUserName)}':'null'},"equipmentWorkshopSection": ${equipmentWorkshopSection != null?'${json.encode(equipmentWorkshopSection)}':'null'},"riskFactorList": $riskFactorList}';
  }
}



class RiskFactorsDetail {

  String evaluateMethodNames;
  String evaluateUserNames;
  String identificationMethodNames;
  String riskFactorLevel;
  String riskFactorName;
  String riskSourceName;
  String userNames;
  String hazardSourceClassifyName;
  List<AfterMathList> aftermathList;
  List<ControlMrasureList> controlMeasureList;

  RiskFactorsDetail.fromParams({this.hazardSourceClassifyName,this.evaluateMethodNames, this.evaluateUserNames, this.identificationMethodNames, this.riskFactorLevel, this.riskFactorName, this.riskSourceName, this.userNames, this.aftermathList, this.controlMeasureList});

  factory RiskFactorsDetail(jsonStr) => jsonStr == null ? null : jsonStr is String ? new RiskFactorsDetail.fromJson(json.decode(jsonStr)) : new RiskFactorsDetail.fromJson(jsonStr);

  RiskFactorsDetail.fromJson(jsonRes) {
    evaluateMethodNames = jsonRes['evaluateMethodNames'];
    hazardSourceClassifyName=jsonRes["hazardSourceClassifyName"];
    evaluateUserNames = jsonRes['evaluateUserNames'];
    identificationMethodNames = jsonRes['identificationMethodNames'];
    riskFactorLevel = jsonRes['riskFactorLevel'];
    riskFactorName = jsonRes['riskFactorName'];
    riskSourceName = jsonRes['riskSourceName'];
    userNames = jsonRes['userNames'];
    aftermathList = jsonRes['aftermathList'] == null ? null : [];

    for (var aftermathListItem in aftermathList == null ? [] : jsonRes['aftermathList']){
      aftermathList.add(aftermathListItem == null ? null : new AfterMathList.fromJson(aftermathListItem));
    }

    controlMeasureList = jsonRes['controlMeasureList'] == null ? null : [];

    for (var controlMeasureListItem in controlMeasureList == null ? [] : jsonRes['controlMeasureList']){
      controlMeasureList.add(controlMeasureListItem == null ? null : new ControlMrasureList.fromJson(controlMeasureListItem));
    }
  }

  @override
  String toString() {
    return '{"evaluateMethodNames": ${evaluateMethodNames != null?'${json.encode(evaluateMethodNames)}':'null'},"evaluateUserNames": ${evaluateUserNames != null?'${json.encode(evaluateUserNames)}':'null'},"identificationMethodNames": ${identificationMethodNames != null?'${json.encode(identificationMethodNames)}':'null'},"riskFactorLevel": ${riskFactorLevel != null?'${json.encode(riskFactorLevel)}':'null'},"riskFactorName": ${riskFactorName != null?'${json.encode(riskFactorName)}':'null'},"riskSourceName": ${riskSourceName != null?'${json.encode(riskSourceName)}':'null'},"userNames": ${userNames != null?'${json.encode(userNames)}':'null'},"aftermathList": $aftermathList,"controlMeasureList": $controlMeasureList}';
  }
}
class ControlMrasureList {

  Object createDate;
  Object creatorId;
  Object orgCode;
  Object updateDate;
  int id;
  String category;
  String name;
  String type;

  ControlMrasureList.fromParams({this.createDate, this.creatorId, this.orgCode, this.updateDate, this.id, this.category, this.name, this.type});

  ControlMrasureList.fromJson(jsonRes) {
    createDate = jsonRes['createDate'];
    creatorId = jsonRes['creatorId'];
    orgCode = jsonRes['orgCode'];
    updateDate = jsonRes['updateDate'];
    id = jsonRes['id'];
    category = jsonRes['category'];
    name = jsonRes['name'];
    type = jsonRes['type'];
  }

  @override
  String toString() {
    return '{"createDate": $createDate,"creatorId": $creatorId,"orgCode": $orgCode,"updateDate": $updateDate,"id": $id,"category": ${category != null?'${json.encode(category)}':'null'},"name": ${name != null?'${json.encode(name)}':'null'},"type": ${type != null?'${json.encode(type)}':'null'}}';
  }
}
class AfterMathList {

  Object createDate;
  Object creatorId;
  Object orgCode;
  Object updateDate;
  int id;
  String describe;
  String name;

  AfterMathList.fromParams({this.createDate, this.creatorId, this.orgCode, this.updateDate, this.id, this.describe, this.name});

  AfterMathList.fromJson(jsonRes) {
    createDate = jsonRes['createDate'];
    creatorId = jsonRes['creatorId'];
    orgCode = jsonRes['orgCode'];
    updateDate = jsonRes['updateDate'];
    id = jsonRes['id'];
    describe = jsonRes['describe'];
    name = jsonRes['name'];
  }

  @override
  String toString() {
    return '{"createDate": $createDate,"creatorId": $creatorId,"orgCode": $orgCode,"updateDate": $updateDate,"id": $id,"describe": ${describe != null?'${json.encode(describe)}':'null'},"name": ${name != null?'${json.encode(name)}':'null'}}';
  }
}






