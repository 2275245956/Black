import 'dart:convert' show json;

import 'package:intelligent_check_new/model/PageDto.dart';
import 'package:intelligent_check_new/model/plan_inspection/check_point_detail.dart';
import 'package:intelligent_check_new/model/plan_inspection/plan_task_detail.dart';
import 'package:intelligent_check_new/model/plan_list_input.dart';
import 'package:intelligent_check_new/services/api_address.dart';
import 'package:intelligent_check_new/tools/HttpUtil.dart';
import 'dart:async';

Future<PageDto> getPlanListOutputList(PlanListInput planListInput,num pageIndex) async {
  try {
//    List<PlanListOutput> planListOutputList = new List();
    // 根据输入参数拼接请求body
    List<Map> request = new List();

    // 用户ID
    if(null != planListInput.userId && -1 != planListInput.userId){
      request.add({"name": "userId", "value" :planListInput.userId});
    }
    // 开始时间
    if(null != planListInput.startTime && "" != planListInput.startTime){
      request.add({"name": "startTime", "value" :planListInput.startTime});
    }
    // 结束时间
    if(null != planListInput.endTime && "" != planListInput.endTime){
      request.add({"name": "endTime", "value" :planListInput.endTime});
    }
    // 状态
    if(null != planListInput.finishStatus && -1 != planListInput.finishStatus){
      request.add({"name": "finishStatus", "value" :planListInput.finishStatus});
    }
    // 排序
    if(null != planListInput.orderBy && "" != planListInput.orderBy){
      request.add({"name": "orderBy", "value" :planListInput.orderBy});
    }
    // 部门
    if(null != planListInput.departmentId){
      request.add({"name": "departmentId", "value" :planListInput.departmentId});
    }
    //
    if(null != planListInput.routeId && -1 != planListInput.routeId){
      request.add({"name": "routeId", "value" :planListInput.routeId});
    }

    print(request);
    // 调用接口查询数据
    var data = await HttpUtil().post(ApiAddress.QUERYPLANTASK+"?pageNumber=$pageIndex", data: json.encode(request));
    PageDto pageDto;
    if (data["result"] == "SUCCESS" ) {
      if(data["dataList"].toString()!="[]"){
        pageDto = PageDto.fromJson(data["dataList"]);
      }
    }
    return pageDto;
  } catch (e) {
    throw e;
  }
}

Future<PageDto> getPlanListForSelect(String queryType, int pageIndex,int pageSize,
    PlanListInput planListInput,{String keywords}) async {
  try {

    // 根据输入参数拼接请求body
    List<Map> request = new List();
    if(null != queryType){
      request.add({"name":"queryType" , "value":queryType});
    }

    if(null != keywords){
      request.add({"name":"query", "value": keywords});
    }

    // 用户ID
    if(null != planListInput.userId && -1 != planListInput.userId){
      request.add({"name": "userId", "value" :planListInput.userId});
    }
    // 开始时间
    if(null != planListInput.startTime && "" != planListInput.startTime){
      request.add({"name": "startTime", "value" :planListInput.startTime});
    }
    // 结束时间
    if(null != planListInput.endTime && "" != planListInput.endTime){
      request.add({"name": "endTime", "value" :planListInput.endTime});
    }
    // 状态
    if(null != planListInput.finishStatus && -1 != planListInput.finishStatus){
      request.add({"name": "finishStatus", "value" :planListInput.finishStatus});
    }
    // 排序
    if(null != planListInput.orderBy && "" != planListInput.orderBy){
      request.add({"name": "orderBy", "value" :planListInput.orderBy});
    }
    // 部门
    if(null != planListInput.departmentId){
      request.add({"name": "departmentId", "value" :planListInput.departmentId});
    }
    //
    if(null != planListInput.routeId && -1 != planListInput.routeId){
      request.add({"name": "routeId", "value" :planListInput.routeId});
    }

//    print(request);
    // 调用接口查询数据
    var data = await HttpUtil().post(ApiAddress.QUERYPLANTASK+"?pageNumber=$pageIndex", data: json.encode(request));
    PageDto pageDto;
    if (data["result"] == "SUCCESS" ) {
      if(data["dataList"].toString()!="[]"){
        pageDto = PageDto.fromJson(data["dataList"]);
      }
    }
    return pageDto;
  } catch (e) {
    throw e;
  }
}

