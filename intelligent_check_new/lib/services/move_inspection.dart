import 'dart:convert';

import 'package:intelligent_check_new/model/PageDto.dart';
import 'package:intelligent_check_new/services/api_address.dart';
import 'package:intelligent_check_new/tools/HttpUtil.dart';
import 'dart:async';

Future<PageDto> getMoveInspectionList([num pageNumber,num pageSize=10]) async{
  List<Map> request = new List();
  // 查询移动点固定参数 0:移动点，1：固定点
  request.add({"name" : "isFixed", "value" : "0"});
  var data = await HttpUtil().post(ApiAddress.QUERY_POINT_BY_PAGE
      + "?pageSize=" + ((null == pageSize || 0 == pageSize) ? 10 : pageSize).toString()
      + "&pageNumber=" + ((null == pageNumber || 0 == pageNumber) ? 0 : pageNumber).toString(),
      data:json.encode(request));
  if (data["result"] == "SUCCESS" ) {
    return PageDto.fromJson(data["dataList"]);
  }else{
    return null;
  }
}