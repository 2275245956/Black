import 'dart:convert' show json;

class TaskContent {

int id;
String STATUS;
String executor;
int publish_time;
String title;
TaskContent.fromParams({this.id, this.STATUS, this.executor, this.publish_time, this.title});

factory TaskContent(jsonStr) => jsonStr == null ? null : jsonStr is String ? new TaskContent.fromJson(json.decode(jsonStr)) : new TaskContent.fromJson(jsonStr);

TaskContent.fromJson(jsonRes) {
id = jsonRes['id'];
STATUS = jsonRes['STATUS'];
executor = jsonRes['executor'];
publish_time = jsonRes['publish_time'];
title = jsonRes['title'];
}

@override
String toString() {
return '{"id": $id,"STATUS": ${STATUS != null?'${json.encode(STATUS)}':'null'},"executor": ${executor != null?'${json.encode(executor)}':'null'},"publish_time": ${publish_time != null?'${json.encode(publish_time)}':'null'},"title": ${title != null?'${json.encode(title)}':'null'}}';
}
}

