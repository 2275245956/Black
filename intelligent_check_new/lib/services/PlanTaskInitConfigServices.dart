import 'dart:convert' show json;

import 'package:intelligent_check_new/model/ExtClass.dart';
import 'package:intelligent_check_new/model/PlanTaskInitConfig.dart';
import 'package:intelligent_check_new/services/api_address.dart';
import 'package:intelligent_check_new/tools/HttpUtil.dart';
import 'dart:async';

Future<PlanTaskInitConfig> getInitPlanTaskConfig(int planTaskId, int pointId) async {
  try {
    PlanTaskInitConfig planTaskInitConfig;
    // 根据输入参数拼接请求body
    List<Map> request = new List();
    // 调用接口查询数据
    String url = ApiAddress.INIT_PLAN_TASK + '?pointId=$pointId';
    if(null != planTaskId && planTaskId > 0){
      url = url + "&planTaskId=$planTaskId";
    }
    var data = await HttpUtil().get(url, data: json.encode(request));
    // 请求成功
    if (data["result"] == "SUCCESS" ) {
      if(data["dataList"].toString()!="[]"){
        planTaskInitConfig = PlanTaskInitConfig.fromJson(data["dataList"]);
        if(planTaskInitConfig.extClass != null && planTaskInitConfig.extClass.length > 0){
//          if(planTaskInitConfig.checkItem.where((f)=>f.routePointItemId == null).length > 0){
          if(planTaskInitConfig.checkItem.where((f)=>f.classifyIds == null).length > 0){
            ExtClass cls = ExtClass.fromParams(id:null,name: "其他");
            planTaskInitConfig.extClass.add(cls);
          }
        }
      }
    }else{
      planTaskInitConfig = PlanTaskInitConfig.fromParams();
      planTaskInitConfig.errorMsg = data["message"];
    }
//    print(planTaskInitConfig);
    return planTaskInitConfig;
  } catch (e) {
    throw e;
  }
}