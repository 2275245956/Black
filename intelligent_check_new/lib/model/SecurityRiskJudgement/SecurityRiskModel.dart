import 'dart:convert' show json;

import 'dart:io';


class SecurityRiskListModel {

  int id;
  int status;
  String date;
  String departmentName;
  String judgmentName;
  String statusDesc;
  List<TableInfo> tables;

  SecurityRiskListModel.fromParams({this.id, this.status, this.date, this.departmentName, this.judgmentName, this.statusDesc, this.tables});

  factory SecurityRiskListModel(jsonStr) => jsonStr == null ? null : jsonStr is String ? new SecurityRiskListModel.fromJson(json.decode(jsonStr)) : new SecurityRiskListModel.fromJson(jsonStr);

  SecurityRiskListModel.fromJson(jsonRes) {
    id = jsonRes['id'];
    status = jsonRes['status'];
    date = jsonRes['date'];
    departmentName = jsonRes['departmentName'];
    judgmentName = jsonRes['judgmentName'];
    statusDesc = jsonRes['statusDesc'];
    tables = jsonRes['tables'] == null ? null : [];

    for (var tablesItem in tables == null ? [] : jsonRes['tables']){
      tables.add(tablesItem == null ? null : new TableInfo.fromJson(tablesItem));
    }
  }

  @override
  String toString() {
    return '{"id": $id,"status": $status,"date": ${date != null?'${json.encode(date)}':'null'},"departmentName": ${departmentName != null?'${json.encode(departmentName)}':'null'},"judgmentName": ${judgmentName != null?'${json.encode(judgmentName)}':'null'},"statusDesc": ${statusDesc != null?'${json.encode(statusDesc)}':'null'},"tables": $tables}';
  }
}

class TableInfo {

  int type;
  String tableName;

  TableInfo.fromParams({this.type, this.tableName});

  TableInfo.fromJson(jsonRes) {
    type = jsonRes['type'];
    tableName = jsonRes['tableName'];
  }

  @override
  String toString() {
    return '{"type": $type,"tableName": ${tableName != null?'${json.encode(tableName)}':'null'}}';
  }
}

class SecurityRiskItem {

  int deleted;
  String inputResult;
  String orgCode;
  String photoResult;
  String recordUpdateDate;
  String remarkResult;
  int createDate;
  int fillRecordId;
  int id;
  int inputIsNeed;
  int inputIsRequired;
  int itemId;
  int itemLevel;
  int itemParentId;
  int itemType;
  int photoIsNeed;
  int photoIsRequired;
  int recordCreateDate;
  int recordDeleted;
  int remarkIsNeed;
  int remarkIsRequired;
  int selectIsNeed;
  int selectIsRequired;
  int taskId;
  int updateDate;
  String inputName;
  String itemFlag;
  String itemName;
  String selectJson;
  String selectName;
  String selectResult;
  List<SecurityRiskItem> children;
  bool isFinish;
  bool showChild=false;
  int itemFinish;
  bool isExpanded=false;
  int inputType;
  int inputCanEdit;

  List<File> imageList=new List();


  String uniqueKey;
  String uniqueKeyForInput;


  SecurityRiskItem.fromParams({this.inputCanEdit,this.inputType=0,this.uniqueKeyForInput,this.uniqueKey,this.itemFinish,this.isFinish=false, this.children,this.deleted, this.inputResult, this.orgCode, this.photoResult, this.recordUpdateDate, this.remarkResult, this.createDate, this.fillRecordId, this.id, this.inputIsNeed, this.inputIsRequired, this.itemId, this.itemLevel, this.itemParentId, this.itemType, this.photoIsNeed, this.photoIsRequired, this.recordCreateDate, this.recordDeleted, this.remarkIsNeed, this.remarkIsRequired, this.selectIsNeed, this.selectIsRequired, this.taskId, this.updateDate, this.inputName, this.itemFlag, this.itemName, this.selectJson, this.selectName, this.selectResult,this.showChild=false});

