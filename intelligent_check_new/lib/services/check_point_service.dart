import 'dart:convert';
import 'package:intelligent_check_new/model/APIResponse.dart';
import 'package:intelligent_check_new/model/CheckExecute/QueryCheckDetail.dart';
import 'package:intelligent_check_new/model/CheckPointDetail.dart';
import 'package:intelligent_check_new/model/MovePointAddModel.dart';
import 'package:intelligent_check_new/model/PageDto.dart';
import 'package:intelligent_check_new/tools/HttpUtil.dart';
import 'package:intelligent_check_new/services/api_address.dart';

//获取巡检点列表 Routeid：路线ID
Future<PageDto> queryPointPage(int routeId, int pageIndex, int pageSize,
    {String keywords}) async {
  try {
    // 根据输入参数拼接请求body
    List<Map> request = new List();
    if (null != routeId && routeId > 0) {
      request.add({"name": "routeId", "value": routeId});
    }

    if (null != keywords) {
      request.add({"name": "query", "value": keywords});
      request.add({"name": "queryType", "value": "point"});
    }

    var data = await HttpUtil().post(
        ApiAddress.QUERY_POINT_BY_PAGE +
            "?pageSize=" +
            ((null == pageSize || 0 == pageSize) ? 10 : pageSize).toString() +
            "&pageNumber=" +
            ((null == pageIndex || 0 == pageIndex) ? 0 : pageIndex).toString(),
        data: json.encode(request));
    PageDto pageDto;
    //具体实现函数待编写
    if (data["result"] == "SUCCESS") {
      pageDto = PageDto.fromJson(data["dataList"]);
    }
    return pageDto;
  } catch (e) {
    throw (e);
  }
}

Future<PageDto> queryPointPages(int pageIndex, int pageSize,
    {String keywords, String level}) async {
  try {
    List<Map> request = new List();
    if (keywords != null && keywords != "") {
      request.add({"name": "name", "value": keywords, "type": "8"});
    }

    if (level != null && level != "" && level != "-1") {
      request.add({"name": "level", "value": level, "type": "3"});
    }
    // 根据输入参数拼接请求body
    var data = await HttpUtil().post(
        ApiAddress.QUERY_POINT_BY_PAGE +
            "?pageSize=$pageSize" +
            "&pageNumber=$pageIndex",
        data: json.encode(request));

    PageDto pageDto;
    //具体实现函数待编写
    if (data["result"] == "SUCCESS") {
      pageDto = PageDto.fromJson(data["dataList"]);
    }
    return pageDto;
  } catch (e) {
    throw (e);
  }
}

Future<PageDto> queryPointPageForSearch(
    String queryType, int pageIndex, int pageSize,
    {String keywords, bool isFix = true}) async {
  try {
    // 根据输入参数拼接请求body
    List<Map> request = new List();
    if (null != queryType) {
      request.add({"name": "queryType", "value": queryType});
    }

    if (null != keywords) {
      request.add({"name": "query", "value": keywords});
    }

    if (!isFix) {
      request.add({"name": "isFixed", "value": "0"});
    }

    var data = await HttpUtil().post(
        ApiAddress.QUERY_POINT_BY_PAGE +
            "?pageSize=" +
            ((null == pageSize || 0 == pageSize) ? 10 : pageSize).toString() +
            "&pageNumber=" +
            ((null == pageIndex || 0 == pageIndex) ? 0 : pageIndex).toString(),
        data: json.encode(request));
    PageDto pageDto;
    //具体实现函数待编写
    if (data["result"] == "SUCCESS") {
      pageDto = PageDto.fromJson(data["dataList"]);
    }
    return pageDto;
  } catch (e) {
    throw (e);
  }
}

Future<APIResponse> queryPointLevel() async {
  try {
    var data = await HttpUtil().post(ApiAddress.PLANLEVEL);
    return APIResponse.fromJson(data);
  } catch (e) {
    print("error,============$e");
    return APIResponse.error("获取等级失败");
  }
}

//获取巡检点详情 pointId：巡检点ID
Future<CheckPointDetail> getCheckPointDetail(int pointId) async {
  try {
    Map request = new Map();
    // 如果巡检点存在
    if (null != pointId && pointId > 0) {
      var data = await HttpUtil().get(
          ApiAddress.GET_POINT_DETAIL_BY_ID + "?pointId=" + pointId.toString(),
          data: json.encode(request));
      //具体实现函数待编写
      if (data["result"] == "SUCCESS") {
        return CheckPointDetail.fromJson(data["dataList"]);
      }
    }
    return null;
  } catch (e) {
    throw (e);
  }
}

// 设置离线巡检
Future setPatrolMode(int pointId, bool isOffine) async {
  try {
    Map request = new Map();
    // 如果巡检点存在
    if (null != pointId && pointId > 0 && null != isOffine) {
      var data = await HttpUtil().post(
          ApiAddress.SET_PATROL_MODE +
              "?pointId=" +
              pointId.toString() +
              "&isOffine=" +
              isOffine.toString(),
          data: json.encode(request));
      //具体实现函数待编写
      if (data["result"] == "SUCCESS") {
        return true;
      }
    }
    return false;
  } catch (e) {
    throw (e);
  }
}

// 保存巡检点信息
Future<APIResponse> addMovePoint(MovePointAddModel movePoint) async {
  try {
    // 如果巡检点存在
    if (null != movePoint) {
      print(movePoint.toString());
      var data = await HttpUtil()
          .post(ApiAddress.ADD_MOVE_POINT, data: movePoint.toString());
      //具体实现函数待编写
      if (data["result"] == "SUCCESS") {
        return APIResponse(data);
      }
    }
    return APIResponse.error("保存失败！");
  } catch (e) {
    return APIResponse.error("操作失败！");
  }
}

// 巡检记录详情
Future<QueryCheckDetail> getQueryCheckDetail(num checkId) async {
  QueryCheckDetail queryCheckDetail = QueryCheckDetail();
  QueryCheckDetailCheckInfo checkInfo;
  var data = await HttpUtil()
      .get(ApiAddress.QUERY_CHECK_DETAIL, data: {"checkId": checkId});
  if (data["result"] == "SUCCESS") {
    if (data["dataList"].toString() != "[]") {
      var dataList = data["dataList"];
      if (dataList["check"] != null) {
        checkInfo = QueryCheckDetailCheckInfo.fromJson(dataList["check"]);
      }
      List<QueryCheckDetailInputItem> inputItems = List();
      for (var item in dataList["inputItems"]) {
        inputItems.add(QueryCheckDetailInputItem.fromJson(item));
      }
      queryCheckDetail.inputItems = inputItems;
      queryCheckDetail.checkInfo = checkInfo;
    }
  }

  return queryCheckDetail;
}

Future<List> queryAllPotinNos() async {
  List<String> result = new List();
  try {
    Map request = new Map();
    var data = await HttpUtil()
        .get(ApiAddress.QUERY_POINTNO, data: json.encode(request));
    //具体实现函数待编写
    if (data["result"] == "SUCCESS") {
      var dataList = data["dataList"];
      if (dataList != null && dataList.toString() != "[]") {
        for (var _item in dataList) {
          result.add(_item);
        }
      }
    }
  } catch (e) {}
  return result;
}
