import 'dart:convert';

import 'package:intelligent_check_new/model/CompanyInfo.dart';

class InitData{
  List<CompanyInfo> companies;
  String permissions;


  List<CompanyInfos> coms;
//  List<DeptInfo>  deptInfos;
  Map<String,List<DeptInfo>> deptInfos = new Map();
//  List<Role>  roleInfo;
  Map<String,List<RoleInfo>> roleInfo = new Map();
}

class CurrentUserNeedToDo {

  bool havaJudgment;
  bool havaPlanTask;
  bool haveDanger;

  CurrentUserNeedToDo.fromParams({this.havaJudgment=false, this.havaPlanTask=false, this.haveDanger=false});

  factory CurrentUserNeedToDo(jsonStr) => jsonStr == null ? null : jsonStr is String ? new CurrentUserNeedToDo.fromJson(json.decode(jsonStr)) : new CurrentUserNeedToDo.fromJson(jsonStr);

  CurrentUserNeedToDo.fromJson(jsonRes) {
    havaJudgment = jsonRes['havaJudgment'];
    havaPlanTask = jsonRes['havaPlanTask'];
    haveDanger = jsonRes['haveDanger'];
  }

  @override
  String toString() {
    return '{"havaJudgment": $havaJudgment,"havaPlanTask": $havaPlanTask,"haveDanger": $haveDanger}';
  }
}




