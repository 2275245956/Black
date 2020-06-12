import 'dart:convert' show json;

class CalendarModel {

  int count;
  int omission;
  int qualified;
  int unqualified;
  List<CalendarDataModel> calendarData;

  CalendarModel.fromParams({this.count, this.omission, this.qualified, this.unqualified});

  factory CalendarModel(jsonStr) => jsonStr == null ? null : jsonStr is String ? new CalendarModel.fromJson(json.decode(jsonStr)) : new CalendarModel.fromJson(jsonStr);

  CalendarModel.  fromJson(jsonRes) {
    count = jsonRes['count'];
    omission = jsonRes['omission'];
    qualified = jsonRes['qualified'];
    unqualified = jsonRes['unqualified'];
  }

  @override
  String toString() {
    return '{"count": $count,"omission": $omission,"qualified": $qualified,"unqualified": $unqualified}';
  }
}

class CalendarDataModel {

  num omission;
  num qualified;
  num unqualified;
  String date;

  CalendarDataModel.fromParams({this.omission, this.qualified, this.unqualified, this.date});

  factory CalendarDataModel(jsonStr) => jsonStr == null ? null : jsonStr is String ? new CalendarDataModel.fromJson(json.decode(jsonStr)) : new CalendarDataModel.fromJson(jsonStr);

  CalendarDataModel.fromJson(jsonRes) {
    omission = jsonRes['omission'];
    qualified = jsonRes['qualified'];
    unqualified = jsonRes['unqualified'];
    date = jsonRes['date'];
  }

  @override
  String toString() {
    return '{"omission": $omission,"qualified": $qualified,"unqualified": $unqualified,"date": ${date != null?'${json.encode(date)}':'null'}}';
  }
}