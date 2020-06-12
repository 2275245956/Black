import 'dart:convert';
import 'package:intelligent_check_new/model/ExtClass.dart';
import 'package:intelligent_check_new/tools/HttpUtil.dart';
import 'package:intelligent_check_new/services/api_address.dart';
//获取全部扩展分类列表
Future<List<ExtClass>> queryCatalogList() async {
  try {
    // 根据输入参数拼接请求body
    List<Map> request = new List();
    List<ExtClass> result = new List();
    var data = await HttpUtil().get(ApiAddress.QUERY_CATALOG_LIST,data: json.encode(request));
    //具体实现函数待编写
    if (data["result"] == "SUCCESS" ) {
      var dataList = data["dataList"];
      for(var _dataList in dataList) {
        result.add(ExtClass.fromJson(_dataList));
      }
    }
    return result;
  } catch (e) {
    print(e);
    return new List();
  }
}
