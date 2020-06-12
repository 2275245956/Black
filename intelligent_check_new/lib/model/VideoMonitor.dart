import 'dart:convert' show json;

class VideoMonitorListModel {

  int id;
  int isLeaf;
  int parentId;
  int status;
  bool isIndoor;
  String carmeraType;
  String floor3d;
  String ip;
  String name;
  String password;
  String position3d;
  String rtspAddress;
  String text;
  String token;
  String url;
  String user;

  VideoMonitorListModel.fromParams({this.id, this.isLeaf, this.parentId, this.status, this.isIndoor, this.carmeraType, this.floor3d, this.ip, this.name, this.password, this.position3d, this.rtspAddress, this.text, this.token, this.url, this.user});

  factory VideoMonitorListModel(jsonStr) => jsonStr == null ? null : jsonStr is String ? new VideoMonitorListModel.fromJson(json.decode(jsonStr)) : new VideoMonitorListModel.fromJson(jsonStr);

  VideoMonitorListModel.fromJson(jsonRes) {
    id = jsonRes['id'];
    isLeaf = jsonRes['isLeaf'];
    parentId = jsonRes['parentId'];
    status = jsonRes['status'];
    isIndoor = jsonRes['isIndoor'];
    carmeraType = jsonRes['carmeraType'];
    floor3d = jsonRes['floor3d'];
    ip = jsonRes['ip'];
    name = jsonRes['name'];
    password = jsonRes['password'];
    position3d = jsonRes['position3d'];
    rtspAddress = jsonRes['rtspAddress'];
    text = jsonRes['text'];
    token = jsonRes['token'];
    url = jsonRes['url'];
    user = jsonRes['user'];
  }

  @override
  String toString() {
    return '{"id": $id,"isLeaf": $isLeaf,"parentId": $parentId,"status": $status,"isIndoor": $isIndoor,"carmeraType": ${carmeraType != null?'${json.encode(carmeraType)}':'null'},"floor3d": ${floor3d != null?'${json.encode(floor3d)}':'null'},"ip": ${ip != null?'${json.encode(ip)}':'null'},"name": ${name != null?'${json.encode(name)}':'null'},"password": ${password != null?'${json.encode(password)}':'null'},"position3d": ${position3d != null?'${json.encode(position3d)}':'null'},"rtspAddress": ${rtspAddress != null?'${json.encode(rtspAddress)}':'null'},"text": ${text != null?'${json.encode(text)}':'null'},"token": ${token != null?'${json.encode(token)}':'null'},"url": ${url != null?'${json.encode(url)}':'null'},"user": ${user != null?'${json.encode(user)}':'null'}}';
  }
}

