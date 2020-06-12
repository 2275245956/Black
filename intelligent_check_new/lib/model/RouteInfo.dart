import 'dart:convert' show json;

class RouteInfo {

  int id;
  String boss;
  String deptName;
  String name;
  String remark;
  String tel;
  String uname;

  RouteInfo.fromParams({this.id, this.boss, this.deptName, this.name, this.remark, this.tel, this.uname});

  factory RouteInfo(jsonStr) => jsonStr == null ? null : jsonStr is String ? new RouteInfo.fromJson(json.decode(jsonStr)) : new RouteInfo.fromJson(jsonStr);

  RouteInfo.fromJson(jsonRes) {
    id = jsonRes['id'];
    boss = jsonRes['boss'];
    deptName = jsonRes['deptName'];
    name = jsonRes['name'];
    remark = jsonRes['remark'];
    tel = jsonRes['tel'];
    uname = jsonRes['uname'];
  }

  @override
  String toString() {
    return '{"id": $id,"boss": ${boss != null?'${json.encode(boss)}':'null'},"deptName": ${deptName != null?'${json.encode(deptName)}':'null'},"name": ${name != null?'${json.encode(name)}':'null'},"remark": ${remark != null?'${json.encode(remark)}':'null'},"tel": ${tel != null?'${json.encode(tel)}':'null'},"uname": ${uname != null?'${json.encode(uname)}':'null'}}';
  }
}

