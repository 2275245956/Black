import 'dart:convert' show json;
import 'package:intelligent_check_new/model/InspectionRecordModel.dart';
import 'package:intelligent_check_new/model/PageDto.dart';
import 'package:intelligent_check_new/services/api_address.dart';
import 'package:intelligent_check_new/tools/HttpUtil.dart';

Future<PageDto> getInspectionRecordList(InspectionRecordFilter filter,num pageNumber)
  async{
  try{
    // 根据输入参数拼接请求body
    List<Map> request = new List();

    // 用户ID
    if(null != filter.userId && -1 != filter.userId){
      request.add({"name": "userId", "value" :filter.userId});
    }
    // 开始时间
    if(null != filter.beginDate && "" != filter.beginDate){
      request.add({"name": "beginDate", "value" :filter.beginDate});
    }
    // 结束时间
    if(null != filter.endDate && "" != filter.endDate){
      request.add({"name": "endDate", "value" :filter.endDate});
    }
    // 状态
    if(null != filter.isOK && -1 != filter.isOK){
      request.add({"name": "isOK", "value" :filter.isOK});
    }
    // 排序
    if(null != filter.orderBy && "" != filter.orderBy){
      request.add({"name": "orderBy", "value" :filter.orderBy});
    }
    // 部门
    if(null != filter.departmentId /*&& -1 != filter.departmentId*/){
      request.add({"name": "departmentId", "value" :filter.departmentId});
    }
    // 巡检计划
    if(null != filter.planTaskId && -1 != filter.planTaskId){
      request.add({"name": "planTaskId", "value" :filter.planTaskId});
    }
    // 巡检点
    if(null != filter.pointId && -1 != filter.pointId){
      request.add({"name": "pointId", "value" :filter.pointId});
    }
    //巡检编号
    if(null != filter.pointNo && "" != filter.pointNo){
      request.add({"name": "pointNo", "value" :filter.pointNo});
    }

    // 调用接口查询数据
    var data = await HttpUtil().post(ApiAddress.INSPECTIONRECORD+"?pageNumber=$pageNumber", data: json.encode(request));
    PageDto pageDto;
    //具体实现函数待编写
    if (data["result"] == "SUCCESS" ) {
      pageDto = PageDto.fromJson(data["dataList"]);
    }else{
      pageDto = PageDto.fromJson({});
    }
    return pageDto;
  }catch(e){
    throw e;
  }
}