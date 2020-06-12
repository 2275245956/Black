import 'dart:convert' show json;
import 'package:intelligent_check_new/model/APIResponse.dart';
import 'package:intelligent_check_new/model/PageDto.dart';
import 'package:intelligent_check_new/model/SecurityRiskJudgement/SecurityRiskModel.dart';
import 'package:intelligent_check_new/services/api_address.dart';
import 'package:intelligent_check_new/tools/HttpUtil.dart';

//列表查询
Future<PageDto> getSecurityRiskList(
  int pageNumber,
  int pageSize,
  int executorType,
  String beginTime,
  String endTime,
  int status,
) async {
  try {
    var data = await HttpUtil().get(ApiAddress.SECURITY_RISK_LIST +
        "?pageNumber= $pageNumber&pageSize= $pageSize&executorType=$executorType&beginTime=$beginTime&endTime=$endTime&status=$status");

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

Future<SecurityRiskListModel> getSecurityRiskDetail(int id) async {
  try {
    var data = await HttpUtil().get(ApiAddress.SECURITY_RISK_DETAIL + "?id= $id");
    SecurityRiskListModel model;
    //具体实现函数待编写
    if (data["result"] == "SUCCESS") {
      model = SecurityRiskListModel.fromJson(data["dataList"]);
    } else {
      model = SecurityRiskListModel.fromJson({});
    }
    return model;
  } catch (e) {
    throw e;
  }
}


Future<APIResponse> getJudgementItems(int taskId,int type,int level,int itemId) async {
  try {

    String requestStr=ApiAddress.SECURITY_RISK_RUN + "?taskId= $taskId&type=$type&level=$level";
    if(itemId!=null)
      requestStr=requestStr+"&itemId=$itemId";
    var data=await new HttpUtil().get(requestStr);
    return  APIResponse.fromJson(data);

  }catch(e){
    print(e);
    throw e;
  }


}

Future<APIResponse> saveRecordTable(SubmitDataModel sendData) async{
  try {

    var data=await new HttpUtil().post(ApiAddress.SECURITY_RISK_RECORD, data: json.encode(json.decode(sendData.toString())));
   if(data["success"]){
     return  APIResponse.success("操作成功！");
   }else{
     return  APIResponse.success(data["message"] ??"操作失败！");
   }

  }catch(e){
    print(e);
    throw e;
  }

}


Future<APIResponse> saveTaskStatus(int taskId) async{
  try{

    var data=await new HttpUtil().post(ApiAddress.SECURITY_RISK_UPDATETASKSTATUS+"?taskId=$taskId",);
    return APIResponse.fromJson(data);
  }catch(e){
    throw e;
  }

}
