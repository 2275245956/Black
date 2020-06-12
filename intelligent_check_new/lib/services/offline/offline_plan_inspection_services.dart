import 'dart:convert' show json;

import 'package:intelligent_check_new/model/PageDto.dart';
import 'package:intelligent_check_new/model/offline/offline_plan_list_output.dart';
import 'package:intelligent_check_new/services/offline/dbAccess.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
Future<PageDto> getOfflinePlanListOutputList() async {
  Database db = await dbAccess().openDb();
  List<Map<String, dynamic>> lst = await dbAccess().getPlanInspections(db);
  try {
    PageDto pageDto;
    OfflinePlanListOutput mdl;
    pageDto = PageDto.offlinefromJson();
    print(lst);
    for (var i = 0; i < lst.length; i++) {
      var plan = lst[i];
      mdl = new OfflinePlanListOutput();
      mdl.taskPlanNum = JunMath.parseInt(plan["taskPlanNum"].toString());
      mdl.OrgCode = plan["orgCode"].toString();
      mdl.finishStatus = JunMath.parseInt(plan["finishStatus"].toString());// 0:未开始，1：进行中，2：已结束
      mdl.batchNo = JunMath.parseInt(plan["batchNo"].toString());
      mdl.finshNum = JunMath.parseInt(plan["finshNum"].toString());
      mdl.planTaskId = JunMath.parseInt(plan["planTaskId"].toString());
      mdl.taskName = plan["taskName"].toString();
      mdl.beginTime = plan["beginTime"].toString();
      mdl.endTime = plan["endTime"].toString();
      mdl.checkDate = ""; //item[""];
      mdl.userId = JunMath.parseInt(plan["userId"].toString());
      mdl.omission = "";
      mdl.unqualified = "";
      mdl.unplan = "";
      mdl.inOrder = plan["inOrder"].toString();
      // 计划相关点信息
      mdl.points = new List();
      List<Map<String, dynamic>> pointlst = await dbAccess().getPlanInspectionPoints(db, mdl.planTaskId);
      for (var j = 0; j < pointlst.length; j++) {
        var mdlPoint = new Point();
        var point = pointlst[j];
        mdlPoint.pointId = point["pointId"].toString();
        mdlPoint.name = point["name"].toString();
        mdlPoint.pointNO = point["pointNO"].toString();
        mdlPoint.offline = point["offline"]=="true";
        mdlPoint.status = point["status"].toString(); // 0：未开始，
        mdlPoint.isFixed = point["isFixed"].toString();
        mdlPoint.planTaskId = point["planTaskId"].toString();
        mdlPoint.orderNo = JunMath.parseInt(point["orderNo"].toString());
        // 冗余计划相关字段
        var planTask = new OfflinePlanTask();
        planTask.beginTime = JunMath.parseInt(mdl.beginTime);
        planTask.endTime = JunMath.parseInt(mdl.endTime);
        planTask.planName = mdl.taskName;
        planTask.pointName = mdlPoint.name;
        planTask.pointNo = mdlPoint.pointNO;
        mdlPoint.planTask = planTask;

        // 处理检查项
        mdlPoint.inputItems = new List();
        var jsonItems = json.decode(point["inputItems"]);
        for (var item in jsonItems) {
          var mdlItem = new InputItem();
          mdlItem.id = item["id"].toString();
          mdlItem.createDate = item["createDate"].toString();
          mdlItem.catalogId = item["catalogId"].toString();
          mdlItem.createBy = item["createBy"].toString();
          mdlItem.dataJson = item["dataJson"].toString();
          mdlItem.defaultValue = item["defaultValue"].toString();
          mdlItem.inputJson = item["inputJson"].toString();
          mdlItem.isMultiline = item["isMultiline"].toString();
          mdlItem.isMust = item["isMust"].toString();
          mdlItem.isScore = item["isScore"].toString();
          mdlItem.itemType = item["itemType"].toString();
          mdlItem.name = item["name"].toString();
          mdlItem.orderNo = item["orderNo"].toString();
          mdlItem.orgCode = item["orgCode"].toString();
          mdlItem.pictureJson = item["pictureJson"].toString();
          mdlItem.remark = item["remark"].toString();
          mdlItem.isDelete = item["isDelete"].toString();
          mdlItem.pOrderNo = item["pOrderNo"].toString();
          mdlItem.pointItemId = item["pointItemId"].toString();
          mdlItem.classifyNames = item["classifyNames"].toString();
          mdlItem.classifyIds = item["classifyIds"].toString();
          // 放到point
          mdlPoint.inputItems.add(mdlItem);
        }

        // 处理检查项分类
        mdlPoint.classifis = new List();
        var jsonClassify = json.decode(point["classify"]);
        for (var cls in jsonClassify) {
          if(cls != null){
            var mdlCls = new Classify();
            mdlCls.id = cls["id"].toString();
            mdlCls.name = cls["name"].toString();
            mdlCls.pointId = cls["pointId"].toString();
            mdlCls.orderNo = cls["orderNo"].toString();
            // 放到point
            mdlPoint.classifis.add(mdlCls);
          }
        }
        // 放到计划中
        mdl.points.add(mdlPoint);
      }
      pageDto.content.add(mdl);
    }
    print(pageDto);
    return pageDto;
  } catch (e) {
    throw e;
  }
}

