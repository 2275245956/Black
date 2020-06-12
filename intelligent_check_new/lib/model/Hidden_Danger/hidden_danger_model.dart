import 'dart:convert' show json;

class HiddenDangerModel {

  int dangerId;
  String dangerName;
  String discovererUserName;
  int  level;
  String levelDesc;
  String limitDesc;
  String stateDesc;
  int state;
  int overtimeState;


  HiddenDangerModel.fromParams({this.dangerId, this.dangerName, this.discovererUserName, this.level, this.limitDesc, this.stateDesc,this.levelDesc,this.state,this.overtimeState});

  factory HiddenDangerModel(jsonStr) => jsonStr == null ? null : jsonStr is String ? new HiddenDangerModel.fromJson(json.decode(jsonStr)) : new HiddenDangerModel.fromJson(jsonStr);

  HiddenDangerModel.fromJson(jsonRes) {
    dangerId = jsonRes['dangerId'];
    dangerName = jsonRes['dangerName'];
    discovererUserName = jsonRes['discovererUserName'];
    level = jsonRes['level'];
    limitDesc = jsonRes['limitDesc'];
    stateDesc = jsonRes['stateDesc'];
    levelDesc = jsonRes['levelDesc'];
    state = jsonRes['state'];
    overtimeState = jsonRes['overtimeState'];
  }

  @override
  String toString() {
    return '{"dangerId": $dangerId,"dangerName": ${dangerName != null?'${json.encode(dangerName)}':'null'},"discovererUserName": ${discovererUserName != null?'${json.encode(discovererUserName)}':'null'},"level": ${level != null?'${json.encode(level)}':'null'},"limitDesc": ${limitDesc != null?'${json.encode(limitDesc)}':'null'},"stateDesc": ${stateDesc != null?'${json.encode(stateDesc)}':'null'},"stateDesc": ${levelDesc != null?'${json.encode(levelDesc)}':'null'},"state": $state,"overtimeState":$overtimeState}}';
  }
}

///请求传值
class HiddenDangerFilter{

  int belongType;
  int dangerLevel;
  int dangerState;
  int pageIndex;
  int pageSize;
  bool  isHandle;
  String dangerName;
  @override
  String toString() {
    return '{"belongType": $belongType,"dangerLevel": $dangerLevel,"isHandle": $isHandle,""dangerState": $dangerState,"pageIndex": $pageIndex,"pageSize": $pageSize,"dangerName": ${dangerName != null?'${json.encode(dangerName)}':'null'}}';
  }
  }





class HideDangerInfoModel {

  int currentFlowRecordId;
  int dangerId;
  int dangerType;
  int dangerState;
  Object reformJson;
  String position;
  bool currentUserCanExcute;
  String dangerName;
  String dangerStateDesc;
  String levelDesc;
  int level;
  String reformLimitDate;
  String reformTypeDesc;
  String remark;
  List<String> photoUrls=new List();
  RecheckInfo recheckInfo=RecheckInfo.fromParams();
  ReformInfo reformInfo=ReformInfo.fromParams();
  ReviewInfo reviewInfo =ReviewInfo.fromParams();
  RiskInfo riskInfo=RiskInfo.fromParams();
  Records records=Records.fromParams();

  HideDangerInfoModel.fromParams(
      {
        this.currentFlowRecordId,
        this.dangerId,
        this.dangerType,
        this.dangerState,
        this.position,
        this.currentUserCanExcute,
        this.dangerName,
        this.dangerStateDesc,
        this.levelDesc,
        this.level,
        this.reformLimitDate,
        this.reformTypeDesc,
        this.remark,
        this.photoUrls,
        this.recheckInfo,
        this.reformInfo,
        this.reviewInfo,
        this.riskInfo,
        this.records,
        this.reformJson
      }
      );

  factory HideDangerInfoModel(jsonStr) => jsonStr == null ? null : jsonStr is String ? new HideDangerInfoModel.fromJson(json.decode(jsonStr)) : new HideDangerInfoModel.fromJson(jsonStr);

