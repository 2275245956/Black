import 'package:intl/intl.dart';

class DateUtil{
  static String timestampToDate(int timestamp){
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
    return date.toString()!=null && date.toString().length > 19?date.toString().substring(0,19):date.toString();
  }

  static String readTimestamp(int timestamp) {
    var onehour = 60*60*1000;
    var format = new DateFormat('yyyy-MM-dd H:mm:ss');
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp + 8*onehour);
    var time = '';
    time = format.format(date);
    return time;
  }
}