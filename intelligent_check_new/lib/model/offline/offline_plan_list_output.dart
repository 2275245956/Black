import 'dart:convert' show json;

class OfflinePlanListOutput {
  num batchNo;
  num finishStatus;
  num finshNum;
  num planTaskId;
  num taskPlanNum;
  num userId;
  String OrgCode;
  String beginTime;
  String checkDate;
  String endTime;
  String taskName;

  String inOrder;

  String omission;
  String unqualified;
  String unplan;

  List<Point> points;
}


/**
 *         sql.write("pointId,");
    sql.write("pointName,");
    sql.write("pointNo,");
    sql.write("level,");
    sql.write("isFiexed,");
    sql.write("shotMinNumber,");
    sql.write("shotMaxNumber,");
    sql.write("fixedShot,");
    sql.write("usuallyShot,");
    sql.write("routeName,");
    sql.write("classifyNames,");
    sql.write("chargePerson,");
    sql.write("departmentName,");
    sql.write("classify,");
    sql.write("inputItems");
 */
class Point {
  String pointId;
  String name;
  String pointNO;
  String level;
  String isFixed;
  String planTaskId;
  String taskName;
  String routeId;
  String routeName;
  String classifyNames;
  String departmentName;
  String chargePerson;
  bool offline;
  String status;

  String finish;
  int orderNo;
  OfflinePlanTask planTask;
  List<Classify> classifis;
  List<InputItem> inputItems;
}

class OfflinePlanTask {
  int beginTime;
  int endTime;
  int planTaskDetailId;
  int shotMaxNumber;
  int shotMinNumber;
  String planName;
  String pointName;
  String pointNo;

  OfflinePlanTask();

  OfflinePlanTask.fromParam({
    this.beginTime,
    this.endTime,
    this.planTaskDetailId,
    this.shotMaxNumber,
    this.shotMinNumber,
    this.planName,
    this.pointName,
    this.pointNo,
  });
}

class InputItem {
  String id;
  String createDate;
  String catalogId;
  String createBy;
  String dataJson;
  String defaultValue;
  String inputJson;
  String isMultiline;
  String isMust;
  String isScore;
  String itemType;
  String name;
  String orderNo;
  String orgCode;
  String pictureJson;
  String remark;
  String isDelete;
  String pOrderNo;
  String pointItemId;
  String classifyNames;
  String classifyIds;

  InputItem();

  InputItem.fromParam({
    this.id,
    this.createDate,
    this.catalogId,
    this.createBy,
    this.dataJson,
    this.defaultValue,
    this.inputJson,
    this.isMultiline,
    this.isMust,
    this.isScore,
    this.itemType,
    this.name,
    this.orderNo,
    this.orgCode,
    this.pictureJson,
    this.remark,
    this.isDelete,
    this.pOrderNo,
    this.pointItemId,
    this.classifyNames,
    this.classifyIds
  });
}

class Classify {
  String id;
  String name;
  String pointId;
  String orderNo;

  Classify();

  Classify.fromParama({this.id, this.name, this.pointId, this.orderNo});
}
