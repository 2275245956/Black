import 'dart:convert' show json;
import 'package:intelligent_check_new/model/APIResponse.dart';
import 'package:intelligent_check_new/services/api_address.dart';
import 'package:intelligent_check_new/tools/HttpUtil.dart';

Future<APIResponse> getMonitorList(int currentPage,int pageSize,String parentId) async{

  try{
    var data=await  HttpUtil().post(ApiAddress.VIDEOLIST+"/$parentId/$currentPage/$pageSize");
    if(data==null || data==""){
      return APIResponse.error("未获取数据!");
    }
    return APIResponse.fromJson(json.decode(data));
  }catch(e){
    print(e);
    return null;
  }

}


Future<APIResponse> getVideoUrl() async{
  try{
     var data=await HttpUtil().get(ApiAddress.VIDEOURL);
     if(data!=null){
       return APIResponse.fromJson(data);
     }
     return APIResponse.error("获取失败！");
  }catch(e){
    print(e);
    return APIResponse.error("获取失败！");
  }


}