  HideDangerInfoModel.fromJson(jsonRes) {
    currentFlowRecordId = jsonRes['currentFlowRecordId'] as int;
    dangerId = jsonRes['dangerId'] as int ;
    dangerType = jsonRes['dangerType'] as int ;

    dangerState = jsonRes['dangerState'] as int;
    position=jsonRes['position'];
    currentUserCanExcute = jsonRes['currentUserCanExcute'];
    dangerName = jsonRes['dangerName'];
    dangerStateDesc = jsonRes['dangerStateDesc'];
    levelDesc = jsonRes['levelDesc'];
    level = jsonRes['level'];
    reformLimitDate = jsonRes['reformLimitDate'];
    reformTypeDesc = jsonRes['reformTypeDesc'];
    remark = jsonRes['remark'];
    photoUrls = jsonRes['photoUrls'] == null ? null : [];
    reformJson   = jsonRes['reformJson'];
    for (var photoUrlsItem in photoUrls == null ? [] : jsonRes['photoUrls']){
      photoUrls.add(photoUrlsItem);
    }

    recheckInfo = jsonRes['recheckInfo'] == null ? null : new RecheckInfo.fromJson(jsonRes['recheckInfo']);
    reformInfo = jsonRes['reformInfo'] == null ? null : new ReformInfo.fromJson(jsonRes['reformInfo']);
    reviewInfo = jsonRes['reviewInfo'] == null ? null : new ReviewInfo.fromJson(jsonRes['reviewInfo']);
    riskInfo = jsonRes['riskInfo'] == null ? null : new RiskInfo.fromJson(jsonRes['riskInfo']);
    records = jsonRes['records'] == null ? null : new Records.fromJson(jsonRes['records']);

  }

  @override
  String toString() {
    return '{"currentFlowRecordId": $currentFlowRecordId"dangerState": $dangerState,,"dangerType": $dangerType,"currentUserCanExcute": $currentUserCanExcute,"dangerName": ${dangerName != null?'${json.encode(dangerName)}':'null'},,"position": ${position != null?'${json.encode(position)}':'null'},"dangerStateDesc": ${dangerStateDesc != null?'${json.encode(dangerStateDesc)}':'null'},"level": ${levelDesc != null?'${json.encode(level)}':'null'},"level":$level},"reformLimitDate": ${reformLimitDate != null?'${json.encode(reformLimitDate)}':'null'},"reformTypeDesc": ${reformTypeDesc != null?'${json.encode(reformTypeDesc)}':'null'},"remark": ${remark != null?'${json.encode(remark)}':'null'},"photoUrls": $photoUrls,"recheckInfo": $recheckInfo,"reformInfo": $reformInfo,"reviewInfo": $reviewInfo,"riskInfo": $records,"": $records}';
  }
}

class RiskInfo {

  String belongDepartmentName;
  String pointName;
  String pointNo;
  String pointLevel;
  List<String> basis;

  RiskInfo.fromParams({this.belongDepartmentName, this.pointName, this.pointNo, this.basis,this.pointLevel});

  RiskInfo.fromJson(jsonRes) {
    belongDepartmentName = jsonRes['belongDepartmentName'];
    pointName = jsonRes['pointName'];
    pointNo = jsonRes['pointNo'];
    basis = jsonRes['basis'] == null ? null : [];
    pointLevel= jsonRes['pointLevel'];
    for (var basisItem in basis == null ? [] : jsonRes['basis']){
      basis.add(basisItem);
    }
  }

  @override
  String toString() {
    return '{"belongDepartmentName": ${belongDepartmentName != null?'${json.encode(belongDepartmentName)}':'null'},"pointName": ${pointName != null?'${json.encode(pointName)}':'null'},"pointNo": ${pointNo != null?'${json.encode(pointNo)}':'null'},"basis": $basis}';
  }
}

class ReviewInfo {

  int reviewState;
  String reviewJson;
  String reviewRemark;
  String reviewResult;
  String reviewStateDesc;
  String reviewUser;
  String reviewUserDepartMent;

