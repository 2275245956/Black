import 'dart:convert';
class PlanListInput {
  String userId;//-1:全部
  String startTime;
  String endTime;
  int finishStatus;//-1:所有
  String orderBy;
  int departmentId;//-1:所有
  int routeId;//-1:所有
  @override
  String toString() {
    return '{"userId": $userId,"startTime": ${startTime != null?'${json.encode(startTime)}':'null'}'
        ',"endTime": ${endTime != null?'${json.encode(endTime)}':'null'},'
        '"finishStatus": $finishStatus,"orderBy": ${orderBy != null?'${json.encode(orderBy)}':'null'}'
        ',"departmentId": $departmentId,"routeId": $routeId}';
  }}