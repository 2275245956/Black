import 'dart:convert' show json;

class TaskList {
  List<Task> list;
}

class Task {
  //任务名称
  String taskName;
  //发起人
  String sponsor;
  //执行人
  String executive;
  //可转发次数
  num forwardsTimes;
  //状态 待处理：1，已完成：2，未完成：3，已取消：4
  int taskState;
  //创建时间
  String creationTime;
  //要求完成时间
  String requestTime;
  //巡检点
  String patrolPoint;
  //关联检查项（业务相关，待定）
  //任务说明
  String description;
  //处理信息
  String processingInformation;
  //反馈信息
  String feedback;
  //拍照点名称（用图片链接list？）
  List<String> photoList;

  Task(
      String itaskName,
      String isponsor,
      String iexecutive,
      num iforwardsTimes,
      int itaskState,
      String icreationTime,
      String irequestTime,
      String ipatrolPoint,
      String idescription,
      String iprocessingInformation,
      String ifeedback,
      List<String> iphotoList) {
    taskName = itaskName;
    sponsor = isponsor;
    executive = iexecutive;
    forwardsTimes = iforwardsTimes;
    taskState = itaskState;
    creationTime = icreationTime;
    requestTime = irequestTime;
    patrolPoint = ipatrolPoint;
    description = idescription;
    processingInformation = iprocessingInformation;
    feedback = ifeedback;
    photoList = iphotoList;
  }
  /* Task.fromParams({this.value, this.name});

  Task.fromJson(jsonRes) {
    value = jsonRes['value'];
    name = jsonRes['name'];
  }

  @override
  String toString() {
    return '{"value": $value,"name": ${name != null ? '${json.encode(name)}' : 'null'}}';
  }
  */
}
