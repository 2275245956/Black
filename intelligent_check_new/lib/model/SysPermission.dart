import 'dart:convert' show json;

class SysPermission {

  String fString1;
  String icon;
  String image;
  num parentId;
  String subSys;
  String typeName;
  num fInt1;
  num id;
  num level;
  bool checked;
  bool fBoolean1;
  bool isBlank;
  bool isWriteable;
  String description;
  String key;
  String label;
  String name;
  String permissionCode;
  String type;
  String url;
  String value;

  SysPermission.fromParams({this.fString1, this.icon, this.image, this.parentId, this.subSys, this.typeName, this.fInt1, this.id, this.level, this.checked, this.fBoolean1, this.isBlank, this.isWriteable, this.description, this.key, this.label, this.name, this.permissionCode, this.type, this.url, this.value});

  factory SysPermission(jsonStr) => jsonStr == null ? null : jsonStr is String ? new SysPermission.fromJson(json.decode(jsonStr)) : new SysPermission.fromJson(jsonStr);

  SysPermission.fromJson(jsonRes) {
    fString1 = jsonRes['fString1'];
    icon = jsonRes['icon'];
    image = jsonRes['image'];
    parentId = jsonRes['parentId'];
    subSys = jsonRes['subSys'];
    typeName = jsonRes['typeName'];
    fInt1 = jsonRes['fInt1'];
    id = jsonRes['id'];
    level = jsonRes['level'];
    checked = jsonRes['checked'];
    fBoolean1 = jsonRes['fBoolean1'];
    isBlank = jsonRes['isBlank'];
    isWriteable = jsonRes['isWriteable'];
    description = jsonRes['description'];
    key = jsonRes['key'];
    label = jsonRes['label'];
    name = jsonRes['name'];
    permissionCode = jsonRes['permissionCode'];
    type = jsonRes['type'];
    url = jsonRes['url'];
    value = jsonRes['value'];
  }

  @override
  String toString() {
    return '{"fString1": $fString1,"icon": $icon,"image": $image,"parentId": $parentId,"subSys": $subSys,"typeName": ${type != null?'${json.encode(type)}':'null'}Name,"fInt1": $fInt1,"id": $id,"level": $level,"checked": $checked,"fBoolean1": $fBoolean1,"isBlank": $isBlank,"isWriteable": $isWriteable,"description": ${description != null?'${json.encode(description)}':'null'},"key": ${key != null?'${json.encode(key)}':'null'},"label": ${label != null?'${json.encode(label)}':'null'},"name": ${name != null?'${json.encode(name)}':'null'},"permissionCode": ${permissionCode != null?'${json.encode(permissionCode)}':'null'},"type": ${type != null?'${json.encode(type)}':'null'},"url": ${url != null?'${json.encode(url)}':'null'},"value": ${value != null?'${json.encode(value)}':'null'}}';
  }
}
