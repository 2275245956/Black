import 'dart:convert' show json;

class Config {

  int id;
  String attribute;
  String createDate;
  String des;
  String name;

  Config.fromParams({this.id, this.attribute, this.createDate, this.des, this.name});

  factory Config(jsonStr) => jsonStr == null ? null : jsonStr is String ? new Config.fromJson(json.decode(jsonStr)) : new Config.fromJson(jsonStr);

  Config.fromJson(jsonRes) {
    id = jsonRes['id'];
    attribute = jsonRes['attribute'];
    createDate = jsonRes['createDate'];
    des = jsonRes['des'];
    name = jsonRes['name'];
  }

  @override
  String toString() {
    return '{"id": $id,"attribute": ${attribute != null?'${json.encode(attribute)}':'null'},"createDate": ${createDate != null?'${json.encode(createDate)}':'null'},"des": ${des != null?'${json.encode(des)}':'null'},"name": ${name != null?'${json.encode(name)}':'null'}}';
  }
}