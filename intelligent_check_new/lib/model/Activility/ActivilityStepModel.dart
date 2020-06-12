import 'dart:convert' show json;
import 'dart:io';

import 'package:intelligent_check_new/model/CheckExecute/query_point_detail.dart';
import 'dart:convert' show json;

class StepsModel {

  String imgs;
  String uniqueKey;
  String remark;
  int taskworkContentId;
  String taskworkContentName;
  String taskworkContentLevel;



  StepsModel.fromParams({this.taskworkContentLevel,this.imgs, this.taskworkContentId, this.taskworkContentName});

  factory StepsModel(jsonStr) => jsonStr == null ? null : jsonStr is String ? new StepsModel.fromJson(json.decode(jsonStr)) : new StepsModel.fromJson(jsonStr);

  StepsModel.fromJson(jsonRes) {
    imgs = jsonRes['imgs'];
    taskworkContentLevel = jsonRes['taskworkContentLevel'];
    taskworkContentId = jsonRes['taskworkContentId'];
    taskworkContentName = jsonRes['taskworkContentName'];
  }

  @override
  String toString() {
    return '{"imgs": ${imgs != null?'${json.encode(imgs)}':'null'},"taskworkContentLevel": ${taskworkContentLevel != null?'${json.encode(taskworkContentLevel)}':'null'},"taskworkContentId": $taskworkContentId,"taskworkContentName": ${taskworkContentName != null?'${json.encode(taskworkContentName)}':'null'}';
  }
}

class TaskFactorModel {

  int riskFactorId;
  String riskFactorName;
  List<MeasuresModel> measuresList;
  bool isShow=false;

  TaskFactorModel.fromParams({this.riskFactorId, this.riskFactorName, this.measuresList});

  factory TaskFactorModel(jsonStr) => jsonStr == null ? null : jsonStr is String ? new TaskFactorModel.fromJson(json.decode(jsonStr)) : new TaskFactorModel.fromJson(jsonStr);

  TaskFactorModel.fromJson(jsonRes) {
    riskFactorId = jsonRes['riskFactorId'];
    riskFactorName = jsonRes['riskFactorName'];
    measuresList = jsonRes['measuresList'] == null ? null : [];

    for (var measuresListItem in measuresList == null ? [] : jsonRes['measuresList']){
      measuresList.add(measuresListItem == null ? null : new MeasuresModel.fromJson(measuresListItem));
    }
  }

  @override
  String toString() {
    return '{"riskFactorId": $riskFactorId,"riskFactorName": ${riskFactorName != null?'${json.encode(riskFactorName)}':'null'},"measuresList": $measuresList}';
  }
}

class MeasuresModel {

  String envImgs;
  String siteChangeIdea;
  String siteImgs;
  int envEnsureStatus;
  int id;
  int siteEnsureStatus;
  String envChangeIdea;
  String measureContentName;
  String uniquekey;
  bool showRemark=false;
  List<File> imageList;

  MeasuresModel.fromParams({this.envImgs, this.siteChangeIdea, this.siteImgs, this.envEnsureStatus, this.id, this.siteEnsureStatus, this.envChangeIdea, this.measureContentName});

  MeasuresModel.fromJson(jsonRes) {
    envImgs = jsonRes['envImgs'];
    siteChangeIdea = jsonRes['siteChangeIdea'];
    siteImgs = jsonRes['siteImgs'];
    envEnsureStatus = jsonRes['envEnsureStatus'];
    id = jsonRes['id'];
    siteEnsureStatus = jsonRes['siteEnsureStatus'];
    envChangeIdea = jsonRes['envChangeIdea'];
    measureContentName = jsonRes['measureContentName'];
  }

  @override
  String toString() {
    return '{"envImgs": ${envImgs != null?'${json.encode(envImgs)}':'null'},"siteChangeIdea": ${siteChangeIdea != null?'${json.encode(siteChangeIdea)}':'null'},"siteImgs": ${siteImgs != null?'${json.encode(siteImgs)}':'null'},"envEnsureStatus": $envEnsureStatus,"id": $id,"siteEnsureStatus": $siteEnsureStatus,"envChangeIdea": ${envChangeIdea != null?'${json.encode(envChangeIdea)}':'null'},"measureContentName": ${measureContentName != null?'${json.encode(measureContentName)}':'null'}}';
  }
}





class StepModel {

  String remark;
  String taskworkLevel;
  int serialNum;
  int taskworkContentId;
  String imgs;
  String taskworkContentName;
  List<StepMeasureModel> taskworkMeasures;
  List<RiskFactorList> riskFactors;
  String uniqueKey;

  StepModel.fromParams({this.uniqueKey,this.riskFactors,this.remark, this.taskworkLevel, this.serialNum, this.taskworkContentId, this.imgs, this.taskworkContentName, this.taskworkMeasures});

  factory StepModel(jsonStr) => jsonStr == null ? null : jsonStr is String ? new StepModel.fromJson(json.decode(jsonStr)) : new StepModel.fromJson(jsonStr);

  StepModel.fromJson(jsonRes) {
    remark = jsonRes['remark'];
    taskworkLevel = jsonRes['taskworkLevel'];
    serialNum = jsonRes['serialNum'];
    taskworkContentId = jsonRes['taskworkContentId'];
    imgs = jsonRes['imgs'];
    taskworkContentName = jsonRes['taskworkContentName'];
    taskworkMeasures = jsonRes['taskworkMeasures'] == null ? null : [];

    for (var taskworkMeasuresItem in taskworkMeasures == null ? [] : jsonRes['taskworkMeasures']){
      taskworkMeasures.add(taskworkMeasuresItem == null ? null : new StepMeasureModel.fromJson(taskworkMeasuresItem));
    }

    riskFactors = jsonRes['riskFactors'] == null ? null : [];

    for (var riskFactorListItem in riskFactors == null ? [] : jsonRes['riskFactors']){
      riskFactors.add(riskFactorListItem == null ? null : new RiskFactorList.fromJson(riskFactorListItem));
    }
  }

  @override
  String toString() {
    return '{"remark": ${remark != null?'${json.encode(remark)}':'null'},"taskworkLevel": ${taskworkLevel != null?'${json.encode(taskworkLevel)}':'null'},"serialNum": $serialNum,"taskworkContentId": $taskworkContentId,"imgs": ${imgs != null?'${json.encode(imgs)}':'null'},"taskworkContentName": ${taskworkContentName != null?'${json.encode(taskworkContentName)}':'null'},"taskworkMeasures": $taskworkMeasures}';
  }
}

class StepMeasureModel {

  String remark;
  int executeState;
  int id;
  int violateState;
  String ensurePerson;
  String measuresContent;
  bool showRemark;
  String uniqueKeyForMeasures;

  StepMeasureModel.fromParams({this.remark, this.executeState, this.id, this.violateState, this.ensurePerson, this.measuresContent});

  StepMeasureModel.fromJson(jsonRes) {
    remark = jsonRes['remark'];
    executeState = jsonRes['executeState'];
    id = jsonRes['id'];
    violateState = jsonRes['violateState'];
    ensurePerson = jsonRes['ensurePerson'];
    measuresContent = jsonRes['measuresContent'];
    showRemark=false;
  }

  @override
  String toString() {
    return '{"remark": ${remark != null?'${json.encode(remark)}':'null'},"executeState": $executeState,"id": $id,"violateState": $violateState,"ensurePerson": ${ensurePerson != null?'${json.encode(ensurePerson)}':'null'},"measuresContent": ${measuresContent != null?'${json.encode(measuresContent)}':'null'}}';
  }
}



