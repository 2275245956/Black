import 'dart:convert' show json;
class CheckPointDetail {

  int checkId;
  int checkTime;
  int pointId;
  String departmentName;
  String planName;
  String pointName;
  String pointNo;
  String pointStatus;
  String username;
  List<String> pointImgUrls = List();
  Map<String,List<CheckInput>> checkInputs = Map();
  String remark;
  String message;

  CheckPointDetail.fromParams({this.checkId, this.checkTime, this.pointId, this.departmentName, this.planName, this.pointName, this.pointNo, this.pointStatus, this.username,this.remark});
  factory CheckPointDetail(jsonStr) => jsonStr == null ? null : jsonStr is String ? new CheckPointDetail.fromJson(json.decode(jsonStr)) : new CheckPointDetail.fromJson(jsonStr);

  CheckPointDetail.fromJson(jsonRes) {
    checkId = jsonRes['checkId'];
    checkTime = jsonRes['checkTime'];
    pointId = jsonRes['pointId'];
    departmentName = jsonRes['departmentName'];
    planName = jsonRes['planName'];
    pointName = jsonRes['pointName'];
    pointNo = jsonRes['pointNo'];
    pointStatus = jsonRes['pointStatus'];
    username = jsonRes['username'];
    remark = jsonRes['remark'];
  }

  @override
  String toString() {
    return '{"checkId": $checkId,"checkTime": $checkTime,"pointId": $pointId,"departmentName": ${departmentName != null?'${json.encode(departmentName)}':'null'},"planName": ${planName != null?'${json.encode(planName)}':'null'},"pointName": ${pointName != null?'${json.encode(pointName)}':'null'},"pointNo": ${pointNo != null?'${json.encode(pointNo)}':'null'},"pointStatus": ${pointStatus != null?'${json.encode(pointStatus)}':'null'},"username": ${username != null?'${json.encode(username)}':'null'},"remark": ${remark != null?'${json.encode(remark)}':'null'}}';
  }
}

class CheckInput {

  String remark;
  int checkInputId;
  String dataJson;
  String inputName;
  String inputStatus;
  String inputValue;
  String isMultiline;
  String isMust;
  String itemType;
  String orderNo;
  // 已上传的图片url连接
  List<String> pointInputImgUrls;
  String pictureJson;
  // 图片上传配置信息
  List<ItemPictureInfo> pictureInfo = List();

  String selectPicName = "无拍照点";

  CheckInput(){}
  // 当前查看的图片
  List<String> selectPic = List();

  CheckInput.fromParams({this.remark, this.checkInputId, this.dataJson, this.inputName, this.inputStatus, this.inputValue, this.isMultiline, this.isMust, this.itemType, this.orderNo, this.pictureJson, this.pointInputImgUrls});

  CheckInput.fromJson(jsonRes) {
    remark = jsonRes['remark'];
    checkInputId = jsonRes['checkInputId'];
    dataJson = jsonRes['dataJson'];
    inputName = jsonRes['inputName'];
    inputStatus = jsonRes['inputStatus'];
    inputValue = jsonRes['inputValue'];
    isMultiline = jsonRes['isMultiline'];
    isMust = jsonRes['isMust'];
    itemType = jsonRes['itemType'];
    orderNo = jsonRes['orderNo'];
    pictureJson = jsonRes['pictureJson'];
    pointInputImgUrls = jsonRes['pointInputImgUrls'] == null ? null : [];

    for (var pointInputImgUrlsItem in pointInputImgUrls == null ? [] : jsonRes['pointInputImgUrls']){
      pointInputImgUrls.add(pointInputImgUrlsItem);
    }
    // 解析上传图片项
    if(null != this.pictureJson){
      for(var pic in json.decode(this.pictureJson)){
        this.pictureInfo.add(ItemPictureInfo.fromJson(pic));
      }
    }
    // 设置默认显示图片项
    if(this.pictureInfo.length > 0){
      // 默认展示项名称
      this.selectPicName = this.pictureInfo[0].name;
      // 默认展示项图片
      if(pointInputImgUrls != null && pointInputImgUrls.length > 0){
        this.selectPic = this.pointInputImgUrls.where((p) => p.indexOf(this.selectPicName) != -1).toList();
      }
    }
  }

  @override
  String toString() {
    return '{"remark": ${remark != null?'${json.encode(remark)}':'null'},"checkInputId": $checkInputId,"dataJson": ${dataJson != null?'${json.encode(dataJson)}':'null'},"inputName": ${inputName != null?'${json.encode(inputName)}':'null'},"inputStatus": ${inputStatus != null?'${json.encode(inputStatus)}':'null'},"inputValue": ${inputValue != null?'${json.encode(inputValue)}':'null'},"isMultiline": ${isMultiline != null?'${json.encode(isMultiline)}':'null'},"isMust": ${isMust != null?'${json.encode(isMust)}':'null'},"itemType": ${itemType != null?'${json.encode(itemType)}':'null'},"orderNo": ${orderNo != null?'${json.encode(orderNo)}':'null'},"pictureJson": ${pictureJson != null?'${json.encode(pictureJson)}':'null'},"pointInputImgUrls": $pointInputImgUrls}';
  }
}

class ItemPictureInfo{
  String isMust;
  String name;

  ItemPictureInfo.fromParams({
    this.isMust,this.name
  });

  ItemPictureInfo.fromJson(jsonRes) {
    isMust = jsonRes['isMust'];
    name = jsonRes['name'];
  }
}
