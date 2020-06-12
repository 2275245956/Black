import 'dart:convert' show json;
class CheckItem {

  String defaultValue;
  String inputJson;
  int catalogId;
  String classifyIds;
  String createBy;
  int createDate;
  int id;
  int orderNo;
  int pOrderNo;
  int pointItemId;
  bool isDelete;
  String dataJson;
  String isMultiline;
  String isMust;
  String isScore;
  String itemType;
  String name;
  String orgCode;
  String pictureJson;
  String remark;
  bool isChecked = false;
  List<ItemPictureInfo> pictureInfo;
  num routePointItemId;
  // 页面item唯一标识 20190621
  String uniqueKey;

  CheckItem.fromParams({
    this.defaultValue,
    this.inputJson,
    this.catalogId,
    this.classifyIds,
    this.createBy,
    this.createDate,
    this.id,
    this.orderNo,
    this.pOrderNo,
    this.pointItemId,
    this.isDelete,
    this.dataJson,
    this.isMultiline,
    this.isMust,
    this.isScore,
    this.itemType,
    this.name,
    this.orgCode,
    this.pictureJson,
    this.remark,
    this.routePointItemId,
    this.uniqueKey
  });

  factory CheckItem(jsonStr) => jsonStr == null ? null : jsonStr is String ? new CheckItem.fromJson(json.decode(jsonStr)) : new CheckItem.fromJson(jsonStr);

  CheckItem.fromJson(jsonRes) {
    defaultValue = jsonRes['defaultValue'];
    inputJson = jsonRes['inputJson'];
    catalogId = jsonRes['catalogId'];
    classifyIds = jsonRes['classifyIds'];
    createBy = jsonRes['createBy'];
    createDate = jsonRes['createDate'];
    id = jsonRes['id'];
    orderNo = jsonRes['orderNo'];
    pOrderNo = jsonRes['pOrderNo'];
    pointItemId = jsonRes['pointItemId'];
    isDelete = jsonRes['isDelete'];
    dataJson = jsonRes['dataJson'];
    isMultiline = jsonRes['isMultiline'];
    isMust = jsonRes['isMust'];
    isScore = jsonRes['isScore'];
    itemType = jsonRes['itemType'];
    name = jsonRes['name'];
    orgCode = jsonRes['orgCode'];
    pictureJson = jsonRes['pictureJson'];
    remark = jsonRes['remark'];
    routePointItemId = jsonRes['routePointItemId'];
    uniqueKey = jsonRes['uniqueKey'];
  }

  @override
  String toString() {
    return '{"defaultValue": ${defaultValue != null?'${json.encode(defaultValue)}':'null'},"inputJson": ${inputJson != null?'${json.encode(inputJson)}':'null'},"catalogId": $catalogId,"classifyIds": $classifyIds,"createBy": $createBy,"createDate": $createDate,"id": $id,"orderNo": $orderNo,"pOrderNo": $pOrderNo,"pointItemId": $pointItemId,"isDelete": $isDelete,"dataJson": ${dataJson != null?'${json.encode(dataJson)}':'null'},"isMultiline": ${isMultiline != null?'${json.encode(isMultiline)}':'null'},"isMust": ${isMust != null?'${json.encode(isMust)}':'null'},"isScore": ${isScore != null?'${json.encode(isScore)}':'null'},"itemType": ${itemType != null?'${json.encode(itemType)}':'null'},"name": ${name != null?'${json.encode(name)}':'null'},"orgCode": ${orgCode != null?'${json.encode(orgCode)}':'null'},"pictureJson": ${pictureJson != null?'${json.encode(pictureJson)}':'null'},"remark": ${remark != null?'${json.encode(remark)}':'null'}}';
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