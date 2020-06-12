import 'dart:convert' show json;

import 'package:intelligent_check_new/model/CheckPoint.dart';

class CheckPointDetail {

  List<Classify> classify;
  List<InputItem> inputItems;
  List<Route> routes;
  CheckPoint point;

  CheckPointDetail.fromParams({this.classify, this.inputItems, this.routes, this.point});

  factory CheckPointDetail(jsonStr) => jsonStr == null ? null : jsonStr is String ? new CheckPointDetail.fromJson(json.decode(jsonStr)) : new CheckPointDetail.fromJson(jsonStr);

  CheckPointDetail.fromJson(jsonRes) {
    classify = jsonRes['classify'] == null ? null : [];

    for (var classifyItem in classify == null ? [] : jsonRes['classify']){
      classify.add(classifyItem == null ? null : new Classify.fromJson(classifyItem));
    }

    inputItems = jsonRes['inputItems'] == null ? null : [];

    for (var inputItemsItem in inputItems == null ? [] : jsonRes['inputItems']){
      inputItems.add(inputItemsItem == null ? null : new InputItem.fromJson(inputItemsItem));
    }

    routes = jsonRes['routes'] == null ? null : [];

    for (var routesItem in routes == null ? [] : jsonRes['routes']){
      routes.add(routesItem == null ? null : new Route.fromJson(routesItem));
    }

    point = jsonRes['point'] == null ? null : new CheckPoint.fromJson(jsonRes['point']);
  }

  @override
  String toString() {
    return '{"classify": $classify,"inputItems": $inputItems,"routes": $routes,"point": $point}';
  }
}

class Route {

  int pointId;
  String routeName;

  Route.fromParams({this.pointId, this.routeName});

  Route.fromJson(jsonRes) {
    pointId = jsonRes['pointId'];
    routeName = jsonRes['routeName'];
  }

  @override
  String toString() {
    return '{"pointId": $pointId,"routeName": ${routeName != null?'${json.encode(routeName)}':'null'}}';
  }
}

class InputItem {

  int inputItemNO;
  int pointId;
  String inputItenName;

  InputItem.fromParams({this.inputItemNO, this.pointId, this.inputItenName});

  InputItem.fromJson(jsonRes) {
    inputItemNO = jsonRes['inputItemNO'];
    pointId = jsonRes['pointId'];
    inputItenName = jsonRes['inputItenName'];
  }

  @override
  String toString() {
    return '{"inputItemNO": $inputItemNO,"pointId": $pointId,"inputItenName": ${inputItenName != null?'${json.encode(inputItenName)}':'null'}}';
  }
}

class Classify {

  int pointId;
  String classifyName;

  Classify.fromParams({this.pointId, this.classifyName});

  Classify.fromJson(jsonRes) {
    pointId = jsonRes['pointId'];
    classifyName = jsonRes['classifyName'];
  }

  @override
  String toString() {
    return '{"pointId": $pointId,"classifyName": ${classifyName != null?'${json.encode(classifyName)}':'null'}}';
  }
}

