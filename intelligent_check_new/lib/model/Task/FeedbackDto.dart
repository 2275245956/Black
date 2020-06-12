import 'dart:convert' show json;

class FeedbackDto {

  int pictureNumber;
  int taskID;
  String message;
  List<String> imgbase64;

  FeedbackDto.fromParams({this.pictureNumber, this.taskID, this.message, this.imgbase64});

  factory FeedbackDto(jsonStr) => jsonStr == null ? null : jsonStr is String ? new FeedbackDto.fromJson(json.decode(jsonStr)) : new FeedbackDto.fromJson(jsonStr);

  FeedbackDto.fromJson(jsonRes) {
    pictureNumber = jsonRes['pictureNumber'];
    taskID = jsonRes['taskID'];
    message = jsonRes['message'];
    imgbase64 = jsonRes['imgbase64'] == null ? null : [];

    for (var imgbase64Item in imgbase64 == null ? [] : jsonRes['imgbase64']){
      imgbase64.add(imgbase64Item);
    }
  }

  @override
  String toString() {
    return '{"pictureNumber": $pictureNumber,"taskID": $taskID,"message": ${message != null?'${json.encode(message)}':'null'},"imgbase64": ${imgbase64 != null?'${json.encode(imgbase64)}':'[]'}}';
  }
}

