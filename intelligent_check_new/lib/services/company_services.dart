import 'dart:convert' show json;
import 'package:intelligent_check_new/model/APIResponse.dart';
import 'package:intelligent_check_new/model/CheckExecute/ContactInfo.dart';
import 'package:intelligent_check_new/model/CheckExecute/DepartmentInfo.dart';
import 'package:intelligent_check_new/model/CompanyInfo.dart';
import 'package:intelligent_check_new/model/InitData.dart';
import 'package:intelligent_check_new/services/api_address.dart';
import 'package:intelligent_check_new/tools/HttpUtil.dart';
import 'dart:async';

Future<List<CompanyInfo>> getCompanyList() async {
  try {
    List<CompanyInfo> companyList = new List();

    Map request = new Map();

    // 调用接口查询数据
    var data = await HttpUtil().get(ApiAddress.QUERY_AUTH_COMPANY_LEAVES,
        data: json.encode(request));

    //具体实现函数待编写
    if (data["result"] == "SUCCESS" ) {
      var dataList = data["dataList"];

      for(var _dataList in dataList) {
        companyList.add(CompanyInfo.fromJson(_dataList));
      }
    }
    return companyList;
  } catch (e) {
    throw e;
  }
}


Future<void> selectCompany(String orgcode) async {
  try {
    // 调用接口查询数据
    var data = await HttpUtil().get(ApiAddress.CHANGE_COMPANY + "/" + orgcode);
    //具体实现函数待编写
    if (data["result"] == "SUCCESS" ) {
      print("公司切换成功！");
    }
  } catch (e) {
    print("公司切换失败！");
  }
}

// 获取通讯录信息
//Future<List<ContractInfo>> getContractInfo(companyId) async{
//  List<ContractInfo> rst = List();
// // var data = await HttpUtil().get(ApiAddress.CONTACT_INFO);
//  var data = await HttpUtil().get(ApiAddress.CONTACT_INFO+"/$companyId",isAuth: true);
//  if (data["result"] == "SUCCESS" ) {
//    var dataList = data["dataList"];
//    for(var _data in dataList){
//      ContractInfo _contract = ContractInfo.fromParams(id: _data["id"].toString(),name: _data["name"].toString(),departmentName: _data["departmentName"],email: _data["email"],telephone:  _data["telephone"],mobile:  _data["mobile"]);
//      List<ChildInfo> children = List();
//      for(var child in _data["children"]){
//        children.add(ChildInfo.fromParams(id: child["id"].toString(),
//            label: child["label"].toString(),name: child["name"].toString(),departmentName: child["departmentName"],email: child["email"],telephone:  child["telephone"],mobile:  child["mobile"]));
//      }
//      _contract.children = children;
//      rst.add(_contract);
//    }
//  }
//  return rst;
//}



// 获取部门信息
Future<List<DepartmentInfo>> getDepartmentInfo() async{

  List<DepartmentInfo> lst = new List();

  var data = await HttpUtil().get(ApiAddress.DEPARTMENT_INFO);
  if (data["result"] == "SUCCESS" ) {
    var dataList = data["dataList"];
    for(var _data in dataList){
      lst.add(DepartmentInfo.fromParams(id: _data["sequenceNbr"].toString(),name: _data["departmentName"].toString()));
    }
  }
  return lst;
}

// 获取通讯录信息
Future<List<ContractInfo>> getContractInfo(companyId) async{
  List<ContractInfo> rst = List();
  var data = await HttpUtil().get(ApiAddress.CONTACT_INFO,isAuth: true);
  if (data["result"] == "SUCCESS" ) {
    var dataList = data["dataList"];
    for(var _data in   dataList){
       ContractInfo _contract = ContractInfo.fromParams(id: _data["id"].toString(),name: _data["name"].toString(),parentId: _data["object"]!=null?"-1":"0",type: _data["type"],objects: json.encode(_data["object"]),);
      List<ChildInfo> children = List();
      //部门下由用户
      if(_data["children"]!=null){
        addChildItem(children,_data["children"],_data["name"]);
      }
      _contract.children = children;
      rst.add(_contract);
    }
  }
  rst.sort((left,right)=>left.type.compareTo(right.type));
  return rst;
 }

 addChildItem(List<ChildInfo> children,var current,deptName){
  for(var child in current){

   ChildInfo childs=ChildInfo.fromParams(id: child["id"].toString(),name: child["name"].toString(),parentId: child["parentId"],departmentName: deptName,type: child["type"] ,objects: json.encode(child["object"]));
   List<ChildInfo> childrenChild = List();
    if(child["children"]!=null){
      addChildItem(childrenChild,child["children"],child["name"]);
    }
    childs.children=childrenChild;
    children.add(childs);
  // children.addAll(childrenChild);
  }
  children.sort((left,right)=>left.type.compareTo(right.type));
}