Future<OfflinePlanListOutput> getOfflinePlanListOutputById(int planId) async {
  Database db = await dbAccess().openDb();
  Map<String, dynamic> plan = await dbAccess().getPlanInspectionById(db, planId);
  if(null == plan){
    return null;
  }
  try {
    OfflinePlanListOutput mdl;
    mdl = new OfflinePlanListOutput();
    mdl.taskPlanNum = JunMath.parseInt(plan["taskPlanNum"].toString());
    mdl.OrgCode = plan["orgCode"].toString();
    mdl.finishStatus = JunMath.parseInt(plan["finishStatus"].toString());// 0:未开始，1：进行中，2：已结束
    mdl.batchNo = JunMath.parseInt(plan["batchNo"].toString());
    mdl.finshNum = JunMath.parseInt(plan["finshNum"].toString());
    mdl.planTaskId = JunMath.parseInt(plan["planTaskId"].toString());
    mdl.taskName = plan["taskName"].toString();
    mdl.beginTime = plan["beginTime"].toString();
    mdl.endTime = plan["endTime"].toString();
    mdl.checkDate = ""; //item[""];
    mdl.userId = JunMath.parseInt(plan["userId"].toString());
    mdl.omission = "";
    mdl.unqualified = "";
    mdl.unplan = "";
    mdl.inOrder = plan["inOrder"].toString();
    // 计划相关点信息
    mdl.points = new List();
    List<Map<String, dynamic>> pointlst = await dbAccess().getPlanInspectionPoints(db, mdl.planTaskId);
    for (var j = 0; j < pointlst.length; j++) {
      var mdlPoint = new Point();
      var point = pointlst[j];
      mdlPoint.pointId = point["pointId"].toString();
      mdlPoint.name = point["name"].toString();
      mdlPoint.pointNO = point["pointNO"].toString();
      mdlPoint.offline = point["offline"]=="true";
      mdlPoint.status = point["status"].toString(); // 0：未开始，
      mdlPoint.isFixed = point["isFixed"].toString();
      mdlPoint.orderNo = JunMath.parseInt(point["orderNo"].toString());
      mdlPoint.planTaskId = point["planTaskId"].toString();
      // 冗余计划相关字段
      var planTask = new OfflinePlanTask();
      planTask.beginTime = JunMath.parseInt(mdl.beginTime);
      planTask.endTime = JunMath.parseInt(mdl.endTime);
      planTask.planName = mdl.taskName;
      planTask.pointName = mdlPoint.name;
      planTask.pointNo = mdlPoint.pointNO;
      mdlPoint.planTask = planTask;

      // 处理检查项
      mdlPoint.inputItems = new List();
      var jsonItems = json.decode(point["inputItems"]);
      for (var item in jsonItems) {
        var mdlItem = new InputItem();
        mdlItem.id = item["id"].toString();
        mdlItem.createDate = item["createDate"].toString();
        mdlItem.catalogId = item["catalogId"].toString();
        mdlItem.createBy = item["createBy"].toString();
        mdlItem.dataJson = item["dataJson"].toString();
        mdlItem.defaultValue = item["defaultValue"].toString();
        mdlItem.inputJson = item["inputJson"].toString();
        mdlItem.isMultiline = item["isMultiline"].toString();
        mdlItem.isMust = item["isMust"].toString();
        mdlItem.isScore = item["isScore"].toString();
        mdlItem.itemType = item["itemType"].toString();
        mdlItem.name = item["name"].toString();
        mdlItem.orderNo = item["orderNo"].toString();
        mdlItem.orgCode = item["orgCode"].toString();
        mdlItem.pictureJson = item["pictureJson"].toString();
        mdlItem.remark = item["remark"].toString();
        mdlItem.isDelete = item["isDelete"].toString();
        mdlItem.pOrderNo = item["pOrderNo"].toString();
        mdlItem.pointItemId = item["pointItemId"].toString();
        mdlItem.classifyNames = item["classifyNames"].toString();
        mdlItem.classifyIds = item["classifyIds"].toString();
        // 放到point
        mdlPoint.inputItems.add(mdlItem);
      }

      // 处理检查项分类
      mdlPoint.classifis = new List();
      var jsonClassify = json.decode(point["classify"]);
      for (var cls in jsonClassify) {
        if(cls != null){
          var mdlCls = new Classify();
          mdlCls.id = cls["id"].toString();
          mdlCls.name = cls["name"].toString();
          mdlCls.pointId = cls["pointId"].toString();
          mdlCls.orderNo = cls["orderNo"].toString();
          // 放到point
          mdlPoint.classifis.add(mdlCls);
        }
      }
      // 放到计划中
      mdl.points.add(mdlPoint);
    }
    return mdl;
  } catch (e) {
    throw e;
  }
}