// 巡检点检查详情
//Future<CheckPointDetail> queryCheckPointDetail(num id) async{
//  CheckPointDetail resultData;
//  List<CheckInput> checkInputs = List();
//  List<String> pointImgUrls = List();
//  var data = await HttpUtil().get(ApiAddress.GET_QUERY_CHECK_POINT_DETAIL,data:{"checkId":id});
//  if(data["result"] == "SUCCESS"){
//    var dataList = data["dataList"];
//    var _checkInputs = dataList["appCheckInput"]["other"];
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

/////// new
Future<CheckPointDetail > queryCheckPointDetail(num id) async{
//  Map<String,List<CheckPointDetail>> resultData1 = Map();
  CheckPointDetail resultData = CheckPointDetail.fromParams();


  List<String> pointImgUrls = List();
  var data = await HttpUtil().get(ApiAddress.GET_QUERY_CHECK_POINT_DETAIL,data:{"checkId":id});
  if(data["result"] == "SUCCESS"){

    var dataList = data["dataList"];

    resultData = CheckPointDetail.fromParams(checkId:dataList["checkId"] ,checkTime: dataList["checkTime"],
        pointId: dataList["pointId"],departmentName: dataList["departmentName"],planName: dataList["planName"],
        pointName: dataList["pointName"],pointNo: dataList["pointNo"],pointStatus:dataList["pointStatus"],username:  dataList["username"],remark:dataList["remark"]);


    var _checkInputs = dataList["appCheckInput"];
    if(_checkInputs != null){
      for(var d in _checkInputs.keys){
        List<CheckInput> checkInputs = List();
        for(var item in _checkInputs[d]){
          checkInputs.add(CheckInput.fromJson(item));
        }
        resultData.checkInputs[d] = checkInputs;
      }
    }

    var _pointImgUrls = dataList["pointImgUrls"];
    if(_pointImgUrls != null){
      for(var d in _pointImgUrls){
        pointImgUrls.add(d.toString());
      }
    }

//    resultData = CheckPointDetail.fromJson(dataList);
//    resultData.checkInputs = checkInputs;
    resultData.pointImgUrls = pointImgUrls;
    return resultData;
  }else{
    return resultData;
  }
}

Future<PlanTaskDetail> queryPlanTaskById(num id) async{
  PlanTaskDetail resultData;
  List<Point> points = List();
  var data = await HttpUtil().get(ApiAddress.QUERYPLANTASKBYID,data:{"planTaskId":id});
  if(data["result"] == "SUCCESS"){
    var dataList = data["dataList"];
    var _points = dataList["points"];
    for(var d in _points){
      points.add(Point.fromJson(d));
    }
    resultData = PlanTaskDetail.fromJson(dataList["planTask"]);
    resultData.points = points;
    return resultData;
  }else{
    resultData = PlanTaskDetail.fromParams();
    resultData.message = data["message"];
    return resultData;
  }
}

// 未开始巡检点，点击获取巡检点详情
Future<CheckPointDetail> queryPointPlanTaskDetail(num planTaskId,num pointId) async{
  var data = await HttpUtil().get(ApiAddress.QUERY_POINT_PLANTASK_DETAIL,
      data:{"planTaskId":planTaskId,"pointId":pointId});
//  print(data);
  if (data["result"] == "SUCCESS" ) {
    CheckPointDetail rst = CheckPointDetail.fromJson(data["dataList"]);
//    List<CheckInput> checkInputs = List();
//    for(var c in data["dataList"]["checkInput"]){
//      checkInputs.add(CheckInput.fromJson(c));
//    }
//    rst.checkInputs["other"] = checkInputs;
//    rst.checkInputs = checkInputs;
    if(data["dataList"]["appCheckInput"] != null){
      for(var d in data["dataList"]["appCheckInput"].keys){
        List<CheckInput> checkInputs = List();
        for(var item in data["dataList"]["appCheckInput"][d]){
          checkInputs.add(CheckInput.fromJson(item));
        }
        //checkInputs.add(CheckInput.fromJson(d));
//        print(d);
        rst.checkInputs[d] = checkInputs;
      }
    }


    List<String> pointImgUrls = List();
    var _pointImgUrls = data["dataList"]["pointImgUrls"];
    if(_pointImgUrls != null){
      for(var d in _pointImgUrls){
        pointImgUrls.add(d.toString());
      }
    }
    rst.pointImgUrls = pointImgUrls;


    return rst;
  }else{
    CheckPointDetail rst = CheckPointDetail.fromParams();
    rst.message = data["message"];
    return rst;
  }
//  return null;
}