  ReviewInfo.fromParams({this.reviewState, this.reviewJson, this.reviewRemark, this.reviewResult, this.reviewStateDesc, this.reviewUser, this.reviewUserDepartMent});

  ReviewInfo.fromJson(jsonRes) {
    reviewState = jsonRes['reviewState'] as  int;
    reviewJson = jsonRes['reviewJson'];
    reviewRemark = jsonRes['reviewRemark'];
    reviewResult = jsonRes['reviewResult'];
    reviewStateDesc = jsonRes['reviewStateDesc'];
    reviewUser = jsonRes['reviewUser'];
    reviewUserDepartMent = jsonRes['reviewUserDepartMent'];
  }

  @override
  String toString() {
    return '{"reviewState": $reviewState,"reviewJson": ${reviewJson != null?'${json.encode(reviewJson)}':'null'},"reviewRemark": ${reviewRemark != null?'${json.encode(reviewRemark)}':'null'},"reviewResult": ${reviewResult != null?'${json.encode(reviewResult)}':'null'},"reviewStateDesc": ${reviewStateDesc != null?'${json.encode(reviewStateDesc)}':'null'},"reviewUser": ${reviewUser != null?'${json.encode(reviewUser)}':'null'},"reviewUserDepartMent": ${reviewUserDepartMent != null?'${json.encode(reviewUserDepartMent)}':'null'}}';
  }
}

class ReformInfo {

  int reformState;
  String reformJson;
  String reformRemark;
  String reformResult;
  String reformStateDesc;
  String reformUser;
  String reformUserDepartMent;

  ReformInfo.fromParams({this.reformState, this.reformJson, this.reformRemark, this.reformResult, this.reformStateDesc, this.reformUser, this.reformUserDepartMent});

  ReformInfo.fromJson(jsonRes) {
    reformState = jsonRes['reformState'];
    reformJson = jsonRes['reformJson'];
    reformRemark = jsonRes['reformRemark'];
    reformResult = jsonRes['reformResult'];
    reformStateDesc = jsonRes['reformStateDesc'];
    reformUser = jsonRes['reformUser'];
    reformUserDepartMent = jsonRes['reformUserDepartMent'];
  }

  @override
  String toString() {
    return '{"reformState": ${reformState != null?'${json.encode(reformState)}':'null'},"reformJson": ${reformJson != null?'${json.encode(reformJson)}':'null'},"reformRemark": ${reformRemark != null?'${json.encode(reformRemark)}':'null'},"reformResult": ${reformResult != null?'${json.encode(reformResult)}':'null'},"reformStateDesc": ${reformStateDesc != null?'${json.encode(reformStateDesc)}':'null'},"reformUser": ${reformUser != null?'${json.encode(reformUser)}':'null'},"reformUserDepartMent": ${reformUserDepartMent != null?'${json.encode(reformUserDepartMent)}':'null'}}';
  }
}

class RecheckInfo {

  int recheckState;
  String recheckJson;
  Object recheckRemark;
  String recheckResult;
  String recheckUser;
  String recheckUserDepartMent;
  String reformStateDesc;

  RecheckInfo.fromParams({this.recheckState, this.recheckJson, this.recheckRemark, this.recheckResult, this.recheckUser, this.recheckUserDepartMent, this.reformStateDesc});

  RecheckInfo.fromJson(jsonRes) {
    recheckState = jsonRes['recheckState'] as int;
    recheckJson = jsonRes['recheckJson'];
    recheckRemark = jsonRes['recheckRemark'];
    recheckResult = jsonRes['recheckResult'];
    recheckUser = jsonRes['recheckUser'];
    recheckUserDepartMent = jsonRes['recheckUserDepartMent'];
    reformStateDesc = jsonRes['reformStateDesc'];
  }

