import 'dart:convert' show json;

// 巡检记录数据提交对象
class CheckRecordDto {
  int planTaskId;
  int pointId;
  String pointNo;
  String remark;
  num classId;
  String checkMode;
  String planName;
  String executor;
  int checkTime;
  List<CheckItemDto> checkItems;
  num routePointItemId;

  CheckRecordDto.fromParams({this.planTaskId, this.pointId, this.remark, this.checkItems});

  factory CheckRecordDto(jsonStr) => jsonStr == null ? null : jsonStr is String ? new CheckRecordDto.fromJson(json.decode(jsonStr)) : new CheckRecordDto.fromJson(jsonStr);

  CheckRecordDto.fromJson(jsonRes) {
    planTaskId = jsonRes['planTaskId'];
    pointId = jsonRes['pointId'];
    remark = jsonRes['remark'];
    checkItems = jsonRes['checkItems'] == null ? null : [];
    routePointItemId = jsonRes['routePointItemId'];

    for (var checkItemsItem in checkItems == null ? [] : jsonRes['checkItems']){
      checkItems.add(checkItemsItem == null ? null : new CheckItemDto.fromJson(checkItemsItem));
    }
  }

  @override
  String toString() {
    return '{"planTaskId": $planTaskId,"planName": ${planName != null?'${json.encode(planName)}':'null'},"pointId": $pointId,"pointNo": ${pointNo != null?'${json.encode(pointNo)}':'null'},"checkMode": "$checkMode","remark": ${remark != null?'${json.encode(remark)}':'null'},"checkItems": $checkItems,"classId": $classId,"executor": ${executor != null?'${json.encode(executor)}':'null'},"checkTime": $checkTime,"routePointItemId": $routePointItemId}';
  }
}

class CheckItemDto {

  int inputItemId;
  bool isCheck;
  String inputValue;
  String selectName;
  String remark;
  String classifyIds;
  num routePointItemId;

  CheckItemDto.fromParams({this.inputItemId, this.isCheck, this.inputValue, this.selectName, this.remark,this.classifyIds,this.routePointItemId});

  CheckItemDto.fromJson(jsonRes) {
    inputItemId = jsonRes['inputItemId'];
    isCheck = jsonRes['isCheck'];
    inputValue = jsonRes['inputValue'];
    selectName = jsonRes['selectName'];
    remark = jsonRes['remark'];
    classifyIds = jsonRes['classifyIds'];
    routePointItemId = jsonRes['routePointItemId'];
  }

  @override
  String toString() {
    return '{"inputItemId": $inputItemId,"isCheck": $isCheck,"inputValue": ${inputValue != null?'${json.encode(inputValue)}':'null'},"selectName": ${selectName != null?'${json.encode(selectName)}':'null'},"remark": ${remark != null?'${json.encode(remark)}':'null'},"classifyIds": ${classifyIds != null?'${json.encode(classifyIds)}':'null'},"routePointItemId": $routePointItemId}';
  }
}