  factory SecurityRiskItem(jsonStr) => jsonStr == null ? null : jsonStr is String ? new SecurityRiskItem.fromJson(json.decode(jsonStr)) : new SecurityRiskItem.fromJson(jsonStr);

  SecurityRiskItem.fromJson(jsonRes) {
    deleted = jsonRes['deleted'];
    inputResult = jsonRes['inputResult'];
    orgCode = jsonRes['orgCode'];
    photoResult = jsonRes['photoResult'];
    recordUpdateDate = jsonRes['recordUpdateDate'];
    remarkResult = jsonRes['remarkResult'];
    createDate = jsonRes['createDate'];
    fillRecordId = jsonRes['fillRecordId'];
    id = jsonRes['id'];
    inputIsNeed = jsonRes['inputIsNeed'];
    inputIsRequired = jsonRes['inputIsRequired'];
    itemId = jsonRes['itemId'];
    itemLevel = jsonRes['itemLevel'];
    itemParentId = jsonRes['itemParentId'];
    itemType = jsonRes['itemType'];
    photoIsNeed = jsonRes['photoIsNeed'];
    photoIsRequired = jsonRes['photoIsRequired'];
    recordCreateDate = jsonRes['recordCreateDate'];
    recordDeleted = jsonRes['recordDeleted'];
    remarkIsNeed = jsonRes['remarkIsNeed'];
    remarkIsRequired = jsonRes['remarkIsRequired'];
    selectIsNeed = jsonRes['selectIsNeed'];
    selectIsRequired = jsonRes['selectIsRequired'];
    taskId = jsonRes['taskId'];
    updateDate = jsonRes['updateDate'];
    inputName = jsonRes['inputName'];
    itemFlag = jsonRes['itemFlag'];
    itemName = jsonRes['itemName'];
    selectJson = jsonRes['selectJson'];
    selectName = jsonRes['selectName'];
    selectResult = jsonRes['selectResult'];

    inputType = jsonRes['inputType'] ??0;
    children=new List();
    isFinish=false;
    showChild=false;

    itemFinish=jsonRes["itemFinish"];
    inputCanEdit=jsonRes["inputCanEdit"];



  }

  @override
  String toString() {
    return '{"deleted": $deleted,"inputCanEdit": $inputCanEdit,"inputType": $inputType,"inputResult": ${inputResult != null?'${json.encode(inputResult)}':'null'},"orgCode": ${orgCode != null?'${json.encode(orgCode)}':'null'},"photoResult": ${photoResult != null?'${json.encode(photoResult)}':'null'},"recordUpdateDate": ${recordUpdateDate != null?'${json.encode(recordUpdateDate)}':'null'},"remarkResult": ${remarkResult != null?'${json.encode(remarkResult)}':'null'},"createDate": $createDate,"fillRecordId": $fillRecordId,"id": $id,"inputIsNeed": $inputIsNeed,"inputIsRequired": $inputIsRequired,"itemId": $itemId,"itemLevel": $itemLevel,"itemParentId": $itemParentId,"itemType": $itemType,"photoIsNeed": $photoIsNeed,"photoIsRequired": $photoIsRequired,"recordCreateDate": $recordCreateDate,"recordDeleted": $recordDeleted,"remarkIsNeed": $remarkIsNeed,"remarkIsRequired": $remarkIsRequired,"selectIsNeed": $selectIsNeed,"selectIsRequired": $selectIsRequired,"taskId": $taskId,"updateDate": $updateDate,"inputName": ${inputName != null?'${json.encode(inputName)}':'null'},"itemFlag": ${itemFlag != null?'${json.encode(itemFlag)}':'null'},"itemName": ${itemName != null?'${json.encode(itemName)}':'null'},"selectJson": ${selectJson != null?'${json.encode(selectJson)}':'null'},"selectName": ${selectName != null?'${json.encode(selectName)}':'null'},"selectResult": ${selectResult != null?'${json.encode(selectResult)}':'null'}}';
  }
}

