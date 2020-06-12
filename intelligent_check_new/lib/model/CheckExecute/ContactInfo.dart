import 'dart:convert' show json;

class ContractInfo {

  String id;
  String key;
  String value;
  String writeable;
  String attributes;
  String desc;
  String label;
  String name;
  String state;
  String title;
  String type;
  String telephone;
  String departmentName;
  String email;
  List<ChildInfo> children;
  String mobile;
  String parentId;
  String objects;
  bool isSelected=false;

  ContractInfo();
  ContractInfo.fromParams({this.objects,this.parentId,this.id, this.key, this.value, this.writeable, this.attributes, this.desc, this.label, this.name, this.state, this.title, this.type,this.telephone,this.departmentName,this.email,this.mobile});

//  factory ContractInfo(jsonStr) => jsonStr == null ? null : jsonStr is String ? new ContractInfo.fromJson(json.decode(jsonStr)) : new ContractInfo.fromJson(jsonStr);

  ContractInfo.fromJson(jsonRes) {
    id = jsonRes['id'];
    key = jsonRes['key'];
    value = jsonRes['value'];
    writeable = jsonRes['writeable'];
    attributes = jsonRes['attributes'];
    desc = jsonRes['desc'];
    label = jsonRes['label'];
    name = jsonRes['name'];
    state = jsonRes['state'];
    title = jsonRes['title'];
    type = jsonRes['type'];
    departmentName = jsonRes['departmentName'];
    email = jsonRes['email'];
    telephone = jsonRes['telephone'];
    mobile = jsonRes['mobile'];
    parentId=jsonRes["parentId"];
    objects=json.encode(jsonRes["objects"]).toString();

  }

  @override
  String toString() {
    return '{"id": $id,"key": $key,"value": $value,"writeable": $writeable,"attributes": ${attributes != null?'${json.encode(attributes)}':'null'},"desc": ${desc != null?'${json.encode(desc)}':'null'},"label": ${label != null?'${json.encode(label)}':'null'},"name": ${name != null?'${json.encode(name)}':'null'},"state": ${state != null?'${json.encode(state)}':'null'},"title": ${title != null?'${json.encode(title)}':'null'},"type": ${type != null?'${json.encode(type)}':'null'},"telephone": ${telephone != null?'${json.encode(telephone)}':'null'}}';
  }
}

class ChildInfo {

  String id;
  String key;
  String value;
  String writeable;
  bool checked;
  String desc;
  String label;
  String name;
  String state;
  String title;
  String type;
  String userName;
  String departmentName;
  String telephone;
  String email;
  String mobile;
  List<ChildInfo> children;
  String parentId;
  String objects;
  bool isSelected=false;

  ChildInfo.fromParams({this.objects,this.parentId,this.id, this.key, this.value, this.writeable, this.checked, this.desc, this.label, this.name, this.state, this.title, this.type, this.userName,this.telephone,this.departmentName,this.email,this.mobile,this.isSelected=false,this.children});

  factory ChildInfo(jsonStr) => jsonStr == null ? null : jsonStr is String ? new ChildInfo.fromJson(json.decode(jsonStr)) : new ChildInfo.fromJson(jsonStr);

  ChildInfo.fromJson(jsonRes) {
    id = jsonRes['id'];
    key = jsonRes['key'];
    value = jsonRes['value'];
    writeable = jsonRes['writeable'];
    checked = jsonRes['checked'];
    desc = jsonRes['desc'];
    label = jsonRes['label'];
    name = jsonRes['name'];
    state = jsonRes['state'];
    title = jsonRes['title'];
    type = jsonRes['type'];
    userName = jsonRes['userName'];
    departmentName = jsonRes['departmentName'];
    email = jsonRes['email'];
    telephone = jsonRes['telephone'];
    mobile = jsonRes['mobile'];
    parentId=jsonRes["parentId"];
    objects=json.encode(jsonRes["objects"]).toString();
  }

  @override
  String toString() {
    return '{"id": $id,"key": $key,"value": $value,"writeable": $writeable,"checked": $checked,"desc": ${desc != null?'${json.encode(desc)}':'null'},"label": ${label != null?'${json.encode(label)}':'null'},"name": ${name != null?'${json.encode(name)}':'null'},"state": ${state != null?'${json.encode(state)}':'null'},"title": ${title != null?'${json.encode(title)}':'null'},"type": ${type != null?'${json.encode(type)}':'null'},"userName": ${userName != null?'${json.encode(userName)}':'null'},"telephone": ${telephone != null?'${json.encode(telephone)}':'null'},"mobile": ${mobile != null?'${json.encode(mobile)}':'null'},"isSelected":$isSelected}';
  }
}


class ContractInfo_V2 {

  int departmentUserCount;
  String departmentName;
  String departmentNbr;
  List<ContractInfo_V2> departments;
  List<ChildUser> users;

  ContractInfo_V2.fromParams({this.departmentUserCount, this.departmentName, this.departmentNbr, this.departments, this.users});

  factory ContractInfo_V2(jsonStr) => jsonStr == null ? null : jsonStr is String ? new ContractInfo_V2.fromJson(json.decode(jsonStr)) : new ContractInfo.fromJson(jsonStr);

  ContractInfo_V2.fromJson(jsonRes) {
    departmentUserCount = jsonRes['departmentUserCount'];
    departmentName = jsonRes['departmentName'];
    departmentNbr = jsonRes['departmentNbr'];
    departments = jsonRes['departments'] == null ? null : [];

    for (var departmentsItem in departments == null ? [] : jsonRes['departments']){
      departments.add(departmentsItem == null ? null : new ContractInfo_V2.fromJson(departmentsItem));
    }

    users = jsonRes['users'] == null ? null : [];

    for (var usersItem in users == null ? [] : jsonRes['users']){
      users.add(usersItem == null ? null : new ChildUser.fromJson(usersItem));
    }
  }

  @override
  String toString() {
    return '{"departmentUserCount": $departmentUserCount,"departmentName": ${departmentName != null?'${json.encode(departmentName)}':'null'},"departmentNbr": ${departmentNbr != null?'${json.encode(departmentNbr)}':'null'},"departments": $departments,"users": $users}';
  }
}

class ChildUser {

  String userId;
  String userRealName;

  ChildUser.fromParams({this.userId, this.userRealName});

  ChildUser.fromJson(jsonRes) {
    userId = jsonRes['userId'];
    userRealName = jsonRes['userRealName'];
  }

  @override
  String toString() {
    return '{"userId": ${userId != null?'${json.encode(userId)}':'null'},"userRealName": ${userRealName != null?'${json.encode(userRealName)}':'null'}}';
  }
}


