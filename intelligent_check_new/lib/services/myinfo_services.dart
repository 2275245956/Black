import 'dart:convert';
import 'package:intelligent_check_new/model/APIResponse.dart';
import 'package:intelligent_check_new/model/message/SubscribeInfo.dart';
import 'package:intelligent_check_new/tools/HttpUtil.dart';
import 'package:intelligent_check_new/services/api_address.dart';
import 'package:intelligent_check_new/model/myinfomodel.dart';

//更改密码
Future getMyInfo() async {
  try {
    /*var data = await HttpUtil().put(ApiAddress.个人信息API, data: {
    });*/
    var data = {
      "userdepartment": "生产部",
      "useremail": "123456@163.com",
      "userid": 1,
      "sex": "男",
      "avatarUrl": "",
      "username": "王多余"
    };
    return MyInfoModel.fromJson(data);
  } catch (e) {
    throw (e);
  }
}

//更改密码
Future<APIResponse> ChangePswd(String newpswd, String pswd, String userId) async {
  try {
    var data = await HttpUtil().post(ApiAddress.CHANGE_PSWD+"?password=$pswd&newPassword=$newpswd");
    return APIResponse.fromJson(data);
    //具体实现函数待编写
  } catch (e) {
    throw (e);
  }
}

//登出
Future Logout() async {
  try {
    var data = await HttpUtil().post(ApiAddress.LOGOUT_AUTH,
    isAuth: true);/*  var data = await HttpUtil().delete(ApiAddress.LOGOUT,
        data: {"userId": userId, "loginType": "APP"},
    isAuth: true);*/
    //具体实现函数待编写
    return data;
  } catch (e) {
    throw (e);
  }
}

//通讯录
Future getContact() async {
  try {
    var data = await HttpUtil().get(ApiAddress.CONTACT);
    //具体实现函数待编写

    return data;
  } catch (e) {
    throw (e);
  }
}

//消息订阅
Future<SubscribeInfo> getSubscribe() async {
  try {
    SubscribeInfo rstData;


    var data = await HttpUtil().get(ApiAddress.SUBSCRIBE);
    //具体实现函数待编写
    if (data["result"] == "SUCCESS" ) {
      if(data["dataList"].toString() != "[]"){
          var dataList = data["dataList"];
          rstData= SubscribeInfo.fromJson(dataList);
//          for(var _checkPlan in dataList["checkPlan"]){
//            checkPlans.add(CheckPlan.fromJson(_checkPlan));
//          }
//          rstData.checkPlans = checkPlans;
//
//          for(var _check in dataList["check"]){
//            checks.add(ItemInfo.fromJson(_check));
//          }
//          rstData.checks = checks;
//
//          for(var _email in dataList["email"]){
//            emails.add(ItemInfo.fromJson(_email));
//          }
//          rstData.emails = emails;
      }
    }

    return rstData;

  } catch (e) {
    throw (e);
  }
}

Future<bool> saveSubscribe(List<SubItem> checkPlans) async{
  var data = await HttpUtil().post(ApiAddress.SAVE_SUBSCRIBE,data:checkPlans.toString());
  return data["success"];
}

Future userLogin(String userName, String password) async {
  try{
    Map map = Map();
    map["userName"] = userName;
    map["password"] = password;
    map["loginType"] = "APP";
    map["secretKey"] = "yeejoin";
    var data = await HttpUtil()
        .post(ApiAddress.LOGIN, data: json.encode(map), isAuth: true);
//    print(data["user"]["role"]["roleTypeName"]);
    return data;
  }catch(e){
   print("错误信息：${e}");
  }

}


Future<String> getAuthForInitCardAndOffline() async{
  String permissions="";
  var data = await HttpUtil().get(ApiAddress.INIT_CARD_AND_OFFLINE+"?nodeName=&type=29",isAuth: true);
  if(data["result"] == "SUCCESS"){
    if(data["dataList"].toString() != "[]"){
      for(var _dataList in data["dataList"]){
        for(var child in _dataList["children"]){
//          print(child);
          if(child["isWriteable"]){
            permissions = child["permissionCode"]  + "," + permissions;
          }
        }
      }
    }
  }
  return permissions;
}


///GPS信息更新
Future<APIResponse> gpsAddNewRoute(dynamic jsonData) async{
  var data = await HttpUtil().post(ApiAddress.GPS_ADD_ROUTE,data: jsonData);
   return APIResponse.fromJson(data);
}
