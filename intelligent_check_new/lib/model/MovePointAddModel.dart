import 'dart:convert' show json;

class MovePointAddModel{

  int shotMaxNumber;
  int shotMinNumber;
  bool offline;
  String inputItems;
  String name;
  String pointNo;
  String remark;

  MovePointAddModel.fromParams({this.shotMaxNumber, this.shotMinNumber, this.offline, this.inputItems, this.name, this.pointNo, this.remark});

  factory MovePointAddModel(jsonStr) => jsonStr == null ? null : jsonStr is String ? new MovePointAddModel.fromJson(json.decode(jsonStr)) : new MovePointAddModel.fromJson(jsonStr);

  MovePointAddModel.fromJson(jsonRes) {
    shotMaxNumber = jsonRes['shotMaxNumber'];
    shotMinNumber = jsonRes['shotMinNumber'];
    offline = jsonRes['offline'];
    inputItems = jsonRes['inputItems'];
    name = jsonRes['name'];
    pointNo = jsonRes['pointNo'];
    remark = jsonRes['remark'];
  }

  @override
  String toString() {
    return '{"shotMaxNumber": $shotMaxNumber,"shotMinNumber": $shotMinNumber,"offline": $offline,"inputItems": ${inputItems != null?'${json.encode(inputItems)}':'null'},"name": ${name != null?'${json.encode(name)}':'null'},"pointNo": ${pointNo != null?'${json.encode(pointNo)}':'null'},"remark": ${remark != null?'${json.encode(remark)}':'null'}}';
  }
}