Future<List> getOfflinePointList(List<Map<String, dynamic>> lst) async {
  try {
    List<Point> plist = new List();
    for (var point in lst) {
      var mdlPoint = new Point();
      mdlPoint.pointId = point["pointId"].toString();
      mdlPoint.name = point["pointName"].toString();
      mdlPoint.pointNO = point["pointNo"].toString();
      mdlPoint.offline = point["offline"]=="true";
      mdlPoint.status = point["status"].toString();
      mdlPoint.isFixed = point["isFiexed"].toString();
      mdlPoint.level = point["level"].toString();

      if(null != point["routeName"] && point["routeName"] != "null"){
        mdlPoint.routeName = point["routeName"].toString();
      }else{
        mdlPoint.routeName = "";
      }

      if(null != point["classifyNames"] && point["classifyNames"] != "null"){
        mdlPoint.classifyNames = point["classifyNames"].toString();
      }else{
        mdlPoint.classifyNames = "";
      }

      if(null != point["departmentName"] && point["departmentName"] != "null"){
        mdlPoint.departmentName = point["departmentName"].toString();
      }else{
        mdlPoint.departmentName = "";
      }

      if(null != point["chargePerson"] &&  point["chargePerson"] != "null"){
        mdlPoint.chargePerson = point["chargePerson"].toString();
      }else{
        mdlPoint.chargePerson = "";
      }
      mdlPoint.inputItems = new List();
      var jsonItems = json.decode(point["inputItems"]);
      for (var item in jsonItems) {
        var mdlItem = new InputItem();
        mdlItem.id = item["id"].toString();
        mdlItem.createDate = item["createDate"].toString();
        mdlItem.catalogId = item["catalogId"].toString();
        mdlItem.createBy = item["createBy"].toString();
        mdlItem.dataJson = item["dataJson"].toString();
        mdlItem.defaultValue = item["defaultValue"].toString();
        mdlItem.inputJson = item["inputJson"].toString();
        mdlItem.isMultiline = item["isMultiline"].toString();
        mdlItem.isMust = item["isMust"].toString();
        mdlItem.isScore = item["isScore"].toString();
        mdlItem.itemType = item["itemType"].toString();
        mdlItem.name = item["name"].toString();
        mdlItem.orderNo = item["orderNo"].toString();
        mdlItem.orgCode = item["orgCode"].toString();
        mdlItem.pictureJson = item["pictureJson"].toString();
        mdlItem.remark = item["remark"].toString();
        mdlItem.isDelete = item["isDelete"].toString();
        mdlItem.pOrderNo = item["pOrderNo"].toString();
        mdlItem.pointItemId = item["pointItemId"].toString();
        mdlItem.classifyNames = item["classifyNames"].toString();
        mdlItem.classifyIds = item["classifyIds"].toString();
        mdlPoint.inputItems.add(mdlItem);
      }
      mdlPoint.classifis = new List();
      var jsonClassify = json.decode(point["classify"]);
      for (var cls in jsonClassify) {
        var mdlCls = new Classify();
        mdlCls.id = cls["classifyId"].toString();
        mdlCls.name = cls["classifyName"].toString();
        mdlCls.pointId =  cls["pointId"].toString();
        mdlPoint.classifis.add(mdlCls);
      }
      plist.add(mdlPoint);
    }
    return plist;
  } catch (e) {
    throw e;
  }
}

