import 'dart:convert';

class TaskContentInput {
  String executorId; //-1:全部
  String startTime;
  String endTime;
  int publisher; //-1:所有
  int departmentId;
  // @override
  TaskContentInput() {
    executorId = "";
    startTime = "";
    endTime = "";
    publisher = -1;
  }
  String toString() {
    return '{"executorId": $executorId,"startTime": ${startTime != null ? '${json.encode(startTime)}' : 'null'}'
        ',"endTime": ${endTime != null ? '${json.encode(endTime)}' : 'null'},'
        '"publisher": $publisher,"departmentId": $departmentId}';
  }
}
