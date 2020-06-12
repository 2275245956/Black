import 'dart:convert' show json;
import 'package:intelligent_check_new/model/APIResponse.dart';
import 'package:intelligent_check_new/model/Activility/ActivilityStepModel.dart';
import 'package:intelligent_check_new/model/PageDto.dart';
import 'package:intelligent_check_new/services/api_address.dart';
import 'package:intelligent_check_new/tools/HttpUtil.dart';

//列表查询
Future<PageDto> getActivilityList(int pageNumber, int pageSize,
    int canExecuteType, int status, int level, String taskworkName) async {
  try {
    var data = await HttpUtil().get(ApiAddress.ACTIVILITY_LIST +
        "?pageNumber= $pageNumber&pageSize= $pageSize&canExecutorType=$canExecuteType&status=$status&level=$level&taskworkName=$taskworkName");

    PageDto pageDto;
    //具体实现函数待编写
    if (data["result"] == "SUCCESS" && data["dataList"] != null) {
      pageDto = PageDto.fromJson(data["dataList"]);
    } else {
      pageDto = PageDto.fromJson({});
      pageDto.message = data["message"];
    }
    return pageDto;
  } catch (e) {
    throw e;
  }
}

//列表查询
Future<APIResponse> getActivilityDetail(int id) async {
  try {
    var data = await HttpUtil().get(ApiAddress.ACTIVILITY_DETAIL + "?id= $id");
    return APIResponse.fromJson(data);
  } catch (e) {
    throw e;
  }
}

//流程执行
Future<APIResponse> executeFlowActivility(
    int currentFlowRecordId, int type, String remark, dynamic flowJson) async {
  try {
    var jsonData = {
      "currentFlowRecordId": currentFlowRecordId,
      "excuteType": type,
      "flowJson": flowJson,
      "remark": remark
    };
    var data = await HttpUtil()
        .post(ApiAddress.ACTIVILITY_EXECUTE, data: json.encode(jsonData));
    return APIResponse.fromJson(data);
  } catch (e) {
    throw e;
  }
}

//步骤清单
Future<APIResponse> getStepsList(int id) async {
  try {
    var data =
        await HttpUtil().get(ApiAddress.ACTIVILITY_STEPS + "?taskworkId=$id");
    return APIResponse.fromJson(data);
  } catch (e) {
    throw e;
  }
}

//步骤详情
Future<APIResponse> getStepsDetail(int id) async {
  try {
    var data = await HttpUtil()
        .get(ApiAddress.ACTIVILITY_STEPS_DETAIL + "?taskworkContentId=$id");
    return APIResponse.fromJson(data);
  } catch (e) {
    throw e;
  }
}

//获取步骤清单的详细信息
Future<APIResponse> getStepsAllInfo(int id) async {
  try {
    var data = await HttpUtil()
        .get(ApiAddress.ACTIVILITY_STEPS_DETAIL_AND_LIST + "?id=$id");
    return APIResponse.fromJson(data);
  } catch (e) {
    throw e;
  }
}

//启动执行
Future<APIResponse> startFlow(String ids) async {
  try {
    var data = await HttpUtil()
        .get(ApiAddress.ACTIVILITY_STARTFLOW + "?taskworkIds=$ids");
    return APIResponse.fromJson(data);
  } catch (e) {
    throw e;
  }
}

Future<APIResponse> getLogInfo(int id) async {
  try {
    var data=await HttpUtil().get(ApiAddress.ACTIVILITY_RUNLOG+"?applyRecordId=$id");
    return APIResponse.fromJson(data);

  } catch (e) {
    throw e;
  }
}

Future<APIResponse> UpdateMeasures(dynamic jsonstr) async{
  try   {
     var data=await HttpUtil().post(ApiAddress.ACTIVILITY_UPDATEMEASURES,data:json.decode(jsonstr.toString()));
     return APIResponse.fromJson(data);
  }catch(e){
    throw e;
  }

}

Future<APIResponse> getDetailTree(int id,int contextId)async{
   try{
     var data=await HttpUtil().get(ApiAddress.ACTIVILITY_TASKWORK_DETAIL+"?id=$id&taskworkContentId=$contextId");
     return APIResponse.fromJson(data);
   }catch(e){
     throw e;
   }

}
