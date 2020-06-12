import 'dart:convert' show json;

class UserShowAuth {

  int sort;
  bool hasPermission;
  bool isBlank;
  bool isRoute;
  String applicationCode;
  String frontComponent;
  String menuAgent;
  String parentId;
  String path;
  String permissionName;
  String permissionType;
  String sequenceNbr;

  bool hasTask=false;

  List<UserShowAuth> children;

  UserShowAuth.fromParams({this.sort, this.hasPermission, this.isBlank, this.isRoute, this.applicationCode, this.frontComponent, this.menuAgent, this.parentId, this.path, this.permissionName, this.permissionType, this.sequenceNbr, this.children});

  factory UserShowAuth(jsonStr) => jsonStr == null ? null : jsonStr is String ? new UserShowAuth.fromJson(json.decode(jsonStr)) : new UserShowAuth.fromJson(jsonStr);

  UserShowAuth.fromJson(jsonRes) {
    sort = jsonRes['sort'];
    hasPermission = jsonRes['hasPermission'];
    isBlank = jsonRes['isBlank'];
    isRoute = jsonRes['isRoute'];
    applicationCode = jsonRes['applicationCode'];
    frontComponent = jsonRes['frontComponent'];
    menuAgent = jsonRes['menuAgent'];
    parentId = jsonRes['parentId'];
    path = jsonRes['path'];
    permissionName = jsonRes['permissionName'];
    permissionType = jsonRes['permissionType'];
    sequenceNbr = jsonRes['sequenceNbr'];
    children = jsonRes['children'] == null ? null : [];

    for (var childrenItem in children == null ? [] : jsonRes['children']){
      children.add(childrenItem == null ? null : new UserShowAuth.fromJson(childrenItem));
    }
  }

  @override
  String toString() {
    return '{"sort": $sort,"hasPermission": $hasPermission,"isBlank": $isBlank,"isRoute": $isRoute,"applicationCode": ${applicationCode != null?'${json.encode(applicationCode)}':'null'},"frontComponent": ${frontComponent != null?'${json.encode(frontComponent)}':'null'},"menuAgent": ${menuAgent != null?'${json.encode(menuAgent)}':'null'},"parentId": ${parentId != null?'${json.encode(parentId)}':'null'},"path": ${path != null?'${json.encode(path)}':'null'},"permissionName": ${permissionName != null?'${json.encode(permissionName)}':'null'},"permissionType": ${permissionType != null?'${json.encode(permissionType)}':'null'},"sequenceNbr": ${sequenceNbr != null?'${json.encode(sequenceNbr)}':'null'},"children": $children}';
  }
}

class UserPowerAuth extends UserShowAuth{

  factory UserPowerAuth(jsonStr) => jsonStr == null ? null : jsonStr is String ? new UserShowAuth.fromJson(json.decode(jsonStr)) : new UserShowAuth.fromJson(jsonStr);

}