//// 巡检点检查详情
//Future<CheckPointDetail> queryCheckPointDetail(num id) async{
//  CheckPointDetail resultData;
//  List<CheckInput> checkInputs = List();
//  List<String> pointImgUrls = List();
//  var data = await HttpUtil().get(ApiAddress.GET_QUERY_CHECK_POINT_DETAIL,data:{"checkId":id});
//  if(data["result"] == "SUCCESS"){
//    var dataList = data["dataList"];
//    var _checkInputs = dataList["checkInput"];
//    if(_checkInputs != null){
//      for(var d in _checkInputs){
//        checkInputs.add(CheckInput.fromJson(d));
//      }
//    }
//
//    var _pointImgUrls = dataList["pointImgUrls"];
//    if(_pointImgUrls != null){
//      for(var d in _pointImgUrls){
//        pointImgUrls.add(d.toString());
//      }
//    }
//
//    resultData = CheckPointDetail.fromJson(dataList);
//    resultData.checkInputs = checkInputs;
//    resultData.pointImgUrls = pointImgUrls;
//    return resultData;
//  }else{
//    return resultData;
//  }
//}
//

//Future<PlanTaskDetail> queryPlanTaskById(num id) async{
//  PlanTaskDetail resultData;
//  List<Point> points = List();
//  var data = await HttpUtil().get(ApiAddress.QUERYPLANTASKBYID,data:{"planTaskId":id});
//  if(data["result"] == "SUCCESS"){
//    var dataList = data["dataList"];
//    var _points = dataList["points"];
//    for(var d in _points){
//      points.add(Point.fromJson(d));
//    }
//    resultData = PlanTaskDetail.fromJson(dataList["planTask"]);
//    resultData.points = points;
//    return resultData;
//  }else{
//    return resultData;
//  }
//}

//
//// 未开始巡检点，点击获取巡检点详情
//Future<CheckPointDetail> queryPointPlanTaskDetail(num planTaskId,num pointId) async{
//  var data = await HttpUtil().get(ApiAddress.QUERY_POINT_PLANTASK_DETAIL,
//      data:{"planTaskId":planTaskId,"pointId":pointId});
//  print(data);
//  if (data["result"] == "SUCCESS" ) {
//    CheckPointDetail rst = CheckPointDetail.fromJson(data["dataList"]);
//    List<CheckInput> checkInputs = List();
//    for(var c in data["dataList"]["checkInput"]){
//      checkInputs.add(CheckInput.fromJson(c));
//    }
//    rst.checkInputs = checkInputs;
//    return rst;
//  }
//  return null;
//}

class JunMath {
  static int parseInt(String str) {
    try {
      if (str == null) return 0;
      if (str == "null") return 0;
      return int.parse(str);
    } catch (e) {
      return 0;
    }
  }
}
