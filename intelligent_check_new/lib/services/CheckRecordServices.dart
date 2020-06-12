import 'dart:convert' show json;
import 'package:dio/dio.dart';
import 'package:intelligent_check_new/model/APIResponse.dart';
import 'package:intelligent_check_new/model/CheckExecute/check_point_record_list.dart';
import 'package:intelligent_check_new/model/CheckExecute/query_point_detail.dart';
import 'package:intelligent_check_new/model/CheckRecordDto.dart';
import 'package:intelligent_check_new/model/MovePointAttachment.dart';
import 'package:intelligent_check_new/model/plan_list_input.dart';
import 'package:intelligent_check_new/services/api_address.dart';
import 'package:intelligent_check_new/tools/HttpUtil.dart';

Future<APIResponse> saveCheckRecord(CheckRecordDto dto) async {
  try {
    if(null == dto){
      return APIResponse.error("必填参数不能为空！");
    }
    var data = await HttpUtil().post(ApiAddress.SAVE_CHECK_RECORD, data: dto.toString());
    return APIResponse(data);
  } catch (e) {
    return APIResponse.error("保存失败！");
  }
}
Future<APIResponse> uploadAttachFile(List<Attachment> fileList,int checkId,int pointId) async {
  try {
    if(null == fileList || null == checkId || null == pointId){
      return APIResponse.error("必填参数不能为空！");
    }
    // 循环上传
    fileList.forEach((attach) {
      var uploadUrl = ApiAddress.UPLOAD_CHECK_FILE + "?checkId=" + checkId.toString() + "&pointId=" + pointId.toString()+"&classifyId=${attach.classifyIds}";
      // 如果有ItemId
      if(null != attach.itemId){ // 检查项的图片
        uploadUrl += "&inputItemId=" + attach.itemId.toString() + "&name=" + attach.name;
      }
      String filename = attach.file.path.substring(attach.file.path.lastIndexOf("/") + 1);
      // 开始上传
      FormData formData = new FormData.from({
        "file":new UploadFileInfo(attach.file, filename)
      });
      var data = HttpUtil().post(uploadUrl, data: formData);
    });
    return APIResponse.success("保存成功！");
  } catch (e) {
    return APIResponse.error("保存失败！");
  }
}

// 安全执行--记录--巡检点名称
Future<Map<String,List<CheckPointRecordDetail>>> getCheckPointRecordList(PlanListInput planListInput,num pointId) async {
  try {
//    List<PlanListOutput> planListOutputList = new List();
    // 根据输入参数拼接请求body
    List<Map> request = new List();

    // 用户ID
    if(null != planListInput.userId && -1 != planListInput.userId){
      request.add({"name": "userId", "value" :planListInput.userId});
    }

    // 状态
    if(null != planListInput.finishStatus && -1 != planListInput.finishStatus){
//      request.add({"name": "finishStatus", "value" :planListInput.finishStatus});
      request.add({"name": "isOk", "value" :planListInput.finishStatus});
    }

    // 开始时间
    if(null != planListInput.startTime && "" != planListInput.startTime){
      request.add({"name": "startTime", "value" :planListInput.startTime + " 00:00:00"});
    }

    // 结束时间
    if(null != planListInput.endTime && "" != planListInput.endTime){
      request.add({"name": "endTime", "value" :planListInput.endTime + " 23:59:59"});
    }

    // 部门
    if(null != planListInput.departmentId && -1 != planListInput.departmentId){
      request.add({"name": "departmentId", "value" :planListInput.departmentId});
    }

    // 线路
    if(null != planListInput.routeId && -1 != planListInput.routeId){
      request.add({"name": "routeId", "value" :planListInput.routeId});
    }

    request.add({"name": "pointId", "value" :pointId});

//    print(json.encode(request));

    Map<String,List<CheckPointRecordDetail>> rst = Map();

    // 调用接口查询数据
    var data = await HttpUtil().post(ApiAddress.CHECK_POINT_RECORD_LIST, data: json.encode(request));
    //具体实现函数待编写
    if (data["result"] == "SUCCESS" ) {
      if(data["dataList"].toString()!="[]"){
//        print(data["dataList"]);
       Map<String,dynamic> _data = data["dataList"];
       _data.forEach((k,v){
         List<CheckPointRecordDetail> detailLst = List();
         for(var _detail in v){
           detailLst.add(CheckPointRecordDetail.fromJson(_detail));
         }
         rst[k] = detailLst;
       });
      }
    }
    return rst;
  } catch (e) {
    throw e;
  }
}

// 巡检点详情
Future<QueryPointDetail> getQueryPointDetail(num pointId) async{

  QueryPointDetail detail = QueryPointDetail();

  var dataRst = await HttpUtil().get(ApiAddress.GET_POINT_DETAIL_BY_ID+"?pointId=$pointId");
  if (dataRst["result"] == "SUCCESS" ) {
    if(dataRst["dataList"].toString()!="[]"){
      var data = dataRst["dataList"];
      PointInfo pointInfo = PointInfo.fromJson(data["point"]);
      // TODO:
      for(var key in data["inputItems"].keys){
        List<InputItems> inputItems = List();
        for(var item in data["inputItems"][key]){
          inputItems.add(InputItems.fromParams(inputItenName: item["name"]));
        }
        detail.inputItems[key] =  inputItems;
      }

//      List<Classify> classifies =List();
//      for(var classify in data["classify"]){
//        classifies.add(Classify.fromJson(classify));
//      }

      List<Route> routs = List();
      for(var route in data["routes"]){
        routs.add(Route.fromJson(route));
      }

      detail.pointInfo = pointInfo;
//      detail.inputItems = inputItems;
//      detail.classifies = classifies;
      detail.routs = routs;
    }
  }
  return detail;
}

//固有风险点详情
Future<InherentPointDetail> getInherentPointDetail(num pointId) async{

  InherentPointDetail detail = InherentPointDetail.fromParams();

  var dataRst = await HttpUtil().get(ApiAddress.GET_POINT_DETAIL_BY_ID_MOBILE+"?pointId=$pointId");
  if (dataRst["result"] == "SUCCESS" ) {

      var data = dataRst["dataList"];
      detail=InherentPointDetail.fromJson(data);

  }
  return detail;
}

//设备详情
Future<EquipmentDetail> getEquipmentDetail(num equipmentId) async{

  EquipmentDetail detail = EquipmentDetail.fromParams();

  var dataRst = await HttpUtil().get(ApiAddress.GET_Equipment_DETAIL_BY_ID+"?equipmentId=$equipmentId");
  if (dataRst["result"] == "SUCCESS" ) {

    var data = dataRst["dataList"];
    detail=EquipmentDetail.fromJson(data);

  }
  return detail;
}
//危险因素详情
Future<RiskFactorsDetail> getRiskFactorsDetail(num riskId) async{

  RiskFactorsDetail detail = RiskFactorsDetail.fromParams();
  try{
    var dataRst = await HttpUtil().get(ApiAddress.GET_RISKFACTORS_DETAIL_BY_ID+"?riskFactorId=$riskId");
    if (dataRst["result"] == "SUCCESS" ) {

      var data = dataRst["dataList"];
      detail=RiskFactorsDetail.fromJson(data);

    }
    return detail;
  }catch(e){
    throw e;
  }

}