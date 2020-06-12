import 'dart:convert' show json;

import 'package:intelligent_check_new/model/offline/offline_plan_list_output.dart';

Point getOfflinePointFromJson(Map<String,dynamic> map){
  //--OfflinePoint-Model------------------
//    String pointId;
//    String planTaskId;
//    String taskName;
//    String routeId;
//    String name;
//    String pointNO;
//    String offline;
//    String status;
//    String isFixed;
//    String finish;
//    OfflinePlanTask planTask;
//    List<Classify> classifis;
//    List<InputItem> inputItems;
  //---------------------
  //--Database-字段-----------------
//    pointId vahrcahr(10)
//    pointName varchar(50)
//    pointNo varchar(50)
//    level varchar(50)
//    isFiexed varchar(10)
//    shotMinNumber varchar(10)
//    shotMaxNumber varchar(10)
//    fixedShot varchar(10)
//    usuallyShot varchar(10)
//    routeName varchar(50)
//    classifyNames varchar(50)
//    chargePerson varchar(50)
//    departmentName varchar(50)
//    classify TEXT
//    inputItems TEXT
  //---------------------
  Point point = new Point();
  point.pointId=map["pointId"].toString();
  point.planTaskId = "";
  point.taskName = "";
  point.routeId = "";
  point.name=map["pointName"].toString();
  point.pointNO=map["pointNo"].toString();
  point.offline=map["level"];
  point.status = "";
  point.isFixed=map["isFiexed"].toString();
  point.finish = "";
  point.classifis = new List();
  var jsonCls = json.decode(map["classify"]);
  for(var cls in jsonCls){
    point.classifis.add(Classify.fromParama(id:cls["classifyId"].toString(),
        pointId:cls["pointId"].toString(),
        name:cls["classifyName"].toString()
    ));
  }

  point.inputItems = new List();
  var jsonItems = json.decode(map["inputItems"]);
  for(var item in jsonItems){
    point.inputItems.add(InputItem.fromParam(
        id:item["id"].toString(),
        createDate:item["createDate"].toString(),
        catalogId:item["catalogId"].toString(),
        createBy:item["createBy"].toString(),
        dataJson: item["dataJson"].toString(),
        defaultValue:item["defaultValue"].toString(),
        inputJson:item["inputJson"].toString(),
        isMultiline:item["isMultiline"].toString(),
        isMust:item["isMust"].toString(),
        isScore:item["isScore"].toString(),
        itemType:item["itemType"].toString(),
        name:item["name"].toString(),
        orderNo:item["orderNo"].toString(),
        orgCode:item["orgCode"].toString(),
        pictureJson:item["pictureJson"].toString(),
        remark:item["remark"].toString(),
        isDelete:item["isDelete"].toString(),
        pOrderNo:item["pOrderNo"].toString(),
        pointItemId:item["pointItemId"].toString(),
        classifyNames:item["classifyNames"].toString(),
        classifyIds:item["classifyIds"].toString()
    ));
  }
  return point;
}