  @override
  String toString() {
    return '{"recheckState": $recheckState,"recheckJson": ${recheckJson != null?'${json.encode(recheckJson)}':'null'},"recheckRemark": $recheckRemark,"recheckResult": ${recheckResult != null?'${json.encode(recheckResult)}':'null'},"recheckUser": ${recheckUser != null?'${json.encode(recheckUser)}':'null'},"recheckUserDepartMent": ${recheckUserDepartMent != null?'${json.encode(recheckUserDepartMent)}':'null'},"reformStateDesc": ${reformStateDesc != null?'${json.encode(reformStateDesc)}':'null'}}';
  }
}


class Records {

  List<RecordItem> list;

  Records.fromParams({this.list});

  factory Records(jsonStr) => jsonStr == null ? null : jsonStr is String ? new Records.fromJson(json.decode(jsonStr)) : new Records.fromJson(jsonStr);

  Records.fromJson(jsonRes) {
      if(jsonRes!=null){
        list=new List();
        for(var item in jsonRes){
          list.add(RecordItem.fromJson(item));
        }
      }
  }

  @override
  String toString() {
    return '{"json_list": $list}';
  }
}

class RecordItem {

  String flowJson;
  int createDate;
  int dangerId;
  int deleted;
  int excuteState;
  String executeTime;
  int id;
  int updateDate;
  String actionFlag;
  String excuteDepartmentId;
  String excuteResult;
  String excuteUserId;
  String executeDepartmentName;
  String executeUserName;
  String flowTaskId;
  String flowTaskName;
  String flowTaskUserIds;
  String remark;

  RecordItem.fromParams({this.flowJson, this.createDate, this.dangerId, this.deleted, this.excuteState, this.id, this.updateDate, this.actionFlag, this.excuteDepartmentId, this.excuteResult, this.excuteUserId, this.executeDepartmentName, this.executeUserName, this.flowTaskId, this.flowTaskName, this.flowTaskUserIds, this.remark,this.executeTime});

  RecordItem.fromJson(jsonRes) {
    flowJson = jsonRes['flowJson'];
    createDate = jsonRes['createDate'];
    dangerId = jsonRes['dangerId'];
    deleted = jsonRes['deleted'];
    excuteState = jsonRes['excuteState'];
    executeTime = jsonRes['executeTime'];
    id = jsonRes['id'];
    updateDate = jsonRes['updateDate'];
    actionFlag = jsonRes['actionFlag'];
    excuteDepartmentId = jsonRes['excuteDepartmentId'];
    excuteResult = jsonRes['excuteResult'];
    excuteUserId = jsonRes['excuteUserId'];
    executeDepartmentName = jsonRes['executeDepartmentName'];
    executeUserName = jsonRes['executeUserName'];
    flowTaskId = jsonRes['flowTaskId'];
    flowTaskName = jsonRes['flowTaskName'];
    flowTaskUserIds = jsonRes['flowTaskUserIds'];
    remark = jsonRes['remark'];
  }

  @override
  String toString() {
    return '{"flowJson": $flowJson,"createDate": $createDate,"dangerId": $dangerId,"deleted": $deleted,"excuteState": $excuteState,"id": $id,"updateDate": $updateDate,"actionFlag": ${actionFlag != null?'${json.encode(actionFlag)}':'null'},"excuteDepartmentId": ${excuteDepartmentId != null?'${json.encode(excuteDepartmentId)}':'null'},"excuteResult": ${excuteResult != null?'${json.encode(excuteResult)}':'null'},"excuteUserId": ${excuteUserId != null?'${json.encode(excuteUserId)}':'null'},"executeDepartmentName": ${executeDepartmentName != null?'${json.encode(executeDepartmentName)}':'null'},"executeTime": ${executeTime != null?'${json.encode(executeTime)}':'null'},"flowTaskId": ${flowTaskId != null?'${json.encode(flowTaskId)}':'null'},"flowTaskName": ${flowTaskName != null?'${json.encode(flowTaskName)}':'null'},"flowTaskUserIds": ${flowTaskUserIds != null?'${json.encode(flowTaskUserIds)}':'null'},"remark": ${remark != null?'${json.encode(remark)}':'null'}}';
  }
}