Future<int> getQueryPlanTaskCount() async{
  int count = 0;
  var data = await HttpUtil().post(ApiAddress.QUERY_PLAN_TASK_COUNT);
  if (data["result"] == "SUCCESS" ) {
    count = data["dataList"];
  }
  return count;
}

Future<int> getUnreadCount() async{
  int count = 0;
  var data = await HttpUtil().get(ApiAddress.UNREAD_COUNT);
  if (data["result"] == "SUCCESS" ) {
    count = data["dataList"];
  }
  return count;
}

// 获取初始化信息
Future<InitData> getInitData() async{
  InitData initData = InitData();
  var data = await HttpUtil().get(ApiAddress.INIT_DATA);
  if (data["result"] == "SUCCESS" ) {
    var dataList = data["dataList"];
//
//    List<CompanyInfo> companyList = new List();
//
//    for(var _dataList in dataList["companys"]) {
//     // companyList.add(CompanyInfo.fromJson(_dataList));
//
//    }
//
//    initData.companies = companyList;

    ////////////////////////////////////////////////
    String permissions="";
    var permissionList = dataList["permissionitems"];
//    List children = json.decode(permissionList["children"]);
    if(permissionList != null && permissionList.length > 0){
      if(permissionList[0]["children"] != null){
        for(var child in permissionList[0]["children"]){
          child["isRoute"]=child["isRoute"]?? false;
          if(child["isRoute"]){
            permissions = child["path"]  + "," + permissions;
          }
        }
        initData.permissions = permissions;
      }
    }else{
      initData.permissions = null;
    }
  }
  return initData;
}
//
//是否有待处理任务
Future<CurrentUserNeedToDo> getSelfTaskStatus() async{
  try{
    CurrentUserNeedToDo toDo;
    var data= await HttpUtil().get(ApiAddress.GET_ALL_TASK_STATUS);
    if(data["dataList"]!=null && data["result"]=="SUCCESS"){
      var datalist=data["dataList"];
      toDo=new CurrentUserNeedToDo.fromParams();
      toDo.haveDanger=datalist["haveDanger"]??false;
      toDo.havaJudgment=datalist["havaJudgment"]??false;
      toDo.havaPlanTask=datalist["havaPlanTask"]??false;

    }
    return toDo;
  }catch(e){
    print(e);
    throw e;
  }

}
Future<InitData> getLogInInfo() async {
  InitData initData = InitData();
  var data = await HttpUtil().get(ApiAddress.LOGIN_INFO,isAuth: true);
  if (data["result"] == "SUCCESS") {
    var dataList = data["dataList"];

    List<CompanyInfos> companyList = new List();
    List<int> allComs=new List();
    List<DeptInfo> deptList = new List();
    Map<String,List<DeptInfo>> deptMap = new Map();
    List<RoleInfo> roleList = new List();
    Map<String,List<RoleInfo>> roleMap = new Map();

    for (var _dataList in dataList["companys"]) {
      if(!allComs.contains(_dataList["companyOrgCode"])){
        companyList.add(CompanyInfos.fromJson(_dataList));
        allComs.add((int.tryParse(_dataList['companyOrgCode'].toString())));
      }
    }

//    for (var _dataList in dataList["departments"]) {
    if(dataList["companyDepartments"] != null){
      for (String key in dataList["companyDepartments"].keys) {
        if(deptMap.containsKey(key))continue;
        deptList=[];
        for(var dpt in dataList["companyDepartments"][key]){
          if(dpt==null)continue;

          deptList.add(DeptInfo.fromJson(dpt));
        }

        deptMap[key] = deptList;
      }
    }

//    for (var _dataList in dataList["roles"]) {
    if(dataList["orgRoles"] != null){
      for (var key in dataList["orgRoles"].keys) {
        if(roleMap.containsKey(key))continue;
        roleList=[];
        for(var role in dataList["orgRoles"][key]){
          if(role==null)continue;
          roleList.add(RoleInfo.fromJson(role));
        }
        roleMap[key] = roleList;
      }
    }

    initData.coms = companyList;
    initData.deptInfos = deptMap;
    initData.roleInfo = roleMap;
    return initData;
  }
  return  null;
}

Future<APIResponse> saveSeleCom(jsonData) async {
  var data = await HttpUtil().post(ApiAddress.SAVE_SELCOM,data: jsonData);
  return APIResponse.fromJson(data);
}


Future<APIResponse> RegisterJPushUser(String rid,String alias)async{
  var data = await HttpUtil().post(ApiAddress.RegisterUser+"$rid/$alias");
  return APIResponse.fromJson(data);
}