class SelectJson {

  int id;
  bool defaultSelect;
  String name;
  String tag;

  SelectJson.fromParams({this.id, this.defaultSelect, this.name, this.tag});

  factory SelectJson(jsonStr) => jsonStr == null ? null : jsonStr is String ? new SelectJson.fromJson(json.decode(jsonStr)) : new SelectJson.fromJson(jsonStr);

  SelectJson.fromJson(jsonRes) {
    id = jsonRes['id'];
    defaultSelect = jsonRes['defaultSelect'];
    name = jsonRes['name'];
    tag = jsonRes['tag'];
  }

  @override
  String toString() {
    return '{"id": $id,"defaultSelect": $defaultSelect,"name": ${name != null?'${json.encode(name)}':'null'},"tag": ${tag != null?'${json.encode(tag)}':'null'}}';
  }
}

class SubmitDataModel {

  int taskId;
  List<SubModel> records;

  SubmitDataModel.fromParams({this.taskId, this.records});

  factory SubmitDataModel(jsonStr) => jsonStr == null ? null : jsonStr is String ? new SubmitDataModel.fromJson(json.decode(jsonStr)) : new SubmitDataModel.fromJson(jsonStr);

  SubmitDataModel.fromJson(jsonRes) {
    taskId = jsonRes['taskId'];
    records = jsonRes['records'] == null ? null : [];

    for (var recordsItem in records == null ? [] : jsonRes['records']){
      records.add(recordsItem == null ? null : new SubModel.fromJson(recordsItem));
    }
  }

  @override
  String toString() {
    return '{"taskId": $taskId,"records": $records}';
  }
}

class SubModel {

  int deleted;
  int id;
  int itemFinish;
  int itemId;
  int taskId;
  String createDate;
  String inputResult;
  String orgCode;
  String photoResult;
  String remarkResult;
  String selectResult;
  String updateDate;
  List<SubModel> childs;

  SubModel.fromParams({this.deleted, this.id, this.itemFinish, this.itemId, this.taskId, this.createDate, this.inputResult, this.orgCode, this.photoResult, this.remarkResult, this.selectResult, this.updateDate, this.childs});

  SubModel.fromJson(jsonRes) {
    deleted = jsonRes['deleted'];
    id = jsonRes['id'];
    itemFinish = jsonRes['itemFinish'];
    itemId = jsonRes['itemId'];
    taskId = jsonRes['taskId'];
    createDate = jsonRes['createDate'];
    inputResult = jsonRes['inputResult'];
    orgCode = jsonRes['orgCode'];
    photoResult = jsonRes['photoResult'];
    remarkResult = jsonRes['remarkResult'];
    selectResult = jsonRes['selectResult'];
    updateDate = jsonRes['updateDate'];
    childs = jsonRes['childs'] == null ? null : [];

    for (var childsItem in childs == null ? [] : jsonRes['childs']){
      childs.add(childsItem == null ? null : new SubModel.fromJson(childsItem));
    }
  }

  @override
  String toString() {
    return '{"deleted": $deleted,"id": $id,"itemFinish": $itemFinish,"itemId": $itemId,"taskId": $taskId,"createDate": ${createDate != null?'${json.encode(createDate)}':'null'},"inputResult": ${inputResult != null?'${json.encode(inputResult)}':'null'},"orgCode": ${orgCode != null?'${json.encode(orgCode)}':'null'},"photoResult": ${photoResult != null?'${json.encode(photoResult)}':'null'},"remarkResult": ${remarkResult != null?'${json.encode(remarkResult)}':'null'},"selectResult": ${selectResult != null?'${json.encode(selectResult)}':'null'},"updateDate": ${updateDate != null?'${json.encode(updateDate)}':'null'},"childs": $childs}';
  }
}






