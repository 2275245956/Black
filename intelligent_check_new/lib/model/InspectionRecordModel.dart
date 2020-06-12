import 'dart:convert' show json;
class InspectionRecordOutputModel{
//  static const String LABEL_NUMBER = "编号";
//  static const String LABEL_PLAN = "计划";
//  static const String LABEL_INSPECTER = "巡检人";
//  static const String LABEL_INSPECTEDTIME = "时间";
  List<InspectionRecord> InspectionRecords;
  InspectionRecordOutputModel.fromJson(List<Map> list){
    InspectionRecord ins;

  }
}
class InspectionRecord{
  String InspectionPointName;
  String Number;
  String IsQualified;
  String InspectionPlanName;
  String InspecterName;
  String InspectedTime;
  String PointId;
  String PlanTaskId;
  String CheckId;

  InspectionRecord.fromParams({this.PointId,this.InspectionPointName,this.Number,
    this.IsQualified,this.InspectionPlanName,this.InspecterName,this.InspectedTime,this.PlanTaskId,this.CheckId});
}

class InspectionRecordFilter{
  bool isOnlyMyInspection;
  String userId;//-1:全部
  String beginDate;
  String endDate;
  int isOK;//-1:所有
  String orderBy;
  int departmentId;//-1:所有
  int planTaskId;//-1:所有
  int pointId;//-1:所有
  String pointNo;
  // @override
  String toString() {
    return '{"userId": $userId,"beginDate": ${beginDate != null?'${json.encode(beginDate)}':'null'}'
        ',"endDate": ${endDate != null?'${json.encode(endDate)}':'null'},'
        '"isOK": $isOK,"orderBy": ${orderBy != null?'${json.encode(orderBy)}':'null'}'
        ',"departmentId": $departmentId,"planTaskId": $planTaskId,"pointId": $pointId}';
  }
}