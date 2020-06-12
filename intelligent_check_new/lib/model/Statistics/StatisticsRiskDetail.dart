import 'dart:convert' show json;

class RiskDetailModel {

  List<RiskByDept> byDepartment;
  List<RiskByHighDangerLevel> byHighLevel;
  List<RiskByLevel> byRiskLevel;


  RiskDetailModel.fromParams({this.byDepartment, this.byHighLevel, this.byRiskLevel});

  factory RiskDetailModel(jsonStr) => jsonStr == null ? null : jsonStr is String ? new RiskDetailModel.fromJson(json.decode(jsonStr)) : new RiskDetailModel.fromJson(jsonStr);

  RiskDetailModel.fromJson(jsonRes) {
    byDepartment = jsonRes['byDepartment'] == null ? null : [];

    for (var byDepartmentItem in byDepartment == null ? [] : jsonRes['byDepartment']){
      byDepartment.add(byDepartmentItem == null ? null : new RiskByDept.fromJson(byDepartmentItem));
    }

    byHighLevel = jsonRes['byHighLevel'] == null ? null : [];

    for (var byHighLevelItem in byHighLevel == null ? [] : jsonRes['byHighLevel']){
      byHighLevel.add(byHighLevelItem == null ? null : new RiskByHighDangerLevel.fromJson(byHighLevelItem));
    }

    byRiskLevel = jsonRes['byRiskLevel'] == null ? null : [];

    for (var byRiskLevelItem in byRiskLevel == null ? [] : jsonRes['byRiskLevel']){
      byRiskLevel.add(byRiskLevelItem == null ? null : new RiskByLevel.fromJson(byRiskLevelItem));
    }
  }

  @override
  String toString() {
    return '{"byDepartment": $byDepartment,"byHighLevel": $byHighLevel,"byRiskLevel": $byRiskLevel}';
  }
}

class RiskByLevel {

  int total;
  String name;
  String percent;
  String value;

  RiskByLevel.fromParams({this.total, this.name, this.percent, this.value});

  RiskByLevel.fromJson(jsonRes) {
    total = jsonRes['total']??0;
    name = jsonRes['name'];
    percent = jsonRes['percent']??"0";
    value = jsonRes['value'].toString()??"0";
  }

  @override
  String toString() {
    return '{"total": $total,"name": ${name != null?'${json.encode(name)}':'null'},"percent": ${percent != null?'${json.encode(percent)}':'null'},"value": ${value != null?'${json.encode(value)}':'null'}}';
  }
}

class RiskByHighDangerLevel {

  int level1;
  int level2;
  int level3;
  int level4;
  int level5;
  int level6;
  int level7;
  String type;

  RiskByHighDangerLevel.fromParams({this.level1, this.level2, this.level3, this.level4, this.level5,this.level6,this.level7, this.type});

  RiskByHighDangerLevel.fromJson(jsonRes) {
    level1 = jsonRes['level1'];
    level2 = jsonRes['level2'];
    level3 = jsonRes['level3'];
    level4 = jsonRes['level4'];
    level5 = jsonRes['level5'];
    level6 = jsonRes['level6'];
    level7 = jsonRes['level7'];
    type = jsonRes['type'];
  }

  @override
  String toString() {
    return '{"level1": $level1,"level2": $level2,"level3": $level3,"level4": $level4,"level5": $level5,"type": ${type != null?'${json.encode(type)}':'null'}}';
  }
}

class RiskByDept {

  int level1;
  int level2;
  int level3;
  int level4;
  int level5;
  int level6;
  int level7;
  String belongDepartmentId;
  String departmentName;

  RiskByDept.fromParams({this.level1, this.level2, this.level3, this.level4, this.level5, this.belongDepartmentId, this.departmentName});

  RiskByDept.fromJson(jsonRes) {
    level1 = jsonRes['level1'];
    level2 = jsonRes['level2'];
    level3 = jsonRes['level3'];
    level4 = jsonRes['level4'];
    level5 = jsonRes['level5'];
    level6 = jsonRes['level6'];
    level7 = jsonRes['level7'];
    belongDepartmentId = jsonRes['belongDepartmentId'];
    departmentName = jsonRes['departmentName'];
  }

  @override
  String toString() {
    return '{"level1": $level1,"level2": $level2,"level3": $level3,"level4": $level4,"level5": $level5,"belongDepartmentId": ${belongDepartmentId != null?'${json.encode(belongDepartmentId)}':'null'},"departmentName": ${departmentName != null?'${json.encode(departmentName)}':'null'}}';
  }
}



class DangerDetailModel {

  List<RiskByLevel> byDangerLevel;
  List<RiskByLevel> byDangerStatus;

  DangerDetailModel.fromParams({this.byDangerLevel, this.byDangerStatus});

  factory DangerDetailModel(jsonStr) => jsonStr == null ? null : jsonStr is String ? new DangerDetailModel.fromJson(json.decode(jsonStr)) : new DangerDetailModel.fromJson(jsonStr);

