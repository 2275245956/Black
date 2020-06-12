import 'dart:async';
import 'dart:convert';
import 'package:intelligent_check_new/model/PageDto.dart';
import 'package:intelligent_check_new/services/api_address.dart';
import 'package:intelligent_check_new/tools/HttpUtil.dart';

// 分页查询检查项
Future<PageDto> queryItemByPage(String keywords, String itemType, int itemCagetoryId, [num pageNumber,num pageSize=10]) async {
  try {
    // 根据输入参数拼接请求body
    List<Map> request = new List();

    if(null != keywords && keywords.isNotEmpty){
      request.add({"name" : "name", "value" : keywords});
    }
    if(null != itemType && itemType.isNotEmpty){
      request.add({"name" : "itemType", "value" : itemType});
    }
    if(null != itemCagetoryId && itemCagetoryId > 0){
      request.add({"name" : "catalogId", "value" : itemCagetoryId});
    }

    var data = await HttpUtil().post(ApiAddress.QUERY_ITEM_BY_PAGE
        + "?pageSize=" + ((null == pageSize || 0 == pageSize) ? 10 : pageSize).toString()
        + "&pageNumber=" + ((null == pageNumber || 0 == pageNumber) ? 0 : pageNumber).toString(),
        data: json.encode(request));

    PageDto pageDto;
    //具体实现函数待编写
    if (data["result"] == "SUCCESS" ) {
      pageDto = PageDto.fromJson(data["dataList"]);
    }else{
      pageDto = PageDto.fromJson({});
    }
    return pageDto;
  } catch (e) {
    throw (e);
  }
}