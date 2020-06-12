import 'dart:convert' show json;

class DepartmentInfo {

  String writeable;
  String id;
  String key;
  String label;
  String name;
  String state;
  String title;
  String type;
  String value;

  DepartmentInfo.fromParams({this.writeable, this.id, this.key, this.label, this.name, this.state, this.title, this.type, this.value});

  factory DepartmentInfo(jsonStr) => jsonStr == null ? null : jsonStr is String ? new DepartmentInfo.fromJson(json.decode(jsonStr)) : new DepartmentInfo.fromJson(jsonStr);

  DepartmentInfo.fromJson(jsonRes) {
    writeable = jsonRes['writeable'];
    id = jsonRes['id'];
    key = jsonRes['key'];
    label = jsonRes['label'];
    name = jsonRes['name'];
    state = jsonRes['state'];
    title = jsonRes['title'];
    type = jsonRes['type'];
    value = jsonRes['value'];
  }

  @override
  String toString() {
    return '{"writeable": $writeable,"id": ${id != null?'${json.encode(id)}':'null'},"key": ${key != null?'${json.encode(key)}':'null'},"label": ${label != null?'${json.encode(label)}':'null'},"name": ${name != null?'${json.encode(name)}':'null'},"state": ${state != null?'${json.encode(state)}':'null'},"title": ${title != null?'${json.encode(title)}':'null'},"type": ${type != null?'${json.encode(type)}':'null'},"value": ${value != null?'${json.encode(value)}':'null'}}';
  }
}