  DangerDetailModel.fromJson(jsonRes) {
    byDangerLevel = jsonRes['byDangerLevel'] == null ? null : [];

    for (var byDangerLevelItem in byDangerLevel == null ? [] : jsonRes['byDangerLevel']){
      byDangerLevel.add(byDangerLevelItem == null ? null : new RiskByLevel.fromJson(byDangerLevelItem));
    }

    byDangerStatus = jsonRes['byDangerStatus'] == null ? null : [];

    for (var byDangerStatusItem in byDangerStatus == null ? [] : jsonRes['byDangerStatus']){
      byDangerStatus.add(byDangerStatusItem == null ? null : new RiskByLevel.fromJson(byDangerStatusItem));
    }
  }

  @override
  String toString() {
    return '{"byDangerLevel": $byDangerLevel,"byDangerStatus": $byDangerStatus}';
  }
}

class TaskWorkDetailModel {

  List<RiskByLevel> byRiskLevel;
  List<RiskByLevel> byTaskworkStatus;
  List<RiskByLevel> byTaskworkType;
  List<RiskByLevel> byTaskworkViolateStatus;

  TaskWorkDetailModel.fromParams({this.byRiskLevel, this.byTaskworkStatus, this.byTaskworkType, this.byTaskworkViolateStatus});

  factory TaskWorkDetailModel(jsonStr) => jsonStr == null ? null : jsonStr is String ? new TaskWorkDetailModel.fromJson(json.decode(jsonStr)) : new TaskWorkDetailModel.fromJson(jsonStr);

  TaskWorkDetailModel.fromJson(jsonRes) {
    byRiskLevel = jsonRes['byRiskLevel'] == null ? null : [];

    for (var byRiskLevelItem in byRiskLevel == null ? [] : jsonRes['byRiskLevel']){
      byRiskLevel.add(byRiskLevelItem == null ? null : new RiskByLevel.fromJson(byRiskLevelItem));
    }

    byTaskworkStatus = jsonRes['byTaskworkStatus'] == null ? null : [];

    for (var byTaskworkStatusItem in byTaskworkStatus == null ? [] : jsonRes['byTaskworkStatus']){
      byTaskworkStatus.add(byTaskworkStatusItem == null ? null : new RiskByLevel.fromJson(byTaskworkStatusItem));
    }

    byTaskworkType = jsonRes['byTaskworkType'] == null ? null : [];

    for (var byTaskworkTypeItem in byTaskworkType == null ? [] : jsonRes['byTaskworkType']){
      byTaskworkType.add(byTaskworkTypeItem == null ? null : new RiskByLevel.fromJson(byTaskworkTypeItem));
    }

    byTaskworkViolateStatus = jsonRes['byTaskworkViolateStatus'] == null ? null : [];

    for (var byTaskworkViolateStatusItem in byTaskworkViolateStatus == null ? [] : jsonRes['byTaskworkViolateStatus']){
      byTaskworkViolateStatus.add(byTaskworkViolateStatusItem == null ? null : new RiskByLevel.fromJson(byTaskworkViolateStatusItem));
    }
  }

  @override
  String toString() {
    return '{"byRiskLevel": $byRiskLevel,"byTaskworkStatus": $byTaskworkStatus,"byTaskworkType": $byTaskworkType,"byTaskworkViolateStatus": $byTaskworkViolateStatus}';
  }
}




class JudgementDetailModel {

  List<JudgementModel> byDepartmentStatus;

  JudgementDetailModel.fromParams({this.byDepartmentStatus});

  factory JudgementDetailModel(jsonStr) => jsonStr == null ? null : jsonStr is String ? new JudgementDetailModel.fromJson(json.decode(jsonStr)) : new JudgementDetailModel.fromJson(jsonStr);

  JudgementDetailModel.fromJson(jsonRes) {
    byDepartmentStatus = jsonRes['byDepartmentStatus'] == null ? null : [];

    for (var byDepartmentStatusItem in byDepartmentStatus == null ? [] : jsonRes['byDepartmentStatus']){
      byDepartmentStatus.add(byDepartmentStatusItem == null ? null : new JudgementModel.fromJson(byDepartmentStatusItem));
    }
  }

  @override
  String toString() {
    return '{"byDepartmentStatus": $byDepartmentStatus}';
  }
}

class JudgementModel {

  String status;
  String deptId;
  String deptName;
  String name;

  JudgementModel.fromParams({this.status, this.deptId, this.deptName, this.name});

  JudgementModel.fromJson(jsonRes) {
    status = jsonRes['status'];
    deptId = jsonRes['deptId'];
    deptName = jsonRes['deptName'];
    name = jsonRes['name'];
  }

  @override
  String toString() {
    return '{"status": $status,"deptId": ${deptId != null?'${json.encode(deptId)}':'null'},"deptName": ${deptName != null?'${json.encode(deptName)}':'null'},"name": ${name != null?'${json.encode(name)}':'null'}}';
  }
}








