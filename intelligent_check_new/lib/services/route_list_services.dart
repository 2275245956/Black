import 'dart:convert';

import 'package:intelligent_check_new/model/name_value.dart';
import 'package:intelligent_check_new/tools/HttpUtil.dart';
import 'package:intelligent_check_new/services/api_address.dart';
//获取全部任务列表
Future<List<NameValue>> getRouteList() async {
  try {
    // 根据输入参数拼接请求body
    List<Map> request = new List();
    List<NameValue> result = new List();
    var data = await HttpUtil().get(ApiAddress.ROUTE_LIST,data: json.encode(request));
    //具体实现函数待编写
    if (data["result"] == "SUCCESS" ) {
      var dataList = data["dataList"];
      for(var _dataList in dataList) {
        result.add(new NameValue(_dataList["name"], _dataList["id"]));
      }
    }
    return result;
  } catch (e) {
    throw (e);
  }
}
